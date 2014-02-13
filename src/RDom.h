#ifndef HALIDE_RDOM_H
#define HALIDE_RDOM_H

/** \file
 * Defines the front-end syntax for reduction domains and reduction
 * variables.
 */

#include "IR.h"
#include "Param.h"

namespace Halide {

/** A reduction variable represents a single dimension of a reduction
 * domain (RDom). Don't construct them directly, instead construct an
 * RDom, and use RDom::operator[] to get at the variables. For
 * single-dimensional reduction domains, you can just cast a
 * single-dimensional RDom to an RVar. */
class RVar {
    std::string _name;
    Expr _min, _extent;
    Internal::ReductionDomain domain;
public:
    /** An empty reduction variable. This constructor only exists so
     * we can make vectors of RVars */
    RVar() {}

    /** Construct a reduction variable with the given name and
     * bounds. Must be a member of the given reduction domain. */
    RVar(std::string __name, Expr __min, Expr __extent, Internal::ReductionDomain _domain) :
        _name(__name), _min(__min), _extent(__extent), domain(_domain) {}

    /** The minimum value that this variable will take on */
    Expr min() const {return _min;}

    /** The number that this variable will take on. The maximum value
     * of this variable will be min() + extent() - 1 */
    Expr extent() const {return _extent;}

    /** The name of this reduction variable */
    const std::string &name() const {return _name;}

    /** Reduction variables can be used as expressions. */
    EXPORT operator Expr() const;
};

/** A multi-dimensional domain over which to iterate. Used when
 * defining functions as reductions.
 *
 * A reduction is a function with a two-part definition. It has an
 * initial value, which looks much like a pure function, and an update
 * rule, which refers to some RDom. Evaluating such a function first
 * initializes it over the required domain (which is inferred based on
 * usage), and then runs update rule for all points in the RDom. For
 * example:
 *
 \code
 Func f;
 Var x;
 RDom r(0, 10);
 f(x) = x; // the initial value
 f(r) = f(r) * 2;
 Image<int> result = f.realize(10);
 \endcode
 *
 * This function creates a single-dimensional buffer of size 10, in
 * which element x contains the value x*2. Internally, first the
 * initialization rule fills in x at every site, and then the update
 * rule doubles every site.
 *
 * One use of reductions is to build a function recursively (pure
 * functions in halide cannot be recursive). For example, this
 * function fills in an array with the first 20 fibonacci numbers:
 *
 \code
 Func f;
 Var x;
 RDom r(2, 18);
 f(x) = 1;
 f(r) = f(r-1) + f(r-2);
 \endcode
 *
 * Another use of reductions is to perform scattering operations, as
 * unlike a pure function declaration, the left-hand-side of a
 * reduction definition may contain general expressions:
 *
 \code
 ImageParam input(UInt(8), 2);
 Func histogram;
 Var x;
 RDom r(input); // Iterate over all pixels in the input
 histogram(x) = 0;
 histogram(input(r.x, r.y)) = histogram(input(r.x, r.y)) + 1;
 \endcode
 *
 * A reduction definition may also be multi-dimensional. This example
 * computes a summed-area table by first summing horizontally and then
 * vertically:
 *
 \code
 ImageParam input(Float(32), 2);
 Func sum_x, sum_y;
 Var x, y;
 RDom r(input);
 sum_x(x, y)     = input(x, y);
 sum_x(r.x, r.y) = sum_x(r.x, r.y) + sum_x(r.x-1, r.y);
 sum_y(x, y)     = sum_x(x, y);
 sum_y(r.x, r.y) = sum_y(r.x, r.y) + sum_y(r.x, r.y-1);
 \endcode
 *
 * You can also mix pure dimensions with reduction variables. In the
 * previous example, note that there's no need for the y coordinate in
 * sum_x to be traversed serially. The sum within each row is entirely
 * independent. The rows could be computed in parallel, or in a
 * different order, without changing the meaning. Therefore, we can
 * instead write this definition as follows:
 *
 \code
 ImageParam input(Float(32), 2);
 Func sum_x, sum_y;
 Var x, y;
 RDom r(input);
 sum_x(x, y)   = input(x, y);
 sum_x(r.x, y) = sum_x(r.x, y) + sum_x(r.x-1, y);
 sum_y(x, y)   = sum_x(x, y);
 sum_y(x, r.y) = sum_y(x, r.y) + sum_y(x, r.y-1);
 \endcode
 *
 * This lets us schedule it more flexibly. You can now parallelize the
 * update step of sum_x over y by calling:
 \code
 sum_x.update().parallel(y).
 \endcode
 *
 * Note that calling sum_x.parallel(y) only parallelizes the
 * initialization step, and not the update step! Scheduling the update
 * step of a reduction must be done using the handle returned by
 * \ref Func::update(). This code parallelizes both the initialization
 * step and the update step:
 *
 \code
 sum_x.parallel(y);
 sum_x.update().parallel(y);
 \endcode
 *
 * When you mix reduction variables and pure dimensions, the reduction
 * domain is traversed outermost. That is, for each point in the
 * reduction domain, the inferred pure domain is traversed in its
 * entirety. For the above example, this means that sum_x walks down
 * the columns, and sum_y walks along the rows. This may not be
 * cache-coherent, but you may not reorder these dimensions using the
 * schedule, as it risks changing the meaning of your function (even
 * though it doesn't in this case). The solution lies in clever
 * scheduling. If we say:
 *
 \code
 sum_x.compute_at(sum_y, r.y);
 \endcode
 *
 * Then the sum in x is computed only as necessary for each scanline
 * of the sum in y. This not only results in sum_x walking along the
 * rows, it also improves the locality of the entire pipeline.
 */
class RDom {
    Internal::ReductionDomain domain;
public:
    /** Construct an undefined reduction domain. */
    EXPORT RDom() {}

    /** Construct a single-dimensional reduction domain with the given
     * name. If the name is left blank, a unique one is
     * auto-generated. */
    EXPORT RDom(Expr min, Expr extent, std::string name = "");

    /** Construct a two-dimensional reduction domain with the given
     * name. If the name is left blank, a unique one is
     * auto-generated. */
    EXPORT RDom(Expr min0, Expr extent0, Expr min1, Expr extent1, std::string name = "");

    /** Construct a three-dimensional reduction domain with the given
     * name. If the name is left blank, a unique one is
     * auto-generated. */
    EXPORT RDom(Expr min0, Expr extent0, Expr min1, Expr extent1, Expr min2, Expr extent2, std::string name = "");

    /** Construct a four-dimensional reduction domain with the given
     * name. If the name is left blank, a unique one is
     * auto-generated. */
    EXPORT RDom(Expr min0, Expr extent0, Expr min1, Expr extent1, Expr min2, Expr extent2, Expr min3, Expr extent3, std::string name = "");
    /** Construct a reduction domain that iterates over all points in
     * a given Buffer, Image, or ImageParam. Has the same
     * dimensionality as the argument. */
    // @{
    EXPORT RDom(Buffer);
    EXPORT RDom(ImageParam);
    // @}

    /** Construct a reduction domain that wraps an Internal ReductionDomain object. */
    EXPORT RDom(Internal::ReductionDomain d);

    /** Check if this reduction domain is non-NULL */
    bool defined() const {return domain.defined();}

    /** Compare two reduction domains for equality of reference */
    bool same_as(const RDom &other) const {return domain.same_as(other.domain);}

    /** Get the dimensionality of a reduction domain */
    EXPORT int dimensions() const;

    /** Get at one of the dimensions of the reduction domain */
    EXPORT RVar operator[](int);

    /** Single-dimensional reduction domains can be used as RVars directly. */
    EXPORT operator RVar() const;

    /** Single-dimensional reduction domains can be also be used as Exprs directly. */
    EXPORT operator Expr() const;

    /** Direct access to the four dimensions of the reduction
     * domain. Some of these dimensions may be undefined if the
     * reduction domain has fewer than four dimensions. */
    // @{
    RVar x, y, z, w;
    // @}
};

/** Emit an RVar in a human-readable form */
std::ostream &operator<<(std::ostream &stream, RVar);

/** Emit an RDom in a human-readable form. */
std::ostream &operator<<(std::ostream &stream, RDom);
}

#endif