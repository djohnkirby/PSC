#include "SkipStages.h"
#include "IRMutator.h"
#include "IRPrinter.h"
#include "IROperator.h"
#include "Scope.h"
#include "Simplify.h"
#include "Substitute.h"
#include "ExprUsesVar.h"

namespace Halide {
namespace Internal {

using std::string;
using std::vector;
using std::map;

class PredicateFinder : public IRVisitor {
public:
    Expr predicate;
    PredicateFinder(const string &b) : predicate(const_false()), buffer(b), varies(false) {}

private:

    using IRVisitor::visit;
    string buffer;
    bool varies;
    Scope<int> varying;

    void visit(const Variable *op) {
        bool this_varies = varying.contains(op->name);
        varies |= this_varies;
    }

    void visit(const For *op) {
        op->min.accept(this);
        op->extent.accept(this);
        if (!is_one(op->extent)) {
            varying.push(op->name, 0);
        }
        op->body.accept(this);
        if (!is_one(op->extent)) {
            varying.pop(op->name);
        } else {
            predicate = substitute(op->name, op->min, predicate);
        }
    }

    template<typename T>
    void visit_let(const std::string &name, Expr value, T body) {
        bool old_varies = varies;
        varies = false;
        value.accept(this);
        bool value_varies = varies;
        varies |= old_varies;
        if (value_varies) {
            varying.push(name, 0);
        }
        body.accept(this);
        if (value_varies) {
            varying.pop(name);
        }
        predicate = substitute(name, value, predicate);
    }

    void visit(const LetStmt *op) {
        visit_let(op->name, op->value, op->body);
    }

    void visit(const Let *op) {
        visit_let(op->name, op->value, op->body);
    }

    void visit(const Pipeline *op) {
        if (op->name != buffer) {
            op->produce.accept(this);
            if (op->update.defined()) {
                op->update.accept(this);
            }
        }
        op->consume.accept(this);
    }

    template<typename T>
    void visit_conditional(Expr condition, T true_case, T false_case) {
        Expr old_predicate = predicate;

        predicate = const_false();
        true_case.accept(this);
        Expr true_predicate = predicate;

        predicate = const_false();
        if (false_case.defined()) false_case.accept(this);
        Expr false_predicate = predicate;

        bool old_varies = varies;
        predicate = const_false();
        varies = false;
        condition.accept(this);

        if (is_one(predicate) || is_one(old_predicate)) {
            predicate = const_true();
        } else if (varies) {
            if (is_one(true_predicate) || is_one(false_predicate)) {
                predicate = const_true();
            } else {
                predicate = (old_predicate || predicate ||
                             true_predicate || false_predicate);
            }
        } else {
            predicate = (old_predicate || predicate ||
                         (condition && true_predicate) ||
                         ((!condition) && false_predicate));
        }

        varies = varies || old_varies;
    }

    void visit(const Select *op) {
        visit_conditional(op->condition, op->true_value, op->false_value);
    }

    void visit(const IfThenElse *op) {
        visit_conditional(op->condition, op->then_case, op->else_case);
    }

    void visit(const Call *op) {
        IRVisitor::visit(op);

        if (op->name == buffer) {
            predicate = const_true();
        }
    }
};

class ProductionGuarder : public IRMutator {
public:
    ProductionGuarder(const string &b, Expr p): buffer(b), predicate(p) {}
private:
    string buffer;
    Expr predicate;

    using IRMutator::visit;

    void visit(const Pipeline *op) {
        // If the predicate at this stage depends on something
        // vectorized we should bail out.
        if (op->name == buffer) {
            Stmt produce = op->produce, update = op->update;
            if (update.defined()) {
                Expr predicate_var = Variable::make(Bool(), buffer + ".needed");
                Stmt produce = IfThenElse::make(predicate_var, op->produce);
                Stmt update = IfThenElse::make(predicate_var, op->update);
                stmt = Pipeline::make(op->name, produce, update, op->consume);
                stmt = LetStmt::make(buffer + ".needed", predicate, stmt);
            } else {
                Stmt produce = IfThenElse::make(predicate, op->produce);
                stmt = Pipeline::make(op->name, produce, Stmt(), op->consume);
            }

        } else {
            IRMutator::visit(op);
        }
    }
};

class StageSkipper : public IRMutator {
public:
    StageSkipper(const string &f) : func(f) {}
private:
    string func;
    using IRMutator::visit;

    Scope<int> vector_vars;
    bool in_vector_loop;

    void visit(const For *op) {
        bool old_in_vector_loop = in_vector_loop;

        // We want to be sure that the predicate doesn't vectorize.
        if (op->for_type == For::Vectorized) {
            vector_vars.push(op->name, 0);
            in_vector_loop = true;
        }

        IRMutator::visit(op);

        if (op->for_type == For::Vectorized) {
            vector_vars.pop(op->name);
        }

        in_vector_loop = old_in_vector_loop;
    }

    void visit(const LetStmt *op) {
        bool should_pop = false;
        if (in_vector_loop &&
            expr_uses_vars(op->value, vector_vars)) {
            should_pop = true;
            vector_vars.push(op->name, 0);
        }

        IRMutator::visit(op);

        if (should_pop) {
            vector_vars.pop(op->name);
        }
    }

    void visit(const Realize *op) {
        if (op->name == func) {
            PredicateFinder f(op->name);
            op->body.accept(&f);
            Expr predicate = simplify(f.predicate);

            if (expr_uses_vars(predicate, vector_vars)) {
                // Don't try to skip stages if the predicate may vary
                // per lane. This will just unvectorize the
                // production, which is probably contrary to the
                // intent of the user.
                predicate = const_true();
            }

            debug(3) << "Realization " << op->name << " only used when " << predicate << "\n";
            if (!is_one(predicate)) {
                ProductionGuarder g(op->name, predicate);
                Stmt body = g.mutate(op->body);
                // In the future we may be able to shrink the size
                // updated, but right now those values may be
                // loaded. They can be incorrect, but they must be
                // loadable. Perhaps we can mmap some readable junk memory
                // (e.g. lots of pages of /dev/zero).
                stmt = Realize::make(op->name, op->types, op->bounds, body);
            } else {
                IRMutator::visit(op);
            }
        } else {
            IRMutator::visit(op);
        }
    }
};

// Check if all calls to a given function are behind an if of some
// sort (but don't worry about what it is).
class MightBeSkippable : public IRVisitor {

    using IRVisitor::visit;

    void visit(const Call *op) {
        IRVisitor::visit(op);
        if (op->name == func) {
            if (!found_call) {
                result = guarded;
                found_call = true;
            } else {
                result &= guarded;
            }
        }
    }


    void visit(const IfThenElse *op) {
        op->condition.accept(this);

        bool old = guarded;
        guarded = true;

        op->then_case.accept(this);
        if (op->else_case.defined()) {
            op->else_case.accept(this);
        }

        guarded = old;
    }

    void visit(const Select *op) {
        op->condition.accept(this);

        bool old = guarded;
        guarded = true;

        op->true_value.accept(this);
        op->false_value.accept(this);

        guarded = old;
    }

    void visit(const Realize *op) {
        if (op->name == func) {
            guarded = false;
        }
        IRVisitor::visit(op);
    }

    void visit(const Pipeline *op) {
        if (op->name == func) {
            op->consume.accept(this);
        } else {
            IRVisitor::visit(op);
        }
    }

    string func;
    bool guarded;

public:
    bool result;
    bool found_call;

    MightBeSkippable(string f) : func(f), result(false), found_call(false) {}
};

Stmt skip_stages(Stmt stmt, const vector<string> &order) {
    for (size_t i = order.size()-1; i > 0; i--) {
        MightBeSkippable check(order[i-1]);
        stmt.accept(&check);
        if (check.result) {
            StageSkipper skipper(order[i-1]);
            stmt = skipper.mutate(stmt);
        }
    }
    return stmt;
}

}
}
