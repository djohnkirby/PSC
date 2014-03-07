#include <sstream>

#include "CodeGen_OpenCL_Dev.h"
#include "Debug.h"

// TODO: This needs a runtime controlled switch based on the device extension
// string.
//#define ENABLE_CL_KHR_FP64

namespace Halide {
namespace Internal {

using std::ostringstream;
using std::string;
using std::vector;

static ostringstream nil;

CodeGen_OpenCL_Dev::CodeGen_OpenCL_Dev() {
    clc = new CodeGen_OpenCL_C(src_stream);
}

string CodeGen_OpenCL_Dev::CodeGen_OpenCL_C::print_type(Type type) {
    ostringstream oss;
    assert(type.width == 1 && "Can't codegen vector types to OpenCL C (yet)");
    if (type.is_float()) {
        if (type.bits == 16) {
            oss << "half";
        } else if (type.bits == 32) {
            oss << "float";
        } else if (type.bits == 64) {
            oss << "double";
        } else {
            assert(false && "Can't represent a float with this many bits in OpenCL C");
        }

    } else {
        if (type.is_uint() && type.bits > 1) oss << 'u';
        switch (type.bits) {
        case 1:
            oss << "bool";
            break;
        case 8:
            oss << "char";
            break;
        case 16:
            oss << "short";
            break;
        case 32:
            oss << "int";
            break;
        case 64:
            oss << "long";
            break;
        default:
            assert(false && "Can't represent an integer with this many bits in OpenCL C");
        }
    }
    return oss.str();
}

string CodeGen_OpenCL_Dev::CodeGen_OpenCL_C::print_reinterpret(Type type, Expr e) {
    ostringstream oss;
    oss << "as_" << print_type(type) << "(" << print_expr(e) << ")";
    return oss.str();
}



namespace {
Expr simt_intrinsic(const string &name) {
    if (ends_with(name, ".threadidx")) {
        return Call::make(Int(32), "get_local_id", vec(Expr(0)), Call::Extern);
    } else if (ends_with(name, ".threadidy")) {
        return Call::make(Int(32), "get_local_id", vec(Expr(1)), Call::Extern);
    } else if (ends_with(name, ".threadidz")) {
        return Call::make(Int(32), "get_local_id", vec(Expr(2)), Call::Extern);
    } else if (ends_with(name, ".threadidw")) {
        return Call::make(Int(32), "get_local_id", vec(Expr(3)), Call::Extern);
    } else if (ends_with(name, ".blockidx")) {
        return Call::make(Int(32), "get_group_id", vec(Expr(0)), Call::Extern);
    } else if (ends_with(name, ".blockidy")) {
        return Call::make(Int(32), "get_group_id", vec(Expr(1)), Call::Extern);
    } else if (ends_with(name, ".blockidz")) {
        return Call::make(Int(32), "get_group_id", vec(Expr(2)), Call::Extern);
    } else if (ends_with(name, ".blockidw")) {
        return Call::make(Int(32), "get_group_id", vec(Expr(3)), Call::Extern);
    }
    assert(false && "simt_intrinsic called on bad variable name");
    return Expr();
}
}

void CodeGen_OpenCL_Dev::CodeGen_OpenCL_C::visit(const For *loop) {
    if (is_gpu_var(loop->name)) {
        debug(0) << "Dropping loop " << loop->name << " (" << loop->min << ", " << loop->extent << ")\n";
        assert(loop->for_type == For::Parallel && "kernel loop must be parallel");

        Expr simt_idx = simt_intrinsic(loop->name);
        Expr loop_var = Add::make(loop->min, simt_idx);
        Expr cond = LT::make(simt_idx, loop->extent);
        debug(0) << "for -> if (" << cond << ")\n";

        string id_idx = print_expr(simt_idx);
        string id_cond = print_expr(cond);

        do_indent();
        stream << "if (" << id_cond << ")\n";

        open_scope();
        do_indent();
        stream << print_type(Int(32)) << " " << print_name(loop->name) << " = " << id_idx << ";\n";
        loop->body.accept(this);
        close_scope("for " + id_cond);

    } else {
    	assert(loop->for_type != For::Parallel && "Cannot emit parallel loops in OpenCL C");
    	CodeGen_C::visit(loop);
    }
}

void CodeGen_OpenCL_Dev::add_kernel(Stmt s, string name, const vector<Argument> &args) {
    debug(0) << "hi CodeGen_OpenCL_Dev::compile! " << name << "\n";

    // TODO: do we have to uniquify these names, or can we trust that they are safe?
    cur_kernel_name = name;
    clc->add_kernel(s, name, args);
}

namespace {
const string kernel_preamble = "";
}

void CodeGen_OpenCL_Dev::CodeGen_OpenCL_C::add_kernel(Stmt s, string name, const vector<Argument> &args) {
    debug(0) << "hi! " << name << "\n";

    stream << kernel_preamble;

    // Emit the function prototype
    stream << "__kernel void " << name << "(\n";
    for (size_t i = 0; i < args.size(); i++) {
        if (args[i].is_buffer) {
            stream << " __global " << print_type(args[i].type) << " *"
                   << print_name(args[i].name);
            allocations.push(args[i].name, args[i].type);
        } else {
            stream << " const "
                   << print_type(args[i].type)
                   << " "
                   << print_name(args[i].name);
        }

        if (i < args.size()-1) stream << ",\n";
    }
    stream << ",\n" << "__local uchar* shared";

    stream << ") {\n";

    print(s);

    stream << "}\n";

    // Remove buffer arguments from allocation scope
    for (size_t i = 0; i < args.size(); i++) {
        if (args[i].is_buffer) {
            allocations.pop(args[i].name);
        }
    }
}

void CodeGen_OpenCL_Dev::init_module() {
    debug(0) << "OpenCL device codegen init_module\n";

    // wipe the internal kernel source
    src_stream.str("");
    src_stream.clear();

    // This identifies the program as OpenCL C (as opposed to SPIR).
    src_stream << "/*OpenCL C*/\n";

#ifdef ENABLE_CL_KHR_FP64
    src_stream << "#pragma OPENCL EXTENSION cl_khr_fp64 : enable\n";
#endif
    src_stream << "#pragma OPENCL FP_CONTRACT ON\n";

    // Write out the Halide math functions.
    src_stream << "float nan_f32() { return NAN; }\n"
               << "float neg_inf_f32() { return -INFINITY; }\n"
               << "float inf_f32() { return INFINITY; }\n"
               << "float float_from_bits(unsigned int x) {return as_float(x);}\n"
               << "float sqrt_f32(float x) { return sqrt(x); }\n"
               << "float sin_f32(float x) { return sin(x); }\n"
               << "float cos_f32(float x) { return cos(x); }\n"
               << "float exp_f32(float x) { return exp(x); }\n"
               << "float log_f32(float x) { return log(x); }\n"
               << "float abs_f32(float x) { return fabs(x); }\n"
               << "float floor_f32(float x) { return floor(x); }\n"
               << "float ceil_f32(float x) { return ceil(x); }\n"
               << "float round_f32(float x) { return round(x); }\n"
               << "float pow_f32(float x, float y) { return pow(x, y); }\n"
               << "float asin_f32(float x) { return asin(x); }\n"
               << "float acos_f32(float x) { return acos(x); }\n"
               << "float tan_f32(float x) { return tan(x); }\n"
               << "float atan_f32(float x) { return atan(x); }\n"
               << "float atan2_f32(float y, float x) { return atan2(y, x); }\n"
               << "float sinh_f32(float x) { return sinh(x); }\n"
               << "float asinh_f32(float x) { return asinh(x); }\n"
               << "float cosh_f32(float x) { return cosh(x); }\n"
               << "float acosh_f32(float x) { return acosh(x); }\n"
               << "float tanh_f32(float x) { return tanh(x); }\n"
               << "float atanh_f32(float x) { return atanh(x); }\n";

#ifdef ENABLE_CL_KHR_FP64
    src_stream << "double sqrt_f64(double x) { return sqrt(x); }\n"
               << "double sin_f64(double x) { return sin(x); }\n"
               << "double cos_f64(double x) { return cos(x); }\n"
               << "double exp_f64(double x) { return exp(x); }\n"
               << "double log_f64(double x) { return log(x); }\n"
               << "double abs_f64(double x) { return fabs(x); }\n"
               << "double floor_f64(double x) { return floor(x); }\n"
               << "double ceil_f64(double x) { return ceil(x); }\n"
               << "double round_f64(double x) { return round(x); }\n"
               << "double pow_f64(double x, double y) { return pow(x, y); }\n"
               << "double asin_f64(double x) { return asin(x); }\n"
               << "double acos_f64(double x) { return acos(x); }\n"
               << "double tan_f64(double x) { return tan(x); }\n"
               << "double atan_f64(double x) { return atan(x); }\n"
               << "double atan2_f64(double y, double x) { return atan2(y, x); }\n"
               << "double sinh_f64(double x) { return sinh(x); }\n"
               << "double asinh_f64(double x) { return asinh(x); }\n"
               << "double cosh_f64(double x) { return cosh(x); }\n"
               << "double acosh_f64(double x) { return acosh(x); }\n"
               << "double tanh_f64(double x) { return tanh(x); }\n"
               << "double atanh_f64(double x) { return atanh(x); }\n";
#endif

    src_stream << '\n';

    // Add at least one kernel to avoid errors on some implementations for functions
    // without any GPU schedules.
    src_stream << "__kernel void _at_least_one_kernel(int x) { }\n";

    cur_kernel_name = "";
}

vector<char> CodeGen_OpenCL_Dev::compile_to_src() {
    string str = src_stream.str();
    vector<char> buffer(str.begin(), str.end());
    buffer.push_back(0);
    return buffer;
}

string CodeGen_OpenCL_Dev::get_current_kernel_name() {
    return cur_kernel_name;
}

void CodeGen_OpenCL_Dev::dump() {
    std::cerr << src_stream.str() << std::endl;
}

}}
