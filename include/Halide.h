// Always use assert, even if llvm-config defines NDEBUG
#ifdef NDEBUG
#undef NDEBUG
#include <assert.h>
#define NDEBUG
#else
#include <assert.h>
#endif

#ifndef HALIDE_UTIL_H
#define HALIDE_UTIL_H

/** \file
 * Various utility functions used internally Halide. */

#include <vector>
#include <string>
#include <cstring>

// by default, the symbol EXPORT does nothing. In windows dll builds we can define it to __declspec(dllexport)
#ifdef _WINDOWS_DLL
#define EXPORT __declspec(dllexport)
#else
#ifdef _WIN32
#define EXPORT __declspec(dllimport)
#else
#define EXPORT
#endif
#endif

namespace Halide {
namespace Internal {

/** Build small vectors of up to 6 elements. If we used C++11 and
 * had vector initializers, this would not be necessary, but we
 * don't want to rely on C++11 support. */
//@{
template<typename T>
std::vector<T> vec(T a) {
    std::vector<T> v(1);
    v[0] = a;
    return v;
}

template<typename T>
std::vector<T> vec(T a, T b) {
    std::vector<T> v(2);
    v[0] = a;
    v[1] = b;
    return v;
}

template<typename T>
std::vector<T> vec(T a, T b, T c) {
    std::vector<T> v(3);
    v[0] = a;
    v[1] = b;
    v[2] = c;
    return v;
}

template<typename T>
std::vector<T> vec(T a, T b, T c, T d) {
    std::vector<T> v(4);
    v[0] = a;
    v[1] = b;
    v[2] = c;
    v[3] = d;
    return v;
}

template<typename T>
std::vector<T> vec(T a, T b, T c, T d, T e) {
    std::vector<T> v(5);
    v[0] = a;
    v[1] = b;
    v[2] = c;
    v[3] = d;
    v[4] = e;
    return v;
}

template<typename T>
std::vector<T> vec(T a, T b, T c, T d, T e, T f) {
    std::vector<T> v(6);
    v[0] = a;
    v[1] = b;
    v[2] = c;
    v[3] = d;
    v[4] = e;
    v[5] = f;
    return v;
}
// @}

/** Convert an integer to a string. */
EXPORT std::string int_to_string(int x);

/** An aggressive form of reinterpret cast used for correct type-punning. */
template<typename DstType, typename SrcType>
DstType reinterpret_bits(const SrcType &src) {
    assert(sizeof(SrcType) == sizeof(DstType));
    DstType dst;
    memcpy(&dst, &src, sizeof(SrcType));
    return dst;
}

/** Generate a unique name starting with the given character. It's
 * unique relative to all other calls to unique_name done by this
 * process. Not thread-safe. */
EXPORT std::string unique_name(char prefix);

/** Generate a unique name starting with the given string.  Not
 * thread-safe. */
EXPORT std::string unique_name(const std::string &name);

/** Test if the first string starts with the second string */
EXPORT bool starts_with(const std::string &str, const std::string &prefix);

/** Test if the first string ends with the second string */
EXPORT bool ends_with(const std::string &str, const std::string &suffix);

/** Return the final token of the name string, assuming a fully qualified name
 * delimited by '.' */
EXPORT std::string base_name(const std::string &name);

}
}

#endif
#ifndef HALIDE_TYPE_H
#define HALIDE_TYPE_H

#include <stdint.h>

/** \file
 * Defines halide types
 */

namespace Halide {

struct Expr;

/** Types in the halide type system. They can be ints, unsigned ints,
 * or floats of various bit-widths (the 'bits' field). They can also
 * be vectors of the same (by setting the 'width' field to something
 * larger than one). Front-end code shouldn't use vector
 * types. Instead vectorize a function. */
struct Type {
    /** The basic type code: signed integer, unsigned integer, or floating point */
    enum {Int,  //!< signed integers
          UInt, //!< unsigned integers
          Float, //!< floating point numbers
          Handle //!< opaque pointer type (i.e. void *)
    } t;

    /** How many bits per element? */
    int bits;

    /** How many bytes per element? */
    int bytes() const {return (bits + 7) / 8;}

    /** How many elements (if a vector type). Should be 1 for scalar types. */
    int width;

    /** Some helper functions to ask common questions about a type. */
    // @{
    bool is_bool() const {return t == UInt && bits == 1;}
    bool is_vector() const {return width > 1;}
    bool is_scalar() const {return width == 1;}
    bool is_float() const {return t == Float;}
    bool is_int() const {return t == Int;}
    bool is_uint() const {return t == UInt;}
    bool is_handle() const {return t == Handle;}
    // @}

    /** Compare two types for equality */
    bool operator==(const Type &other) const {
        return t == other.t && bits == other.bits && width == other.width;
    }

    /** Compare two types for inequality */
    bool operator!=(const Type &other) const {
        return t != other.t || bits != other.bits || width != other.width;
    }

    /** Produce a vector of this type, with 'width' elements */
    Type vector_of(int w) const {
        Type type = {t, bits, w};
        return type;
    }

    /** Produce the type of a single element of this vector type */
    Type element_of() const {
        Type type = {t, bits, 1};
        return type;
    }

    /** Return an integer which is the maximum value of this type. */
    int imax() const;

    /** Return an expression which is the maximum value of this type */
    Expr max() const;

    /** Return an integer which is the minimum value of this type */
    int imin() const;

    /** Return an expression which is the minimum value of this type */
    Expr min() const;
};

/** Constructing a signed integer type */
inline Type Int(int bits, int width = 1) {
    Type t;
    t.t = Type::Int;
    t.bits = bits;
    t.width = width;
    return t;
}

/** Constructing an unsigned integer type */
inline Type UInt(int bits, int width = 1) {
    Type t;
    t.t = Type::UInt;
    t.bits = bits;
    t.width = width;
    return t;
}

/** Construct a floating-point type */
inline Type Float(int bits, int width = 1) {
    Type t;
    t.t = Type::Float;
    t.bits = bits;
    t.width = width;
    return t;
}

/** Construct a boolean type */
inline Type Bool(int width = 1) {
    return UInt(1, width);
}

/** Construct a handle type */
inline Type Handle(int width = 1) {
    Type t;
    t.t = Type::Handle;
    t.bits = 64; // All handles are 64-bit for now
    t.width = width;
    return t;
}

template<typename T>
struct type_of_helper;

template<typename T>
struct type_of_helper<T *> {
    operator Type() {
        return Handle();
    }
};

template<>
struct type_of_helper<float> {
    operator Type() {return Float(32);}
};

template<>
struct type_of_helper<double> {
    operator Type() {return Float(64);}
};

template<>
struct type_of_helper<uint8_t> {
    operator Type() {return UInt(8);}
};

template<>
struct type_of_helper<uint16_t> {
    operator Type() {return UInt(16);}
};

template<>
struct type_of_helper<uint32_t> {
    operator Type() {return UInt(32);}
};

template<>
struct type_of_helper<uint64_t> {
    operator Type() {return UInt(64);}
};

template<>
struct type_of_helper<int8_t> {
    operator Type() {return Int(8);}
};

template<>
struct type_of_helper<int16_t> {
    operator Type() {return Int(16);}
};

template<>
struct type_of_helper<int32_t> {
    operator Type() {return Int(32);}
};

template<>
struct type_of_helper<int64_t> {
    operator Type() {return Int(64);}
};

template<>
struct type_of_helper<bool> {
    operator Type() {return Bool();}
};

/** Construct the halide equivalent of a C type */
template<typename T> Type type_of() {
    return Type(type_of_helper<T>());
}

}

#endif
#ifndef HALIDE_ARGUMENT_H
#define HALIDE_ARGUMENT_H

#include <string>

/** \file 
 * Defines a type used for expressing the type signature of a
 * generated halide pipeline
 */

namespace Halide { 

/**
 * A struct representing an argument to a halide-generated
 * function. Used for specifying the function signature of
 * generated code. 
 */
struct Argument {
    /** The name of the argument */
    std::string name;        
            
    /** An argument is either a primitive type (for parameters), or a
     * buffer pointer. If 'is_buffer' is true, then 'type' should be
     * ignored.
     */
    bool is_buffer;

    /** If this is a scalar parameter, then this is its type */
    Type type;

    Argument() : is_buffer(false) {}
    Argument(const std::string &_name, bool _is_buffer, Type _type) : 
        name(_name), is_buffer(_is_buffer), type(_type) {}
};
}

#endif
#ifndef HALIDE_BOUNDS_H
#define HALIDE_BOUNDS_H

#ifndef HALIDE_IR_H
#define HALIDE_IR_H

/** \file
 * Halide expressions (\ref Halide::Expr) and statements (\ref Halide::Internal::Stmt)
 */

#include <string>
#include <vector>

#ifndef HALIDE_IR_VISITOR_H
#define HALIDE_IR_VISITOR_H

#include <set>

/** \file
 * Defines the base class for things that recursively walk over the IR
 */

namespace Halide {

struct Expr;

namespace Internal {

struct IRNode;
struct Stmt;
struct IntImm;
struct FloatImm;
struct StringImm;
struct Cast;
struct Variable;
struct Add;
struct Sub;
struct Mul;
struct Div;
struct Mod;
struct Min;
struct Max;
struct EQ;
struct NE;
struct LT;
struct LE;
struct GT;
struct GE;
struct And;
struct Or;
struct Not;
struct Select;
struct Load;
struct Ramp;
struct Broadcast;
struct Call;
struct Let;
struct LetStmt;
struct AssertStmt;
struct Pipeline;
struct For;
struct Store;
struct Provide;
struct Allocate;
struct Free;
struct Realize;
struct Block;
struct IfThenElse;
struct Evaluate;

/** A base class for algorithms that need to recursively walk over the
 * IR. The default implementations just recursively walk over the
 * children. Override the ones you care about.
 */
class IRVisitor {
public:
    virtual ~IRVisitor();
    virtual void visit(const IntImm *);
    virtual void visit(const FloatImm *);
    virtual void visit(const StringImm *);
    virtual void visit(const Cast *);
    virtual void visit(const Variable *);
    virtual void visit(const Add *);
    virtual void visit(const Sub *);
    virtual void visit(const Mul *);
    virtual void visit(const Div *);
    virtual void visit(const Mod *);
    virtual void visit(const Min *);
    virtual void visit(const Max *);
    virtual void visit(const EQ *);
    virtual void visit(const NE *);
    virtual void visit(const LT *);
    virtual void visit(const LE *);
    virtual void visit(const GT *);
    virtual void visit(const GE *);
    virtual void visit(const And *);
    virtual void visit(const Or *);
    virtual void visit(const Not *);
    virtual void visit(const Select *);
    virtual void visit(const Load *);
    virtual void visit(const Ramp *);
    virtual void visit(const Broadcast *);
    virtual void visit(const Call *);
    virtual void visit(const Let *);
    virtual void visit(const LetStmt *);
    virtual void visit(const AssertStmt *);
    virtual void visit(const Pipeline *);
    virtual void visit(const For *);
    virtual void visit(const Store *);
    virtual void visit(const Provide *);
    virtual void visit(const Allocate *);
    virtual void visit(const Free *);
    virtual void visit(const Realize *);
    virtual void visit(const Block *);
    virtual void visit(const IfThenElse *);
    virtual void visit(const Evaluate *);
};

/** A base class for algorithms that walk recursively over the IR
 * without visiting the same node twice. This is for passes that are
 * capable of interpreting the IR as a DAG instead of a tree. */
class IRGraphVisitor : public IRVisitor {
protected:
    /** By default these methods add the node to the visited set, and
     * return whether or not it was already there. If it wasn't there,
     * it delegates to the appropriate visit method. You can override
     * them if you like. */
    // @{
    virtual void include(const Expr &);
    virtual void include(const Stmt &);
    // @}

    /** The nodes visited so far */
    std::set<const IRNode *> visited;

public:

    /** These methods should call 'include' on the children to only
     * visit them if they haven't been visited already. */
    // @{
    virtual void visit(const IntImm *);
    virtual void visit(const FloatImm *);
    virtual void visit(const StringImm *);
    virtual void visit(const Cast *);
    virtual void visit(const Variable *);
    virtual void visit(const Add *);
    virtual void visit(const Sub *);
    virtual void visit(const Mul *);
    virtual void visit(const Div *);
    virtual void visit(const Mod *);
    virtual void visit(const Min *);
    virtual void visit(const Max *);
    virtual void visit(const EQ *);
    virtual void visit(const NE *);
    virtual void visit(const LT *);
    virtual void visit(const LE *);
    virtual void visit(const GT *);
    virtual void visit(const GE *);
    virtual void visit(const And *);
    virtual void visit(const Or *);
    virtual void visit(const Not *);
    virtual void visit(const Select *);
    virtual void visit(const Load *);
    virtual void visit(const Ramp *);
    virtual void visit(const Broadcast *);
    virtual void visit(const Call *);
    virtual void visit(const Let *);
    virtual void visit(const LetStmt *);
    virtual void visit(const AssertStmt *);
    virtual void visit(const Pipeline *);
    virtual void visit(const For *);
    virtual void visit(const Store *);
    virtual void visit(const Provide *);
    virtual void visit(const Allocate *);
    virtual void visit(const Free *);
    virtual void visit(const Realize *);
    virtual void visit(const Block *);
    virtual void visit(const IfThenElse *);
    virtual void visit(const Evaluate *);
    // @}
};

}
}

#endif
#ifndef HALIDE_BUFFER_H
#define HALIDE_BUFFER_H

#include <stdint.h>
#ifndef HALIDE_BUFFER_T_H
#define HALIDE_BUFFER_T_H

/** \file
 * Defines the internal runtime representation of an image: buffer_t
 */

/* Generated code must declare buffer_t as well. This conditional bracket
 * prevents multiple definition errors if both Halide.h and the header
 * generated by compile_to_header are included in the same file.
 *
 * TODO: Use a more unique name than "buffer_t"
 * TODO: If possible, ensure all definitions are the same.
 */
#ifndef BUFFER_T_DEFINED
#define BUFFER_T_DEFINED

/**
 * The raw representation of an image passed around by generated
 * Halide code. It includes some stuff to track whether the image is
 * not actually in main memory, but instead on a device (like a
 * GPU). */
typedef struct buffer_t {
    /** A device-handle for e.g. GPU memory used to back this buffer. */
    uint64_t dev;

    /** A pointer to the start of the data in main memory. */
    uint8_t* host;

    /** The size of the buffer in each dimension. */
    int32_t extent[4];

    /** Gives the spacing in memory between adjacent elements in the
     * given dimension.  The correct memory address for a load from
     * this buffer at position x, y, z, w is:
     * host + (x * stride[0] + y * stride[1] + z * stride[2] + w * stride[3]) * elem_size
     * By manipulating the strides and extents you can lazily crop,
     * transpose, and even flip buffers without modifying the data.
    */
    int32_t stride[4];

    /** Buffers often represent evaluation of a Func over some
     * domain. The min field encodes the top left corner of the
     * domain. */
    int32_t min[4];

    /** How many bytes does each buffer element take. This may be
     * replaced with a more general type code in the future. */
    int32_t elem_size;

    /** This should be true if there is an existing device allocation
     * mirroring this buffer, and the data has been modified on the
     * host side. */
    bool host_dirty;

    /** This should be true if there is an existing device allocation
    mirroring this buffer, and the data has been modified on the
    device side. */
    bool dev_dirty;
} buffer_t;

#endif

#endif
#ifndef HALIDE_JIT_COMPILED_MODULE_H
#define HALIDE_JIT_COMPILED_MODULE_H

/** \file
 * Defines the struct representing a JIT compiled halide pipeline
 */

#ifndef HALIDE_INTRUSIVE_PTR_H
#define HALIDE_INTRUSIVE_PTR_H

/** \file
 *
 * Support classes for reference-counting via intrusive shared
 * pointers.
 */


#include <stdlib.h>
#include <iostream>
namespace Halide {
namespace Internal {

/** A class representing a reference count to be used with IntrusivePtr */
class RefCount {
    int count;
public:
    RefCount() : count(0) {}
    void increment() {count++;}
    void decrement() {count--;}
    bool is_zero() const {return count == 0;}
};

/**
 * Because in this header we don't yet know how client classes store
 * their RefCount (and we don't want to depend on the declarations of
 * the client classes), any class that you want to hold onto via one
 * of these must provide implementations of ref_count and destroy,
 * which we forward-declare here.
 *
 * E.g. if you want to use IntrusivePtr<MyClass>, then you should
 * define something like this in MyClass.cpp (assuming MyClass has
 * a field: mutable RefCount ref_count):
 *
 * template<> RefCount &ref_count<MyClass>(const MyClass *c) {return c->ref_count;}
 * template<> void destroy<MyClass>(const MyClass *c) {delete c;}
 */
// @{
template<typename T> EXPORT RefCount &ref_count(const T *);
template<typename T> EXPORT void destroy(const T *);
// @}

/** Intrusive shared pointers have a reference count (a
 * RefCount object) stored in the class itself. This is perhaps more
 * efficient than storing it externally, but more importantly, it
 * means it's possible to recover a reference-counted handle from the
 * raw pointer, and it's impossible to have two different reference
 * counts attached to the same raw object. Seeing as we pass around
 * raw pointers to concrete IRNodes and Expr's interchangeably, this
 * is a useful property.
 */
template<typename T>
struct IntrusivePtr {
private:

    void incref(T *p) {
        if (p) {
            ref_count(p).increment();
        }
    };

    void decref(T *p) {
        if (p) {
            ref_count(p).decrement();
            if (ref_count(p).is_zero()) {
                //std::cout << "Destroying " << ptr << ", " << live_objects << "\n";
                destroy(p);
            }
        }
    }

public:
    T *ptr;

    ~IntrusivePtr() {
        decref(ptr);
    }

    IntrusivePtr() : ptr(NULL) {
    }

    IntrusivePtr(T *p) : ptr(p) {
        incref(ptr);
    }

    IntrusivePtr(const IntrusivePtr<T> &other) : ptr(other.ptr) {
        incref(ptr);
    }

    IntrusivePtr<T> &operator=(const IntrusivePtr<T> &other) {
        // Other can be inside of something owned by this, so we
        // should be careful to incref other before we decref
        // ourselves.
        T *temp = other.ptr;
        incref(temp);
        decref(ptr);
        ptr = temp;
        return *this;
    }

    /* Handles can be null. This checks that. */
    bool defined() const {
        return ptr != NULL;
    }

    /* Check if two handles point to the same ptr. This is
     * equality of reference, not equality of value. */
    bool same_as(const IntrusivePtr &other) const {
        return ptr == other.ptr;
    }

};

}
}

#endif

namespace llvm {
class Module;
}

namespace Halide {
namespace Internal {

class JITModuleHolder;
class CodeGen;

/** Function pointers into a compiled halide module. These function
 * pointers are meaningless once the last copy of a JITCompiledModule
 * is deleted, so don't cache them. */
struct JITCompiledModule {
    /** A pointer to the raw halide function. It's true type depends
     * on the Argument vector passed to CodeGen::compile. Image
     * parameters become (buffer_t *), and scalar parameters become
     * pointers to the appropriate values. The final argument is a
     * pointer to the buffer_t defining the output. */
    void *function;

    /** A slightly more type-safe wrapper around the raw halide
     * module. Takes it arguments as an array of pointers that
     * correspond to the arguments to \ref function */
    int (*wrapped_function)(const void **);

    /** JITed helpers to interact with device-mapped buffer_t
     * objects. These pointers may be NULL if not compiling for a
     * gpu-like target. */
    // @{
    void (*copy_to_host)(struct buffer_t*);
    void (*copy_to_dev)(struct buffer_t*);
    void (*free_dev_buffer)(struct buffer_t*);
    // @}

    /** The type of a halide runtime error handler function */
    typedef void (*ErrorHandler)(const char *);

    /** Set the runtime error handler for this module */
    void (*set_error_handler)(ErrorHandler);

    /** Set a custom malloc and free for this module to use. See
     * \ref Func::set_custom_allocator */
    void (*set_custom_allocator)(void *(*malloc)(size_t), void (*free)(void *));

    /** Set a custom parallel for loop launcher. See
     * \ref Func::set_custom_do_par_for */
    typedef int (*HalideTask)(int, uint8_t *);
    void (*set_custom_do_par_for)(int (*custom_do_par_for)(HalideTask, int, int, uint8_t *));

    /** Set a custom do parallel task. See
     * \ref Func::set_custom_do_task */
    void (*set_custom_do_task)(int (*custom_do_task)(HalideTask, int, uint8_t *));

    /** Set a custom trace function. See \ref Func::set_custom_trace. */
    typedef void (*TraceFn)(const char *, int, int, int, int, int, const void *, int, const int *);
    void (*set_custom_trace)(TraceFn);

    /** Shutdown the thread pool maintained by this JIT module. This
     * is also done automatically when the last reference to this
     * module is destroyed. */
    void (*shutdown_thread_pool)();

    /** Close the tracing file this module may be writing to. Also
     * done automatically when the last reference to this module is
     * destroyed. */
    void (*shutdown_trace)();

    // The JIT Module Allocator holds onto the memory storing the functions above.
    IntrusivePtr<JITModuleHolder> module;

    JITCompiledModule() :
        function(NULL),
        wrapped_function(NULL),
        copy_to_host(NULL),
        copy_to_dev(NULL),
        free_dev_buffer(NULL),
        set_error_handler(NULL),
        set_custom_allocator(NULL),
        set_custom_do_par_for(NULL),
        set_custom_do_task(NULL),
        set_custom_trace(NULL),
        shutdown_thread_pool(NULL),
        shutdown_trace(NULL) {}

    /** Take an llvm module and compile it. Populates the function
     * pointer members above with the result. */
    void compile_module(CodeGen *cg, llvm::Module *mod, const std::string &function_name);

};

}
}


#endif

/** \file
 * Defines Buffer - A c++ wrapper around a buffer_t.
 */

namespace Halide {
namespace Internal {

struct BufferContents {
    /** The buffer_t object we're wrapping. */
    buffer_t buf;

    /** The type of the allocation. buffer_t's don't currently track this so we do it here. */
    Type type;

    /** If we made the allocation ourselves via a Buffer constructor,
     * and hence should delete it when this buffer dies, then this
     * pointer is set to the memory we need to free. Otherwise it's
     * NULL. */
    uint8_t *allocation;

    /** How many Buffer objects point to this BufferContents */
    mutable RefCount ref_count;

    /** What is the name of the buffer? Useful for debugging symbols. */
    std::string name;

    /** If this buffer was generated by a jit-compiled module, we need
     * to hang onto the module, as it may contain internal state that
     * tells us how to use this buffer. In particular, if the buffer
     * was generated on the gpu and hasn't been copied back yet, only
     * the module knows how to do that, so we'd better keep the module
     * alive. */
    JITCompiledModule source_module;

    BufferContents(Type t, int x_size, int y_size, int z_size, int w_size,
                   uint8_t* data, const std::string &n) :
        type(t), allocation(NULL), name(n.empty() ? unique_name('b') : n) {
        assert(t.width == 1 && "Can't create of a buffer of a vector type");
        buf.elem_size = t.bytes();
        size_t size = 1;
        if (x_size) size *= x_size;
        if (y_size) size *= y_size;
        if (z_size) size *= z_size;
        if (w_size) size *= w_size;
        if (!data) {
            size = buf.elem_size*size + 32;
            allocation = (uint8_t *)calloc(1, size);
            buf.host = allocation;
            while ((size_t)(buf.host) & 0x1f) buf.host++;
        } else {
            buf.host = data;
        }
        buf.dev = 0;
        buf.host_dirty = false;
        buf.dev_dirty = false;
        buf.extent[0] = x_size;
        buf.extent[1] = y_size;
        buf.extent[2] = z_size;
        buf.extent[3] = w_size;
        buf.stride[0] = 1;
        buf.stride[1] = x_size;
        buf.stride[2] = x_size*y_size;
        buf.stride[3] = x_size*y_size*z_size;
        buf.min[0] = 0;
        buf.min[1] = 0;
        buf.min[2] = 0;
        buf.min[3] = 0;
    }

    BufferContents(Type t, const buffer_t *b, const std::string &n) :
        type(t), allocation(NULL), name(n.empty() ? unique_name('b') : n) {
        buf = *b;
        assert(t.width == 1 && "Can't create of a buffer of a vector type");
    }
};
}

/** The internal representation of an image, or other dense array
 * data. The Image type provides a typed view onto a buffer for the
 * purposes of direct manipulation. A buffer may be stored in main
 * memory, or some other memory space (e.g. a gpu). If you want to use
 * this as an Image, see the Image class. Casting a Buffer to an Image
 * will do any appropriate copy-back. This class is a fairly thin
 * wrapper on a buffer_t, which is the C-style type Halide uses for
 * passing buffers around.
 */
class Buffer {
private:
    Internal::IntrusivePtr<Internal::BufferContents> contents;
public:
    Buffer() : contents(NULL) {}

    Buffer(Type t, int x_size = 0, int y_size = 0, int z_size = 0, int w_size = 0,
           uint8_t* data = NULL, const std::string &name = "") :
        contents(new Internal::BufferContents(t, x_size, y_size, z_size, w_size, data, name)) {
    }

    Buffer(Type t, const buffer_t *buf, const std::string &name = "") :
        contents(new Internal::BufferContents(t, buf, name)) {
    }

    /** Get a pointer to the host-side memory. */
    void *host_ptr() const {
        assert(defined());
        return (void *)contents.ptr->buf.host;
    }

    /** Get a pointer to the raw buffer_t struct that this class wraps. */
    buffer_t *raw_buffer() const {
        assert(defined());
        return &(contents.ptr->buf);
    }

    /** Get the device-side pointer/handle for this buffer. Will be
     * zero if no device was involved in the creation of this
     * buffer. */
    uint64_t device_handle() const {
        assert(defined());
        return contents.ptr->buf.dev;
    }

    /** Has this buffer been modified on the cpu since last copied to a
     * device. Not meaningful unless there's a device involved. */
    bool host_dirty() const {
        assert(defined());
        return contents.ptr->buf.host_dirty;
    }

    /** Let Halide know that the host-side memory backing this buffer
     * has been externally modified. You shouldn't normally need to
     * call this, because it is done for you when you cast a Buffer to
     * an Image in order to modify it. */
    void set_host_dirty(bool dirty = true) {
        assert(defined());
        contents.ptr->buf.host_dirty = dirty;
    }

    /** Has this buffer been modified on device since last copied to
     * the cpu. Not meaninful unless there's a device involved. */
    bool device_dirty() const {
        assert(defined());
        return contents.ptr->buf.dev_dirty;
    }

    /** Let Halide know that the device-side memory backing this
     * buffer has been externally modified, and so the cpu-side memory
     * is invalid. A copy-back will occur the next time you cast this
     * Buffer to an Image, or the next time this buffer is accessed on
     * the host in a halide pipeline. */
    void set_device_dirty(bool dirty = true) {
        assert(defined());
        contents.ptr->buf.host_dirty = dirty;
    }

    /** Get the dimensionality of this buffer. Uses the convention
     * that the extent field of a buffer_t should contain zero when
     * the dimensions end. */
    int dimensions() const {
        for (int i = 0; i < 4; i++) {
            if (extent(i) == 0) return i;
        }
        return 4;
    }

    /** Get the extent of this buffer in the given dimension. */
    int extent(int dim) const {
        assert(defined());
        assert(dim >= 0 && dim < 4 && "We only support 4-dimensional buffers for now");
        return contents.ptr->buf.extent[dim];
    }

    /** Get the number of bytes between adjacent elements of this buffer along the given dimension. */
    int stride(int dim) const {
        assert(defined());
        assert(dim >= 0 && dim < 4 && "We only support 4-dimensional buffers for now");
        return contents.ptr->buf.stride[dim];
    }

    /** Get the coordinate in the function that this buffer represents
     * that corresponds to the base address of the buffer. */
    int min(int dim) const {
        assert(defined());
        assert(dim >= 0 && dim < 4 && "We only support 4-dimensional buffers for now");
        return contents.ptr->buf.min[dim];
    }

    /** Set the coordinate in the function that this buffer represents
     * that corresponds to the base address of the buffer. */
    void set_min(int m0, int m1 = 0, int m2 = 0, int m3 = 0) {
        assert(defined());
        contents.ptr->buf.min[0] = m0;
        contents.ptr->buf.min[1] = m1;
        contents.ptr->buf.min[2] = m2;
        contents.ptr->buf.min[3] = m3;
    }

    /** Get the Halide type of the contents of this buffer. */
    Type type() const {
        assert(defined());
        return contents.ptr->type;
    }

    /** Compare two buffers for identity (not equality of data). */
    bool same_as(const Buffer &other) const {
        return contents.same_as(other.contents);
    }

    /** Check if this buffer handle actually points to data. */
    bool defined() const {
        return contents.defined();
    }

    /** Get the runtime name of this buffer used for debugging. */
    const std::string &name() const {
        return contents.ptr->name;
    }

    /** Convert this buffer to an argument to a halide pipeline. */
    operator Argument() const {
        return Argument(name(), true, type());
    }

    /** Declare that this buffer was created by the given jit-compiled
     * module. Used internally for reference counting the module. */
    void set_source_module(const Internal::JITCompiledModule &module) {
        assert(defined());
        contents.ptr->source_module = module;
    }

    /** If this buffer was the output of a jit-compiled realization,
     * retrieve the module it came from. Otherwise returns a module
     * struct full of null pointers. */
    const Internal::JITCompiledModule &source_module() {
        assert(defined());
        return contents.ptr->source_module;
    }

    /** If this buffer was created *on-device* by a jit-compiled
     * realization, then copy it back to the cpu-side memory. This is
     * usually achieved by casting the Buffer to an Image. */
    void copy_to_host() {
        void (*copy_to_host)(buffer_t *) =
            contents.ptr->source_module.copy_to_host;
        if (copy_to_host) {
            copy_to_host(raw_buffer());
        }
    }

    /** If this buffer was created by a jit-compiled realization on a
     * device-aware target (e.g. PTX), then copy the cpu-side data to
     * the device-side allocation. TODO: I believe this currently
     * aborts messily if no device-side allocation exists. You might
     * think you want to do this because you've modified the data
     * manually on the host before calling another Halide pipeline,
     * but what you actually want to do in that situation is set the
     * host_dirty bit so that Halide can manage the copy lazily for
     * you. Casting the Buffer to an Image sets the dirty bit for
     * you. */
    void copy_to_dev() {
        void (*copy_to_dev)(buffer_t *) =
            contents.ptr->source_module.copy_to_dev;
        if (copy_to_dev) {
            copy_to_dev(raw_buffer());
        }
    }

    /** If this buffer was created by a jit-compiled realization on a
     * device-aware target (e.g. PTX), then free the device-side
     * allocation, if there is one. Done automatically when the last
     * reference to this buffer dies. */
    void free_dev_buffer() {
        void (*free_dev_buffer)(buffer_t *) =
            contents.ptr->source_module.free_dev_buffer;
        if (free_dev_buffer) {
            free_dev_buffer(raw_buffer());
        }
    }

};

namespace Internal {
template<>
inline RefCount &ref_count<BufferContents>(const BufferContents *p) {
    return p->ref_count;
}

template<>
inline void destroy<BufferContents>(const BufferContents *p) {
    // Free any device-side allocation
    if (p->source_module.free_dev_buffer) {
        p->source_module.free_dev_buffer(const_cast<buffer_t *>(&p->buf));
    }
    if (p->allocation) {
        free(p->allocation);
    }
    delete p;
}

}
}

#endif

namespace Halide {

namespace Internal {

/** A class representing a type of IR node (e.g. Add, or Mul, or
 * For). We use it for rtti (without having to compile with rtti). */
struct IRNodeType {};

/** The abstract base classes for a node in the Halide IR. */
struct IRNode {

    /** We use the visitor pattern to traverse IR nodes throughout the
     * compiler, so we have a virtual accept method which accepts
     * visitors.
     */
    virtual void accept(IRVisitor *v) const = 0;
    IRNode() {}
    virtual ~IRNode() {}

    /** These classes are all managed with intrusive reference
       counting, so we also track a reference count. It's mutable
       so that we can do reference counting even through const
       references to IR nodes. */
    mutable RefCount ref_count;

    /** Each IR node subclass should return some unique pointer. We
     * can compare these pointers to do runtime type
     * identification. We don't compile with rtti because that
     * injects run-time type identification stuff everywhere (and
     * often breaks when linking external libraries compiled
     * without it), and we only want it for IR nodes. */
    virtual const IRNodeType *type_info() const = 0;
};

template<>
EXPORT inline RefCount &ref_count<IRNode>(const IRNode *n) {return n->ref_count;}

template<>
EXPORT inline void destroy<IRNode>(const IRNode *n) {delete n;}

/** IR nodes are split into expressions and statements. These are
   similar to expressions and statements in C - expressions
   represent some value and have some type (e.g. x + 3), and
   statements are side-effecting pieces of code that do not
   represent a value (e.g. assert(x > 3)) */

/** A base class for statement nodes. They have no properties or
   methods beyond base IR nodes for now */
struct BaseStmtNode : public IRNode {
};

/** A base class for expression nodes. They all contain their types
 * (e.g. Int(32), Float(32)) */
struct BaseExprNode : public IRNode {
    Type type;
};

/** We use the "curiously recurring template pattern" to avoid
   duplicated code in the IR Nodes. These classes live between the
   abstract base classes and the actual IR Nodes in the
   inheritance hierarchy. It provides an implementation of the
   accept function necessary for the visitor pattern to work, and
   a concrete instantiation of a unique IRNodeType per class. */
template<typename T>
struct ExprNode : public BaseExprNode {
    void accept(IRVisitor *v) const {
        v->visit((const T *)this);
    }
    virtual IRNodeType *type_info() const {return &_type_info;}
    static EXPORT IRNodeType _type_info;
};

template<typename T>
struct StmtNode : public BaseStmtNode {
    void accept(IRVisitor *v) const {
        v->visit((const T *)this);
    }
    virtual IRNodeType *type_info() const {return &_type_info;}
    static EXPORT IRNodeType _type_info;
};

/** IR nodes are passed around opaque handles to them. This is a
   base class for those handles. It manages the reference count,
   and dispatches visitors. */
struct IRHandle : public IntrusivePtr<const IRNode> {
    IRHandle() : IntrusivePtr<const IRNode>() {}
    IRHandle(const IRNode *p) : IntrusivePtr<const IRNode>(p) {}

    /** Dispatch to the correct visitor method for this node. E.g. if
     * this node is actually an Add node, then this will call
     * IRVisitor::visit(const Add *) */
    void accept(IRVisitor *v) const {
        ptr->accept(v);
    }

    /** Downcast this ir node to its actual type (e.g. Add, or
     * Select). This returns NULL if the node is not of the requested
     * type. Example usage:
     *
     * if (const Add *add = node->as<Add>()) {
     *   // This is an add node
     * }
     */
    template<typename T> const T *as() const {
        if (ptr->type_info() == &T::_type_info)
            return (const T *)ptr;
        return NULL;
    }
};

/** Integer constants */
struct IntImm : public ExprNode<IntImm> {
    int value;

    static IntImm *make(int value) {
        if (value >= -8 && value <= 8) return small_int_cache + value + 8;
        IntImm *node = new IntImm;
        node->type = Int(32);
        node->value = value;
        return node;
    }

private:
    /** ints from -8 to 8 */
    static IntImm small_int_cache[17];
};

/** Floating point constants */
struct FloatImm : public ExprNode<FloatImm> {
    float value;

    static FloatImm *make(float value) {
        FloatImm *node = new FloatImm;
        node->type = Float(32);
        node->value = value;
        return node;
    }
};

/** String constants */
struct StringImm : public ExprNode<StringImm> {
    std::string value;

    static StringImm *make(const std::string &val) {
        StringImm *node = new StringImm;
        node->type = Handle();
        node->value = val;
        return node;
    }
};

}

/** A fragment of Halide syntax. It's implemented as reference-counted
 * handle to a concrete expression node, but it's immutable, so you
 * can treat it as a value type. */
struct Expr : public Internal::IRHandle {
    /** Make an undefined expression */
    Expr() : Internal::IRHandle() {}

    /** Make an expression from a concrete expression node pointer (e.g. Add) */
    Expr(const Internal::BaseExprNode *n) : IRHandle(n) {}


    /** Make an expression representing a const 32-bit int (i.e. an IntImm) */
    EXPORT Expr(int x) : IRHandle(Internal::IntImm::make(x)) {
    }

    /** Make an expression representing a const 32-bit float (i.e. a FloatImm) */
    EXPORT Expr(float x) : IRHandle(Internal::FloatImm::make(x)) {
    }

    /** Make an expression representing a const string (i.e. a StringImm) */
    EXPORT Expr(const std::string &s) : IRHandle(Internal::StringImm::make(s)) {
    }

    /** Get the type of this expression node */
    Type type() const {
        return ((Internal::BaseExprNode *)ptr)->type;
    }
};

/** This lets you use an Expr as a key in a map of the form
 * map<Expr, Foo, ExprCompare> */
struct ExprCompare {
    bool operator()(Expr a, Expr b) const {
        return a.ptr < b.ptr;
    }
};

}

// Now that we've defined an Expr, we can include Parameter.h
#ifndef HALIDE_PARAMETER_H
#define HALIDE_PARAMETER_H

/** \file
 * Defines the internal representation of parameters to halide piplines
 */

#include <string>

namespace Halide {
namespace Internal {

struct ParameterContents {
    mutable RefCount ref_count;
    Type type;
    bool is_buffer;
    std::string name;
    Buffer buffer;
    uint64_t data;
    Expr min_constraint[4];
    Expr extent_constraint[4];
    Expr stride_constraint[4];
    Expr min_value, max_value;
    ParameterContents(Type t, bool b, const std::string &n) : type(t), is_buffer(b), name(n), buffer(Buffer()), data(0) {
        // stride_constraint[0] defaults to 1. This is important for
        // dense vectorization. You can unset it by setting it to a
        // null expression. (param.set_stride(0, Expr());)
        stride_constraint[0] = 1;
    }

    template<typename T>
    T &as() {
        assert(type == type_of<T>());
        return *((T *)(&data));
    }
};

/** A reference-counted handle to a parameter to a halide
 * pipeline. May be a scalar parameter or a buffer */
class Parameter {
    IntrusivePtr<ParameterContents> contents;
public:
    /** Construct a new undefined handle */
    Parameter() : contents(NULL) {}

    /** Construct a new parameter of the given type. If the second
     * argument is true, this is a buffer parameter, otherwise, it is
     * a scalar parameter. The parameter will be given a unique
     * auto-generated name. */
    Parameter(Type t, bool is_buffer) :
        contents(new ParameterContents(t, is_buffer, unique_name('p'))) {
    }

    /** Construct a new parameter of the given type with name given by
     * the third argument. If the second argument is true, this is a
     * buffer parameter, otherwise, it is a scalar parameter. The
     * parameter will be given a unique auto-generated name. */
    Parameter(Type t, bool is_buffer, const std::string &name) :
        contents(new ParameterContents(t, is_buffer, name)) {
    }

    /** Get the type of this parameter */
    Type type() const {
        assert(contents.defined());
        return contents.ptr->type;
    }

    /** Get the name of this parameter */
    const std::string &name() const {
        assert(contents.defined());
        return contents.ptr->name;
    }

    /** Does this parameter refer to a buffer/image? */
    bool is_buffer() const {
        assert(contents.defined());
        return contents.ptr->is_buffer;
    }

    /** If the parameter is a scalar parameter, get its currently
     * bound value. Only relevant when jitting */
    template<typename T>
    T get_scalar() const {
        assert(contents.defined() && !contents.ptr->is_buffer);
        return contents.ptr->as<T>();
    }

    /** If the parameter is a buffer parameter, get its currently
     * bound buffer. Only relevant when jitting */
    Buffer get_buffer() const {
        assert(contents.defined() && contents.ptr->is_buffer);
        return contents.ptr->buffer;
    }

    /** If the parameter is a scalar parameter, set its current
     * value. Only relevant when jitting */
    template<typename T>
    void set_scalar(T val) {
        assert(contents.defined() && !contents.ptr->is_buffer);
        contents.ptr->as<T>() = val;
    }

    /** If the parameter is a buffer parameter, set its current
     * value. Only relevant when jitting */
    void set_buffer(Buffer b) {
        assert(contents.defined() && contents.ptr->is_buffer);
        if (b.defined()) assert(contents.ptr->type == b.type());
        contents.ptr->buffer = b;
    }

    /** Get the pointer to the current value of the scalar
     * parameter. For a given parameter, this address will never
     * change. Only relevant when jitting. */
    const void *get_scalar_address() const {
        assert(contents.defined());
        return &contents.ptr->data;
    }

    /** Tests if this handle is the same as another handle */
    bool same_as(const Parameter &other) const {
        return contents.ptr == other.contents.ptr;
    }

    /** Tests if this handle is non-NULL */
    bool defined() const {
        return contents.defined();
    }

    /** Get and set constraints for the min, extent, and stride (see
     * ImageParam::set_extent) */
    //@{
    void set_min_constraint(int dim, Expr e) {
        assert(contents.defined() && is_buffer() && dim >= 0 && dim < 4);
        contents.ptr->min_constraint[dim] = e;
    }
    void set_extent_constraint(int dim, Expr e) {
        assert(contents.defined() && is_buffer() && dim >= 0 && dim < 4);
        contents.ptr->extent_constraint[dim] = e;
    }
    void set_stride_constraint(int dim, Expr e) {
        assert(contents.defined() && is_buffer() && dim >= 0 && dim < 4);
        contents.ptr->stride_constraint[dim] = e;
    }
    Expr min_constraint(int dim) {
        assert(contents.defined() && is_buffer() && dim >= 0 && dim < 4);
        return contents.ptr->min_constraint[dim];
    }
    Expr extent_constraint(int dim) {
        assert(contents.defined() && is_buffer() && dim >= 0 && dim < 4);
        return contents.ptr->extent_constraint[dim];
    }
    Expr stride_constraint(int dim) {
        assert(contents.defined() && is_buffer() && dim >= 0 && dim < 4);
        return contents.ptr->stride_constraint[dim];
    }
    //@}

    /** Get and set constraints for scalar parameters */
    // @{
    void set_min_value(Expr e) {
        assert(contents.defined() && !is_buffer());
        contents.ptr->min_value = e;
    }

    Expr get_min_value() {
        assert(contents.defined() && !is_buffer());
        return contents.ptr->min_value;
    }

    void set_max_value(Expr e) {
        assert(contents.defined() && !is_buffer());
        contents.ptr->max_value = e;
    }

    Expr get_max_value() {
        assert(contents.defined() && !is_buffer());
        return contents.ptr->max_value;
    }
    // @}
};

}
}

#endif

namespace Halide {
namespace Internal {

/** A reference-counted handle to a statement node. */
struct Stmt : public IRHandle {
    Stmt() : IRHandle() {}
    Stmt(const BaseStmtNode *n) : IRHandle(n) {}

    /** This lets you use a Stmt as a key in a map of the form
     * map<Stmt, Foo, Stmt::Compare> */
    struct Compare {
        bool operator()(const Stmt &a, const Stmt &b) const {
            return a.ptr < b.ptr;
        }
    };
};

/** The actual IR nodes begin here. Remember that all the Expr
 * nodes also have a public "type" property */

}

namespace Internal {

/** Cast a node from one type to another */
struct Cast : public ExprNode<Cast> {
    Expr value;

    static Expr make(Type t, Expr v) {
        assert(v.defined() && "Cast of undefined");

        Cast *node = new Cast;
        node->type = t;
        node->value = v;
        return node;
    }
};

/** The sum of two expressions */
struct Add : public ExprNode<Add> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "Add of undefined");
        assert(b.defined() && "Add of undefined");
        assert(a.type() == b.type() && "Add of mismatched types");

        Add *node = new Add;
        node->type = a.type();
        node->a = a;
        node->b = b;
        return node;
    }
};

/** The difference of two expressions */
struct Sub : public ExprNode<Sub> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "Sub of undefined");
        assert(b.defined() && "Sub of undefined");
        assert(a.type() == b.type() && "Sub of mismatched types");

        Sub *node = new Sub;
        node->type = a.type();
        node->a = a;
        node->b = b;
        return node;
    }
};

/** The product of two expressions */
struct Mul : public ExprNode<Mul> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "Mul of undefined");
        assert(b.defined() && "Mul of undefined");
        assert(a.type() == b.type() && "Mul of mismatched types");

        Mul *node = new Mul;
        node->type = a.type();
        node->a = a;
        node->b = b;
        return node;
    }
};

/** The ratio of two expressions */
struct Div : public ExprNode<Div> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "Div of undefined");
        assert(b.defined() && "Div of undefined");
        assert(a.type() == b.type() && "Div of mismatched types");

        Div *node = new Div;
        node->type = a.type();
        node->a = a;
        node->b = b;
        return node;
    }
};

/** The remainder of a / b. Mostly equivalent to '%' in C, except that
 * the result here is always positive. For floats, this is equivalent
 * to calling fmod. */
struct Mod : public ExprNode<Mod> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "Mod of undefined");
        assert(b.defined() && "Mod of undefined");
        assert(a.type() == b.type() && "Mod of mismatched types");

        Mod *node = new Mod;
        node->type = a.type();
        node->a = a;
        node->b = b;
        return node;
    }
};

/** The lesser of two values. */
struct Min : public ExprNode<Min> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "Min of undefined");
        assert(b.defined() && "Min of undefined");
        assert(a.type() == b.type() && "Min of mismatched types");

        Min *node = new Min;
        node->type = a.type();
        node->a = a;
        node->b = b;
        return node;
    }
};

/** The greater of two values */
struct Max : public ExprNode<Max> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "Max of undefined");
        assert(b.defined() && "Max of undefined");
        assert(a.type() == b.type() && "Max of mismatched types");

        Max *node = new Max;
        node->type = a.type();
        node->a = a;
        node->b = b;
        return node;
    }
};

/** Is the first expression equal to the second */
struct EQ : public ExprNode<EQ> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "EQ of undefined");
        assert(b.defined() && "EQ of undefined");
        assert(a.type() == b.type() && "EQ of mismatched types");

        EQ *node = new EQ;
        node->type = Bool(a.type().width);
        node->a = a;
        node->b = b;
        return node;
    }
};

/** Is the first expression not equal to the second */
struct NE : public ExprNode<NE> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "NE of undefined");
        assert(b.defined() && "NE of undefined");
        assert(a.type() == b.type() && "NE of mismatched types");

        NE *node = new NE;
        node->type = Bool(a.type().width);
        node->a = a;
        node->b = b;
        return node;
    }
};

/** Is the first expression less than the second. */
struct LT : public ExprNode<LT> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "LT of undefined");
        assert(b.defined() && "LT of undefined");
        assert(a.type() == b.type() && "LT of mismatched types");

        LT *node = new LT;
        node->type = Bool(a.type().width);
        node->a = a;
        node->b = b;
        return node;
    }
};

/** Is the first expression less than or equal to the second. */
struct LE : public ExprNode<LE> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "LE of undefined");
        assert(b.defined() && "LE of undefined");
        assert(a.type() == b.type() && "LE of mismatched types");

        LE *node = new LE;
        node->type = Bool(a.type().width);
        node->a = a;
        node->b = b;
        return node;
    }
};

/** Is the first expression greater than the second. */
struct GT : public ExprNode<GT> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "GT of undefined");
        assert(b.defined() && "GT of undefined");
        assert(a.type() == b.type() && "GT of mismatched types");

        GT *node = new GT;
        node->type = Bool(a.type().width);
        node->a = a;
        node->b = b;
        return node;
    }
};

/** Is the first expression greater than or equal to the second. */
struct GE : public ExprNode<GE> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "GE of undefined");
        assert(b.defined() && "GE of undefined");
        assert(a.type() == b.type() && "GE of mismatched types");

        GE *node = new GE;
        node->type = Bool(a.type().width);
        node->a = a;
        node->b = b;
        return node;
    }
};

/** Logical and - are both expressions true */
struct And : public ExprNode<And> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "And of undefined");
        assert(b.defined() && "And of undefined");
        assert(a.type().is_bool() && "lhs of And is not a bool");
        assert(b.type().is_bool() && "rhs of And is not a bool");

        And *node = new And;
        node->type = Bool(a.type().width);
        node->a = a;
        node->b = b;
        return node;
    }
};

/** Logical or - is at least one of the expression true */
struct Or : public ExprNode<Or> {
    Expr a, b;

    static Expr make(Expr a, Expr b) {
        assert(a.defined() && "Or of undefined");
        assert(b.defined() && "Or of undefined");
        assert(a.type().is_bool() && "lhs of Or is not a bool");
        assert(b.type().is_bool() && "rhs of Or is not a bool");

        Or *node = new Or;
        node->type = Bool(a.type().width);
        node->a = a;
        node->b = b;
        return node;
    }
};

/** Logical not - true if the expression false */
struct Not : public ExprNode<Not> {
    Expr a;

    static Expr make(Expr a) {
        assert(a.defined() && "Not of undefined");
        assert(a.type().is_bool() && "argument of Not is not a bool");

        Not *node = new Not;
        node->type = Bool(a.type().width);
        node->a = a;
        return node;
    }
};

/** A ternary operator. Evalutes 'true_value' and 'false_value',
 * then selects between them based on 'condition'. Equivalent to
 * the ternary operator in C. */
struct Select : public ExprNode<Select> {
    Expr condition, true_value, false_value;

    static Expr make(Expr condition, Expr true_value, Expr false_value) {
        assert(condition.defined() && "Select of undefined");
        assert(true_value.defined() && "Select of undefined");
        assert(false_value.defined() && "Select of undefined");
        assert(condition.type().is_bool() && "First argument to Select is not a bool");
        assert(false_value.type() == true_value.type() && "Select of mismatched types");
        assert((condition.type().is_scalar() ||
                condition.type().width == true_value.type().width) &&
               "In Select, vector width of condition must either be 1, or equal to vector width of arguments");

        Select *node = new Select;
        node->type = true_value.type();
        node->condition = condition;
        node->true_value = true_value;
        node->false_value = false_value;
        return node;
    }
};

/** Load a value from a named buffer. The buffer is treated as an
 * array of the 'type' of this Load node. That is, the buffer has
 * no inherent type. */
struct Load : public ExprNode<Load> {
    std::string name;
    Expr index;

    // If it's a load from an image argument or compiled-in constant
    // image, this will point to that
    Buffer image;

    // If it's a load from an image parameter, this points to that
    Parameter param;

    static Expr make(Type type, std::string name, Expr index, Buffer image, Parameter param) {
        assert(index.defined() && "Load of undefined");
        assert(type.width == index.type().width && "Vector width of Load must match vector width of index");

        Load *node = new Load;
        node->type = type;
        node->name = name;
        node->index = index;
        node->image = image;
        node->param = param;
        return node;
    }
};

/** A linear ramp vector node. This is vector with 'width' elements,
 * where element i is 'base' + i*'stride'. This is a convenient way to
 * pass around vectors without busting them up into individual
 * elements. E.g. a dense vector load from a buffer can use a ramp
 * node with stride 1 as the index. */
struct Ramp : public ExprNode<Ramp> {
    Expr base, stride;
    int width;

    static Expr make(Expr base, Expr stride, int width) {
        assert(base.defined() && "Ramp of undefined");
        assert(stride.defined() && "Ramp of undefined");
        assert(base.type().is_scalar() && "Ramp with vector base");
        assert(stride.type().is_scalar() && "Ramp with vector stride");
        assert(width > 1 && "Ramp of width <= 1");
        assert(stride.type() == base.type() && "Ramp of mismatched types");

        Ramp *node = new Ramp;
        node->type = base.type().vector_of(width);
        node->base = base;
        node->stride = stride;
        node->width = width;
        return node;
    }
};

/** A vector with 'width' elements, in which every element is
 * 'value'. This is a special case of the ramp node above, in which
 * the stride is zero. */
struct Broadcast : public ExprNode<Broadcast> {
    Expr value;
    int width;

    static Expr make(Expr value, int width) {
        assert(value.defined() && "Broadcast of undefined");
        assert(value.type().is_scalar() && "Broadcast of vector");
        assert(width > 1 && "Broadcast of width <= 1");

        Broadcast *node = new Broadcast;
        node->type = value.type().vector_of(width);
        node->value = value;
        node->width = width;
        return node;
    }
};

/** A let expression, like you might find in a functional
 * language. Within the expression \ref body, instances of the Var
 * node \ref name refer to \ref value. */
struct Let : public ExprNode<Let> {
    std::string name;
    Expr value, body;

    static Expr make(std::string name, Expr value, Expr body) {
        assert(value.defined() && "Let of undefined");
        assert(body.defined() && "Let of undefined");

        Let *node = new Let;
        node->type = body.type();
        node->name = name;
        node->value = value;
        node->body = body;
        return node;
    }
};

/** The statement form of a let node. Within the statement 'body',
 * instances of the Var named 'name' refer to 'value' */
struct LetStmt : public StmtNode<LetStmt> {
    std::string name;
    Expr value;
    Stmt body;

    static Stmt make(std::string name, Expr value, Stmt body) {
        assert(value.defined() && "Let of undefined");
        assert(body.defined() && "Let of undefined");

        LetStmt *node = new LetStmt;
        node->name = name;
        node->value = value;
        node->body = body;
        return node;
    }
};

/** If the 'condition' is false, then bail out printing the
 * 'message' to stderr */
struct AssertStmt : public StmtNode<AssertStmt> {
    // if condition then val else error out with message
    Expr condition;
    std::string message;

    static Stmt make(Expr condition, std::string message) {
        assert(condition.defined() && "AssertStmt of undefined");

        AssertStmt *node = new AssertStmt;
        node->condition = condition;
        node->message = message;
        return node;
    }
};

/** This node is a helpful annotation to do with permissions. The
 * three child statements happen in order. In the 'produce'
 * statement 'buffer' is write-only. In 'update' it is
 * read-write. In 'consume' it is read-only. The 'update' node is
 * often NULL. (check update.defined() to find out). None of this
 * is actually enforced, the node is purely for informative
 * purposes to help out our analysis during lowering. */
struct Pipeline : public StmtNode<Pipeline> {
    std::string name;
    Stmt produce, update, consume;

    static Stmt make(std::string name, Stmt produce, Stmt update, Stmt consume) {
        assert(produce.defined() && "Pipeline of undefined");
        // update is allowed to be null
        assert(consume.defined() && "Pipeline of undefined");

        Pipeline *node = new Pipeline;
        node->name = name;
        node->produce = produce;
        node->update = update;
        node->consume = consume;
        return node;
    }
};

/** A for loop. Execute the 'body' statement for all values of the
 * variable 'name' from 'min' to 'min + extent'. There are four
 * types of For nodes. A 'Serial' for loop is a conventional
 * one. In a 'Parallel' for loop, each iteration of the loop
 * happens in parallel or in some unspecified order. In a
 * 'Vectorized' for loop, each iteration maps to one SIMD lane,
 * and the whole loop is executed in one shot. For this case,
 * 'extent' must be some small integer constant (probably 4, 8, or
 * 16). An 'Unrolled' for loop compiles to a completely unrolled
 * version of the loop. Each iteration becomes its own
 * statement. Again in this case, 'extent' should be a small
 * integer constant. */
struct For : public StmtNode<For> {
    std::string name;
    Expr min, extent;
    typedef enum {Serial, Parallel, Vectorized, Unrolled} ForType;
    ForType for_type;
    Stmt body;

    static Stmt make(std::string name, Expr min, Expr extent, ForType for_type, Stmt body) {
        assert(min.defined() && "For of undefined");
        assert(extent.defined() && "For of undefined");
        assert(min.type().is_scalar() && "For with vector min");
        assert(extent.type().is_scalar() && "For with vector extent");
        assert(body.defined() && "For of undefined");

        For *node = new For;
        node->name = name;
        node->min = min;
        node->extent = extent;
        node->for_type = for_type;
        node->body = body;
        return node;
    }
};

/** Store a 'value' to the buffer called 'name' at a given
 * 'index'. The buffer is interpreted as an array of the same type as
 * 'value'. */
struct Store : public StmtNode<Store> {
    std::string name;
    Expr value, index;

    static Stmt make(std::string name, Expr value, Expr index) {
        assert(value.defined() && "Store of undefined");
        assert(index.defined() && "Store of undefined");

        Store *node = new Store;
        node->name = name;
        node->value = value;
        node->index = index;
        return node;
    }
};

/** This defines the value of a function at a multi-dimensional
 * location. You should think of it as a store to a
 * multi-dimensional array. It gets lowered to a conventional
 * Store node. */
struct Provide : public StmtNode<Provide> {
    std::string name;
    std::vector<Expr> values;
    std::vector<Expr> args;

    static Stmt make(std::string name, const std::vector<Expr> &values, const std::vector<Expr> &args) {
        assert(!values.empty() && "Provide of no values");
        for (size_t i = 0; i < values.size(); i++) {
            assert(values[i].defined() && "Provide of undefined value");
        }
        for (size_t i = 0; i < args.size(); i++) {
            assert(args[i].defined() && "Provide to undefined location");
        }

        Provide *node = new Provide;
        node->name = name;
        node->values = values;
        node->args = args;
        return node;
    }
};

/** Allocate a scratch area called with the given name, type, and
 * size. The buffer lives for at most the duration of the body
 * statement, within which it is freed. It is an error for an allocate
 * node not to contain a free node of the same buffer. */
struct Allocate : public StmtNode<Allocate> {
    std::string name;
    Type type;
    Expr size;
    Stmt body;

    static Stmt make(std::string name, Type type, Expr size, Stmt body) {
        assert(size.defined() && "Allocate of undefined");
        assert(body.defined() && "Allocate of undefined");
        assert(size.type().is_scalar() == 1 && "Allocate of vector size");

        Allocate *node = new Allocate;
        node->name = name;
        node->type = type;
        node->size = size;
        node->body = body;
        return node;
    }
};

/** Free the resources associated with the given buffer. */
struct Free : public StmtNode<Free> {
    std::string name;

    static Stmt make(std::string name) {
        Free *node = new Free;
        node->name = name;
        return node;
    }
};

/** A single-dimensional span. Includes all numbers between min and
 * (min + extent - 1) */
struct Range {
    Expr min, extent;
    Range() {}
    Range(Expr min, Expr extent) : min(min), extent(extent) {
        assert(min.type() == extent.type() && "Region min and extent must have same type");
    }
};

/** A multi-dimensional box. The outer product of the elements */
typedef std::vector<Range> Region;

/** Allocate a multi-dimensional buffer of the given type and
 * size. Create some scratch memory that will back the function 'name'
 * over the range specified in 'bounds'. The bounds are a vector of
 * (min, extent) pairs for each dimension. */
struct Realize : public StmtNode<Realize> {
    std::string name;
    std::vector<Type> types;
    Region bounds;
    Stmt body;

    static Stmt make(const std::string &name, const std::vector<Type> &types, const Region &bounds, Stmt body) {
        for (size_t i = 0; i < bounds.size(); i++) {
            assert(bounds[i].min.defined() && "Realize of undefined");
            assert(bounds[i].extent.defined() && "Realize of undefined");
            assert(bounds[i].min.type().is_scalar() && "Realize of vector size");
            assert(bounds[i].extent.type().is_scalar() && "Realize of vector size");
        }
        assert(body.defined() && "Realize of undefined");
        assert(!types.empty() && "Realize has empty type");

        Realize *node = new Realize;
        node->name = name;
        node->types = types;
        node->bounds = bounds;
        node->body = body;
        return node;
    }
};

/** A sequence of statements to be executed in-order. 'rest' may be
 * NULL. Used rest.defined() to find out. */
struct Block : public StmtNode<Block> {
    Stmt first, rest;

    static Stmt make(Stmt first, Stmt rest) {
        assert(first.defined() && "Block of undefined");
        // rest is allowed to be null

        Block *node = new Block;
        node->first = first;
        node->rest = rest;
        return node;
    }
};

/** An if-then-else block. 'else' may be NULL. */
struct IfThenElse : public StmtNode<IfThenElse> {
    Expr condition;
    Stmt then_case, else_case;

    static Stmt make(Expr condition, Stmt then_case, Stmt else_case = Stmt()) {
        assert(condition.defined() && then_case.defined() && "IfThenElse of undefined");
        // else_case may be null.

        IfThenElse *node = new IfThenElse;
        node->condition = condition;
        node->then_case = then_case;
        node->else_case = else_case;
        return node;
    }
};

/** Evaluate and discard an expression, presumably because it has some side-effect. */
struct Evaluate : public StmtNode<Evaluate> {
    Expr value;

    static Stmt make(Expr v) {
        assert(v.defined() && "Evaluate of undefined");

        Evaluate *node = new Evaluate;
        node->value = v;
        return node;
    }
};

}
}
// Now that we've defined an Expr and ForType, we can include the definition of a function
#ifndef HALIDE_FUNCTION_H
#define HALIDE_FUNCTION_H

/** \file
 * Defines the internal representation of a halide function and related classes
 */

#ifndef HALIDE_REDUCTION_H
#define HALIDE_REDUCTION_H

/** \file
 * Defines internal classes related to Reduction Domains
 */

#include <string>
#include <vector>

namespace Halide {
namespace Internal {

/** A single named dimension of a reduction domain */
struct ReductionVariable {
    std::string var;
    Expr min, extent;
};

struct ReductionDomainContents {
    mutable RefCount ref_count;
    std::vector<ReductionVariable> domain;
};

/** A reference-counted handle on a reduction domain, which is just a
 * vector of ReductionVariable. */
class ReductionDomain {
    IntrusivePtr<ReductionDomainContents> contents;
public:
    /** Construct a new NULL reduction domain */
    ReductionDomain() : contents(NULL) {}

    /** Construct a reduction domain that spans the outer product of
     * all values of the given ReductionVariable in scanline order,
     * with the start of the vector being innermost, and the end of
     * the vector being outermost. */
    ReductionDomain(const std::vector<ReductionVariable> &domain) : 
        contents(new ReductionDomainContents) {
        contents.ptr->domain = domain;
    }

    /** Is this handle non-NULL */
    bool defined() const {
        return contents.defined();
    }

    /** Tests for equality of reference. Only one reduction domain is
     * allowed per reduction function, and this is used to verify
     * that */
    bool same_as(const ReductionDomain &other) const {
        return contents.same_as(other.contents);
    }

    /** Immutable access to the reduction variables. */
    const std::vector<ReductionVariable> &domain() const {
        return contents.ptr->domain;
    }
};

}
}

#endif
#ifndef HALIDE_SCHEDULE_H
#define HALIDE_SCHEDULE_H

/** \file
 * Defines the internal representation of the schedule for a function
 */

#include <string>
#include <vector>

namespace Halide {
namespace Internal {

/** A schedule for a halide function, which defines where, when, and
 * how it should be evaluated. */
struct Schedule {
    /** A reference to a site in a Halide statement at the top of the
     * body of a particular for loop. Evaluating a region of a halide
     * function is done by generating a loop nest that spans its
     * dimensions. We schedule the inputs to that function by
     * recursively injecting realizations for them at particular sites
     * in this loop nest. A LoopLevel identifies such a site. */
    struct LoopLevel {
        std::string func, var;

        /** Identify the loop nest corresponding to some dimension of some function */
        LoopLevel(std::string f, std::string v) : func(f), var(v) {}

        /** Construct an empty LoopLevel, which is interpreted as
         * 'inline'. This is a special LoopLevel value that implies
         * that a function should be inlined away */
        LoopLevel() {}

        /** Test if a loop level corresponds to inlining the function */
        bool is_inline() const {return var.empty();}

        /** root is a special LoopLevel value which represents the
         * location outside of all for loops */
        static LoopLevel root() {
            return LoopLevel("", "<root>");
        }
        /** Test if a loop level is 'root', which describes the site
         * outside of all for loops */
        bool is_root() const {return var == "<root>";}

        /** Compare this loop level against the variable name of a for
         * loop, to see if this loop level refers to the site
         * immediately inside this loop. */
        bool match(const std::string &loop) const {
            return starts_with(loop, func + ".") && ends_with(loop, "." + var);
        }

        bool match(const LoopLevel &other) const {
            return (func == other.func &&
                    (var == other.var ||
                     ends_with(var, "." + other.var) ||
                     ends_with(other.var, "." + var)));
        }

    };

    /** At what sites should we inject the allocation and the
     * computation of this function? The store_level must be outside
     * of or equal to the compute_level. If the compute_level is
     * inline, the store_level is meaningless. See \ref Func::store_at
     * and \ref Func::compute_at */
    // @{
    LoopLevel store_level, compute_level;
    // @}

    struct Split {
        std::string old_var, outer, inner;
        Expr factor;

        enum SplitType {SplitVar = 0, RenameVar, FuseVars};

        // If split_type is Rename, then this is just a renaming of the
        // old_var to the outer and not a split. The inner var should
        // be ignored, and factor should be one. Renames are kept in
        // the same list as splits so that ordering between them is
        // respected.

        // If split_type is Fuse, then this does the opposite of a
        // split, it joins the outer and inner into the old_var.
        SplitType split_type;

        bool is_rename() const {return split_type == RenameVar;}
        bool is_split() const {return split_type == SplitVar;}
        bool is_fuse() const {return split_type == FuseVars;}
    };
    /** The traversal of the domain of a function can have some of its
     * dimensions split into sub-dimensions. See
     * \ref ScheduleHandle::split */
    std::vector<Split> splits;

    struct Dim {
        std::string var;
        For::ForType for_type;
    };
    /** The list and ordering of dimensions used to evaluate this
     * function, after all splits have taken place. The first
     * dimension in the vector corresponds to the innermost for loop,
     * and the last is the outermost. Also specifies what type of for
     * loop to use for each dimension. Does not specify the bounds on
     * each dimension. These get inferred from how the function is
     * used, what the splits are, and any optional bounds in the list below. */
    std::vector<Dim> dims;

    /** The list and order of dimensions used to store this
     * function. The first dimension in the vector corresponds to the
     * innermost dimension for storage (i.e. which dimension is
     * tightly packed in memory) */
    std::vector<std::string> storage_dims;

    struct Bound {
        std::string var;
        Expr min, extent;
    };
    /** You may explicitly bound some of the dimensions of a
     * function. See \ref ScheduleHandle::bound */
    std::vector<Bound> bounds;
};

}
}

#endif
#include <string>
#include <vector>

namespace Halide {

namespace Internal {
struct FunctionContents;
}

/** An argument to an extern-defined Func. May be a Function, Buffer,
 * ImageParam or Expr. */
struct ExternFuncArgument {
    enum ArgType {UndefinedArg = 0, FuncArg, BufferArg, ExprArg, ImageParamArg};
    ArgType arg_type;
    Internal::IntrusivePtr<Internal::FunctionContents> func;
    Buffer buffer;
    Expr expr;
    Internal::Parameter image_param;

    ExternFuncArgument(Internal::IntrusivePtr<Internal::FunctionContents> f): arg_type(FuncArg), func(f) {}

    ExternFuncArgument(Buffer b): arg_type(BufferArg), buffer(b) {}

    ExternFuncArgument(Expr e): arg_type(ExprArg), expr(e) {}

    ExternFuncArgument(Internal::Parameter p) : arg_type(ImageParamArg), image_param(p) {
        assert(p.is_buffer());
    }
    ExternFuncArgument() : arg_type(UndefinedArg) {}

    bool is_func() const {return arg_type == FuncArg;}
    bool is_expr() const {return arg_type == ExprArg;}
    bool is_buffer() const {return arg_type == BufferArg;}
    bool is_image_param() const {return arg_type == ImageParamArg;}
    bool defined() const {return arg_type != UndefinedArg;}
};

namespace Internal {


struct FunctionContents {
    mutable RefCount ref_count;
    std::string name;
    std::vector<std::string> args;
    std::vector<Expr> values;
    std::vector<Type> output_types;
    Schedule schedule;

    std::vector<Expr> reduction_values;
    std::vector<Expr> reduction_args;
    Schedule reduction_schedule;
    ReductionDomain reduction_domain;

    std::string debug_file;

    std::vector<Parameter> output_buffers;

    std::vector<ExternFuncArgument> extern_arguments;
    std::string extern_function_name;

    bool trace_loads, trace_stores, trace_realizations;

    FunctionContents() : trace_loads(false), trace_stores(false), trace_realizations(false) {}
};

/** A reference-counted handle to Halide's internal representation of
 * a function. Similar to a front-end Func object, but with no
 * syntactic sugar to help with definitions. */
class Function {
private:
    IntrusivePtr<FunctionContents> contents;
public:
    /** Construct a new function with no definitions and no name. This
     * constructor only exists so that you can make vectors of
     * functions, etc.
     */
    Function() : contents(new FunctionContents) {}

    /** Reconstruct a Function from a FunctionContents pointer. */
    Function(const IntrusivePtr<FunctionContents> &c) : contents(c) {}

    /** Add a pure definition to this function. It may not already
     * have a definition. All the free variables in 'value' must
     * appear in the args list. 'value' must not depend on any
     * reduction domain */
    void define(const std::vector<std::string> &args, std::vector<Expr> values);

    /** Add a reduction definition to this function. It must already
     * have a pure definition but not a reduction definition, and the
     * length of args must match the length of args used in the pure
     * definition. 'value' must depend on some reduction domain, and
     * may contain variables from that domain as well as pure
     * variables. Any pure variables must also appear as Variables in
     * the args array, and they must have the same name as the pure
     * definition's argument in the same index. */
    void define_reduction(const std::vector<Expr> &args, std::vector<Expr> values);

    /** Construct a new function with the given name */
    Function(const std::string &n) : contents(new FunctionContents) {
        for (size_t i = 0; i < n.size(); i++) {
            assert(n[i] != '.' && "Func names may not contain the character '.', as it is used internally by Halide as a separator");
        }
        contents.ptr->name = n;
    }

    /** Get the name of the function */
    const std::string &name() const {
        return contents.ptr->name;
    }

    /** Get the pure arguments */
    const std::vector<std::string> &args() const {
        return contents.ptr->args;
    }

    /** Get the dimensionality */
    int dimensions() const {
        return (int)args().size();
    }

    /** Get the number of outputs */
    int outputs() const {
        return (int)output_types().size();
    }

    /** Get the types of the outputs */
    const std::vector<Type> &output_types() const {
        return contents.ptr->output_types;
    }

    /** Get the right-hand-side of the pure definition */
    const std::vector<Expr> &values() const {
        return contents.ptr->values;
    }

    /** Does this function have a pure definition */
    bool has_pure_definition() const {
        return !contents.ptr->values.empty();
    }

    /** Get a handle to the schedule for the purpose of modifying
     * it */
    Schedule &schedule() {
        return contents.ptr->schedule;
    }

    /** Get a const handle to the schedule for inspecting it */
    const Schedule &schedule() const {
        return contents.ptr->schedule;
    }

    /** Get a handle on the output buffer used for setting constraints
     * on it. */
    const std::vector<Parameter> &output_buffers() const {
        return contents.ptr->output_buffers;
    }

    /** Get a mutable handle to the schedule for the reduction
     * stage */
    Schedule &reduction_schedule() {
        return contents.ptr->reduction_schedule;
    }

    /** Get a const handle to the schedule for the reduction stage */
    const Schedule &reduction_schedule() const {
        return contents.ptr->reduction_schedule;
    }

    /** Get the right-hand-side of the reduction definition */
    const std::vector<Expr> &reduction_values() const {
        return contents.ptr->reduction_values;
    }

    /** Does this function have a reduction definition */
    bool has_reduction_definition() const {
        return !contents.ptr->reduction_values.empty();
    }

    /** Get the left-hand-side of the reduction definition */
    const std::vector<Expr> &reduction_args() const {
        return contents.ptr->reduction_args;
    }

    /** Get the reduction domain for the reduction definition */
    ReductionDomain reduction_domain() const {
        return contents.ptr->reduction_domain;
    }

    /** Check if the function has an extern definition */
    bool has_extern_definition() const {
        return !contents.ptr->extern_function_name.empty();
    }

    /** Add an external definition of this Func */
    void define_extern(const std::string &function_name,
                       const std::vector<ExternFuncArgument> &args,
                       const std::vector<Type> &types,
                       int dimensionality);

    /** Retrive the arguments of the extern definition */
    const std::vector<ExternFuncArgument> &extern_arguments() const {
        return contents.ptr->extern_arguments;
    }

    /** Get the name of the extern function called for an extern
     * definition. */
    const std::string &extern_function_name() const {
        return contents.ptr->extern_function_name;
    }

    /** Equality of identity */
    bool same_as(const Function &other) const {
        return contents.same_as(other.contents);
    }

    /** Get a const handle to the debug filename */
    const std::string &debug_file() const {
        return contents.ptr->debug_file;
    }

    /** Get a handle to the debug filename */
    std::string &debug_file() {
        return contents.ptr->debug_file;
    }

    /** Use an an extern argument to another function. */
    operator ExternFuncArgument() const {
        return ExternFuncArgument(contents);
    }

    /** Tracing calls and accessors, passed down from the Func
     * equivalents. */
    // @{
    void trace_loads() {
        contents.ptr->trace_loads = true;
    }
    void trace_stores() {
        contents.ptr->trace_stores = true;
    }
    void trace_realizations() {
        contents.ptr->trace_realizations = true;
    }
    bool is_tracing_loads() {
        return contents.ptr->trace_loads;
    }
    bool is_tracing_stores() {
        return contents.ptr->trace_stores;
    }
    bool is_tracing_realizations() {
        return contents.ptr->trace_realizations;
    }
    // @}

    /** What's the smallest amount of this Function that can be
     * produced? This is a function of the splits being done. Ignores
     * writes due to scattering done by reductions. */
    Expr min_extent_produced(const std::string &dim) const;

    /** Reductions also have a minimum granularity with which they can
     * be computed in the pure vars (because they can't hit the same
     * pure variable twice). This function retrieves that. */
    Expr min_extent_updated(const std::string &dim) const;
};

}}

#endif

// And the definition of a reduction domain

namespace Halide {
namespace Internal {

/** A function call. This can represent a call to some extern
 * function (like sin), but it's also our multi-dimensional
 * version of a Load, so it can be a load from an input image, or
 * a call to another halide function. The latter two types of call
 * nodes don't survive all the way down to code generation - the
 * lowering process converts them to Load nodes. */
struct Call : public ExprNode<Call> {
    std::string name;
    std::vector<Expr> args;
    typedef enum {Image, Extern, Halide, Intrinsic} CallType;
    CallType call_type;

    // Halide uses calls internally to represent certain operations
    // (instead of IR nodes). These are matched by name.
    EXPORT static const std::string debug_to_file,
        shuffle_vector,
        interleave_vectors,
        reinterpret,
        bitwise_and,
        bitwise_not,
        bitwise_xor,
        bitwise_or,
        shift_left,
        shift_right,
        rewrite_buffer,
        profiling_timer,
        lerp,
        create_buffer_t,
        extract_buffer_min,
        extract_buffer_extent,
        trace;

    // If it's a call to another halide function, this call node
    // holds onto a pointer to that function.
    Function func;

    // If that function has multiple values, which value does this
    // call node refer to?
    int value_index;

    // If it's a call to an image, this call nodes hold a
    // pointer to that image's buffer
    Buffer image;

    // If it's a call to an image parameter, this call nodes holds a
    // pointer to that
    Parameter param;

    static Expr make(Type type, std::string name, const std::vector<Expr> &args, CallType call_type,
                     Function func = Function(), int value_index = 0,
                     Buffer image = Buffer(), Parameter param = Parameter()) {
        for (size_t i = 0; i < args.size(); i++) {
            assert(args[i].defined() && "Call of undefined");
        }
        if (call_type == Halide) {
            assert(value_index >= 0 &&
                   value_index < func.outputs() &&
                   "Value index out of range in call to halide function");
            assert((func.has_pure_definition() || func.has_extern_definition()) && "Call to undefined halide function");
            assert((int)args.size() <= func.dimensions() && "Call node with too many arguments.");
            for (size_t i = 0; i < args.size(); i++) {
                assert(args[i].type() == Int(32) && "Args to call to halide function must be type Int(32)");
            }
        } else if (call_type == Image) {
            assert((param.defined() || image.defined()) && "Call node to undefined image");
            for (size_t i = 0; i < args.size(); i++) {
                assert(args[i].type() == Int(32) && "Args to load from image must be type Int(32)");
            }
        }

        Call *node = new Call;
        node->type = type;
        node->name = name;
        node->args = args;
        node->call_type = call_type;
        node->func = func;
        node->value_index = value_index;
        node->image = image;
        node->param = param;
        return node;
    }

    /** Convenience constructor for calls to other halide functions */
    static Expr make(Function func, const std::vector<Expr> &args, int idx = 0) {
        assert(idx >= 0 &&
               idx < func.outputs() &&
               "Value index out of range in call to halide function");
        assert((func.has_pure_definition() || func.has_extern_definition()) &&
               "Call to undefined halide function");
        return make(func.output_types()[idx], func.name(), args, Halide, func, idx, Buffer(), Parameter());
    }

    /** Convenience constructor for loads from concrete images */
    static Expr make(Buffer image, const std::vector<Expr> &args) {
        return make(image.type(), image.name(), args, Image, Function(), 0, image, Parameter());
    }

    /** Convenience constructor for loads from images parameters */
    static Expr make(Parameter param, const std::vector<Expr> &args) {
        return make(param.type(), param.name(), args, Image, Function(), 0, Buffer(), param);
    }

};

/** A named variable. Might be a loop variable, function argument,
 * parameter, reduction variable, or something defined by a Let or
 * LetStmt node. */
struct Variable : public ExprNode<Variable> {
    std::string name;

    /** References to scalar parameters, or to the dimensions of buffer
     * parameters hang onto those expressions */
    Parameter param;

    /** Reduction variables hang onto their domains */
    ReductionDomain reduction_domain;

    static Expr make(Type type, std::string name) {
        return make(type, name, Parameter(), ReductionDomain());
    }

    static Expr make(Type type, std::string name, Parameter param) {
        return make(type, name, param, ReductionDomain());
    }

    static Expr make(Type type, std::string name, ReductionDomain reduction_domain) {
        return make(type, name, Parameter(), reduction_domain);
    }

    static Expr make(Type type, std::string name, Parameter param, ReductionDomain reduction_domain) {
        Variable *node = new Variable;
        node->type = type;
        node->name = name;
        node->param = param;
        node->reduction_domain = reduction_domain;
        return node;
    }

};

}
}

#endif
#ifndef HALIDE_SCOPE_H
#define HALIDE_SCOPE_H

#include <string>
#include <map>
#include <stack>
#include <utility>
#include <iostream>

#ifndef HALIDE_DEBUG_H
#define HALIDE_DEBUG_H

/** \file
 * Defines functions for debug logging during code generation.
 */

#include <iostream>
#include <string>

namespace Halide {
namespace Internal {

/** For optional debugging during codegen, use the debug class as
 * follows: 
 * 
 \code
 debug(verbosity) << "The expression is " << expr << std::endl; 
 \endcode
 *
 * verbosity of 0 always prints, 1 should print after every major
 * stage, 2 should be used for more detail, and 3 should be used for
 * tracing everything that occurs. The verbosity with which to print
 * is determined by the value of the environment variable
 * HL_DEBUG_CODEGEN
 */

struct debug {
    static int debug_level;
    static bool initialized;
    int verbosity;

    debug(int v) : verbosity(v) {
        if (!initialized) {
            // Read the debug level from the environment
            #ifdef _WIN32
            char lvl[32];
            size_t read = 0;
            getenv_s(&read, lvl, "HL_DEBUG_CODEGEN");
            if (read) {
            #else   
            if (char *lvl = getenv("HL_DEBUG_CODEGEN")) {
            #endif
                debug_level = atoi(lvl);
            } else {
                debug_level = 0;
            }

            initialized = true;
        }
    }

    template<typename T>
    debug &operator<<(T x) {
        if (verbosity > debug_level) return *this;
        std::cerr << x;
        return *this;
    }
};

}
}

#endif

/** \file
 * Defines the Scope class, which is used for keeping track of names in a scope while traversing IR
 */

namespace Halide {
namespace Internal {

/** A stack which can store one item very efficiently. Using this
 * instead of std::stack speeds up Scope substantially. */
template<typename T>
class SmallStack {
private:
    T _top;
    std::vector<T> _rest;
    bool _empty;

public:
    SmallStack() : _empty(true) {}

    void pop() {
        assert(!_empty);
        if (_rest.empty()) {
            _empty = true;
            _top = T();
        } else {
            _top = _rest.back();
            _rest.pop_back();
        }
    }

    void push(const T &t) {
        if (_empty) {
            _empty = false;
        } else {
            _rest.push_back(_top);
        }
        _top = t;
    }

    T top() const {
        assert(!_empty);
        return _top;
    }

    T &top_ref() {
        assert(!_empty);
        return _top;
    }

    bool empty() const {
        return _empty;
    }
};

/** A common pattern when traversing Halide IR is that you need to
 * keep track of stuff when you find a Let or a LetStmt, and that it
 * should hide previous values with the same name until you leave the
 * Let or LetStmt nodes This class helps with that. */
template<typename T>
class Scope {
private:
    std::map<std::string, SmallStack<T> > table;
public:
    Scope() {}

    /** Retrive the value referred to by a name */
    T get(const std::string &name) const {
        typename std::map<std::string, SmallStack<T> >::const_iterator iter = table.find(name);
        if (iter == table.end() || iter->second.empty()) {
            std::cerr << "Symbol '" << name << "' not found" << std::endl;
            assert(false);
        }
        return iter->second.top();
    }

    /** Return a reference to an entry */
    T &ref(const std::string &name) {
        typename std::map<std::string, SmallStack<T> >::iterator iter = table.find(name);
        if (iter == table.end() || iter->second.empty()) {
            std::cerr << "Symbol '" << name << "' not found" << std::endl;
            assert(false);
        }
        return iter->second.top_ref();
    }

    /** Tests if a name is in scope */
    bool contains(const std::string &name) const {
        typename std::map<std::string, SmallStack<T> >::const_iterator iter = table.find(name);
        return iter != table.end() && !iter->second.empty();
    }

    /** Add a new (name, value) pair to the current scope. Hide old
     * values that have this name until we pop this name.
     */
    void push(const std::string &name, const T &value) {
        table[name].push(value);
    }

    /** A name goes out of scope. Restore whatever its old value
     * was (or remove it entirely if there was nothing else of the
     * same name in an outer scope) */
    void pop(const std::string &name) {
        typename std::map<std::string, SmallStack<T> >::iterator iter = table.find(name);
        assert(iter != table.end() && "Name not in symbol table");
        iter->second.pop();
        if (iter->second.empty()) {
            table.erase(iter);
        }
    }

    /** Iterate through the scope. */
    class const_iterator {
        typename std::map<std::string, SmallStack<T> >::const_iterator iter;
    public:
        explicit const_iterator(const typename std::map<std::string, SmallStack<T> >::const_iterator &i) :
            iter(i) {
        }

        const_iterator() {}

        bool operator!=(const const_iterator &other) {
            return iter != other.iter;
        }

        void operator++() {
            ++iter;
        }

        const std::string &name() {
            return iter->first;
        }

        const SmallStack<T> &stack() {
            return iter->second;
        }

        const T &value() {
            return iter->second.top();
        }
    };

    const_iterator cbegin() const {
        return const_iterator(table.begin());
    }

    const_iterator cend() const {
        return const_iterator(table.end());
    }

    class iterator {
        typename std::map<std::string, SmallStack<T> >::iterator iter;
    public:
        explicit iterator(typename std::map<std::string, SmallStack<T> >::iterator i) :
            iter(i) {
        }

        iterator() {}

        bool operator!=(const iterator &other) {
            return iter != other.iter;
        }

        void operator++() {
            ++iter;
        }

        const std::string &name() {
            return iter->first;
        }

        SmallStack<T> &stack() {
            return iter->second;
        }

        T &value() {
            return iter->second.top_ref();
        }
    };

    iterator begin() {
        return iterator(table.begin());
    }

    iterator end() {
        return iterator(table.end());
    }
};

template<typename T>
std::ostream &operator<<(std::ostream &stream, Scope<T>& s) {
    stream << "{\n";
    typename Scope<T>::const_iterator iter;
    for (iter = s.cbegin(); iter != s.cend(); ++iter) {
        stream << "  " << iter.name() << "\n";
    }
    stream << "}";
    return stream;
}

}
}

#endif
#include <utility>
#include <vector>

/** \file
 * Methods for computing the upper and lower bounds of an expression,
 * and the regions of a function read or written by a statement.
 */

namespace Halide {
namespace Internal {

struct Interval {
    Expr min, max;
    Interval() {}
    Interval(Expr min, Expr max) : min(min), max(max) {}
};

/** Given an expression in some variables, and a map from those
 * variables to their bounds (in the form of (minimum possible value,
 * maximum possible value)), compute two expressions that give the
 * minimum possible value and the maximum possible value of this
 * expression. Max or min may be undefined expressions if the value is
 * not bounded above or below.
 *
 * This is for tasks such as deducing the region of a buffer
 * loaded by a chunk of code.
 */
Interval bounds_of_expr_in_scope(Expr expr, const Scope<Interval> &scope);

/** Compute rectangular domains large enough to cover all the 'Call's
 * to each function that occurs within a given statement. This is
 * useful for figuring out what regions of things to evaluate. */
std::map<std::string, Region> regions_called(Stmt s);

/** Compute rectangular domains large enough to cover all the
 * 'Provide's to each function that occur within a given
 * statement. This is useful for figuring out what region of a
 * function a scattering reduction (e.g. a histogram) might touch. */
std::map<std::string, Region> regions_provided(Stmt s);

/** Compute rectangular domains large enough to cover all Calls and
 * Provides to each function that occurs within a given statement */
std::map<std::string, Region> regions_touched(Stmt s);

/** Compute a rectangular domain large enough to cover all Calls and
 * Provides to a given function */
Region region_touched(Stmt s, const std::string &func);

/** Compute a rectangular domain large enough to cover all Provides to
 * a given function */
Region region_provided(Stmt s, const std::string &func);

/** Compute a rectangular domain large enough to cover all Calls
 * to a given function */
Region region_called(Stmt s, const std::string &func);

/** Compute the smallest bounding box that contains two regions */
Region region_union(const Region &, const Region &);

void bounds_test();

}
}

#endif
#ifndef HALIDE_BOUNDS_INFERENCE_H
#define HALIDE_BOUNDS_INFERENCE_H

/** \file 
 * Defines the bounds_inference lowering pass.
 */

#include <map>

namespace Halide {
namespace Internal {

/** Take a partially lowered statement that includes symbolic
 * representations of the bounds over which things should be realized,
 * and inject expressions defining those bounds.
 */
Stmt bounds_inference(Stmt, 
                      const std::vector<std::string> &realization_order, 
                      const std::map<std::string, Function> &environment);

}
}

#endif
#ifndef HALIDE_CODEGEN_C_H
#define HALIDE_CODEGEN_C_H

/** \file
 *
 * Defines an IRPrinter that emits C++ code equivalent to a halide stmt
 */

#ifndef HALIDE_IR_PRINTER_H
#define HALIDE_IR_PRINTER_H

#include <ostream>

namespace Halide {

/** \file
 * This header file defines operators that let you dump a Halide
 * expression, statement, or type directly into an output stream
 * in a human readable form.
 * E.g:
 \code
 Expr foo = ...
 std::cout << "Foo is " << foo << std::endl;
 \endcode
 *
 * These operators are implemented using \ref Halide::Internal::IRPrinter
 */

/** Emit an expression on an output stream (such as std::cout) in a
 * human-readable form */
EXPORT std::ostream &operator<<(std::ostream &stream, Expr);

/** Emit a halide type on an output stream (such as std::cout) in a
 * human-readable form */
EXPORT std::ostream &operator<<(std::ostream &stream, Type);

namespace Internal {

/** Emit a halide statement on an output stream (such as std::cout) in
 * a human-readable form */
std::ostream &operator<<(std::ostream &stream, Stmt);

/** Emit a halide for loop type (vectorized, serial, etc) in a human
 * readable form */
std::ostream &operator<<(std::ostream &stream, const For::ForType &);

/** An IRVisitor that emits IR to the given output stream in a human
 * readable form. Can be subclassed if you want to modify the way in
 * which it prints.
 */
class IRPrinter : public IRVisitor {
public:
    /** Construct an IRPrinter pointed at a given output stream
     * (e.g. std::cout, or a std::ofstream) */
    IRPrinter(std::ostream &);

    /** emit an expression on the output stream */
    void print(Expr);

    /** emit a statement on the output stream */
    void print(Stmt);

    static void test();

protected:
    /** The stream we're outputting on */
    std::ostream &stream;

    /** The current indentation level, useful for pretty-printing
     * statements */
    int indent;

    /** Emit spaces according to the current indentation level */
    void do_indent();

    void visit(const IntImm *);
    void visit(const FloatImm *);
    void visit(const StringImm *);
    void visit(const Cast *);
    void visit(const Variable *);
    void visit(const Add *);
    void visit(const Sub *);
    void visit(const Mul *);
    void visit(const Div *);
    void visit(const Mod *);
    void visit(const Min *);
    void visit(const Max *);
    void visit(const EQ *);
    void visit(const NE *);
    void visit(const LT *);
    void visit(const LE *);
    void visit(const GT *);
    void visit(const GE *);
    void visit(const And *);
    void visit(const Or *);
    void visit(const Not *);
    void visit(const Select *);
    void visit(const Load *);
    void visit(const Ramp *);
    void visit(const Broadcast *);
    void visit(const Call *);
    void visit(const Let *);
    void visit(const LetStmt *);
    void visit(const AssertStmt *);
    void visit(const Pipeline *);
    void visit(const For *);
    void visit(const Store *);
    void visit(const Provide *);
    void visit(const Allocate *);
    void visit(const Free *);
    void visit(const Realize *);
    void visit(const Block *);
    void visit(const IfThenElse *);
    void visit(const Evaluate *);

};
}
}

#endif
#include <string>
#include <vector>
#include <ostream>
#include <map>

namespace Halide {
namespace Internal {

/** This class emits C++ code equivalent to a halide Stmt. It's
 * mostly the same as an IRPrinter, but it's wrapped in a function
 * definition, and some things are handled differently to be valid
 * C++.
 */
class CodeGen_C : public IRPrinter {
public:
    /** Initialize a C code generator pointing at a particular output
     * stream (e.g. a file, or std::cout) */
    CodeGen_C(std::ostream &);

    /** Emit source code equivalent to the given statement, wrapped in
     * a function with the given type signature */
    void compile(Stmt stmt, std::string name, const std::vector<Argument> &args);

    /** Emit a header file defining a halide pipeline with the given
     * type signature */
    void compile_header(const std::string &name, const std::vector<Argument> &args);

    static void test();

protected:
    /** An for the most recently generated ssa variable */
    std::string id;

    /** A cache of generated values in scope */
    std::map<std::string, std::string> cache;

    /** Emit an expression as an assignment, then return the id of the
     * resulting var */
    std::string print_expr(Expr);

    /** Emit a statement */
    void print_stmt(Stmt);

    /** Emit the C name for a halide type */
    virtual std::string print_type(Type);

    /** Emit a version of a string that is a valid identifier in C (. is replaced with _) */
    std::string print_name(const std::string &);

    /** Emit an SSA-style assignment, and set id to the freshly generated name */
    void print_assignment(Type t, const std::string &rhs);

    /** Open a new C scope (i.e. throw in a brace, increase the indent) */
    void open_scope();

    /** Close a C scope (i.e. throw in an end brace, decrease the indent) */
    void close_scope(const std::string &comment);

    /** Track the types of allocations to avoid unnecessary casts. */
    Scope<Type> allocations;

    /** Track which allocations actually went on the heap. */
    Scope<int> heap_allocations;

    using IRPrinter::visit;

    void visit(const Variable *);
    void visit(const IntImm *);
    void visit(const FloatImm *);
    void visit(const Cast *);
    void visit(const Add *);
    void visit(const Sub *);
    void visit(const Mul *);
    void visit(const Div *);
    void visit(const Mod *);
    void visit(const Max *);
    void visit(const Min *);
    void visit(const EQ *);
    void visit(const NE *);
    void visit(const LT *);
    void visit(const LE *);
    void visit(const GT *);
    void visit(const GE *);
    void visit(const And *);
    void visit(const Or *);
    void visit(const Not *);
    void visit(const Call *);
    void visit(const Select *);
    void visit(const Load *);
    void visit(const Store *);
    void visit(const Let *);
    void visit(const LetStmt *);
    void visit(const AssertStmt *);
    void visit(const Pipeline *);
    void visit(const For *);
    void visit(const Provide *);
    void visit(const Allocate *);
    void visit(const Free *);
    void visit(const Realize *);
    void visit(const IfThenElse *);
    void visit(const Evaluate *);

    void visit_binop(Type t, Expr a, Expr b, const char *op);
};

}
}

#endif
#ifndef HALIDE_CODEGEN_H
#define HALIDE_CODEGEN_H

/** \file
 *
 * Defines the base-class for all architecture-specific code
 * generators that use llvm.
 */

namespace llvm {
class Value;
class Module;
class Function;
template<bool> class IRBuilderDefaultInserter;
class ConstantFolder;
template<bool, typename, typename> class IRBuilder;
class LLVMContext;
class Type;
class StructType;
class Instruction;
class CallInst;
class ExecutionEngine;
class AllocaInst;
}

#include <map>
#include <stack>
#include <string>
#include <vector>

#ifndef HALIDE_MODULUS_REMAINDER_H
#define HALIDE_MODULUS_REMAINDER_H

/** \file
 * Routines for statically determining what expressions are divisible by.
 */


namespace Halide {
namespace Internal {

/** The result of modulus_remainder analysis */
struct ModulusRemainder {
    ModulusRemainder() : modulus(0), remainder(0) {}
    ModulusRemainder(int m, int r) : modulus(m), remainder(r) {}
    int modulus, remainder;
};

/** For things like alignment analysis, often it's helpful to know
 * if an integer expression is some multiple of a constant plus
 * some other constant. For example, it is straight-forward to
 * deduce that ((10*x + 2)*(6*y - 3) - 1) is congruent to five
 * modulo six.
 *
 * We get the most information when the modulus is large. E.g. if
 * something is congruent to 208 modulo 384, then we also know it's
 * congruent to 0 mod 8, and we can possibly use it as an index for an
 * aligned load. If all else fails, we can just say that an integer is
 * congruent to zero modulo one.
 */
ModulusRemainder modulus_remainder(Expr e);

/** If we have alignment information about external variables, we can
 * let the analysis know about that using this version of
 * modulus_remainder: */
ModulusRemainder modulus_remainder(Expr e, const Scope<ModulusRemainder> &scope);

/** Reduce an expression modulo some integer. Returns true and assigns
 * to remainder if an answer could be found. */
bool reduce_expr_modulo(Expr e, int modulus, int *remainder);

void modulus_remainder_test();

/** The greatest common divisor of two integers */
int gcd(int, int);

}
}

#endif

namespace Halide {
namespace Internal {

/** A code generator abstract base class. Actual code generators
 * (e.g. CodeGen_X86) inherit from this. This class is responsible
 * for taking a Halide Stmt and producing llvm bitcode, machine
 * code in an object file, or machine code accessible through a
 * function pointer.
 */
class CodeGen : public IRVisitor {
public:
    mutable RefCount ref_count;

    CodeGen();
    virtual ~CodeGen();

    /** Take a halide statement and compiles it to an llvm module held
     * internally. Call this before calling compile_to_bitcode or
     * compile_to_native. */
    virtual void compile(Stmt stmt, std::string name, const std::vector<Argument> &args);

    /** Emit a compiled halide statement as llvm bitcode. Call this
     * after calling compile. */
    void compile_to_bitcode(const std::string &filename);

    /** Emit a compiled halide statement as either an object file, or
     * as raw assembly, depending on the value of the second
     * argument. Call this after calling compile. */
    void compile_to_native(const std::string &filename, bool assembly = false);

    /** Compile to machine code stored in memory, and return some
     * functions pointers into that machine code. */
    JITCompiledModule compile_to_function_pointers();

    /** What should be passed as -mcpu, -mattrs, and related for
     * compilation. The architecture-specific code generator should
     * define these. */
    // @{
    virtual std::string mcpu() const = 0;
    virtual std::string mattrs() const = 0;
    virtual bool use_soft_float_abi() const = 0;
    // @}

    /** Do any required target-specific things to the execution engine
     * and the module prior to jitting. Called by JITCompiledModule
     * just before it jits. Does nothing by default. */
    virtual void jit_init(llvm::ExecutionEngine *, llvm::Module *) {}

    /** Do any required target-specific things to the execution engine
     * and the module after jitting. Called by JITCompiledModule just
     * after it jits. Does nothing by default. The third argument
     * gives the target a chance to inject calls to target-specific
     * module cleanup routines. */
    virtual void jit_finalize(llvm::ExecutionEngine *, llvm::Module *, std::vector<void (*)()> *) {}

protected:

    /** State needed by llvm for code generation, including the
     * current module, function, context, builder, and most recently
     * generated llvm value. */
    //@{
    static bool llvm_initialized;
    static bool llvm_X86_enabled;
    static bool llvm_ARM_enabled;
    static bool llvm_NVPTX_enabled;

    llvm::Module *module;
    bool owns_module;
    llvm::Function *function;
    llvm::LLVMContext *context;
    llvm::IRBuilder<true, llvm::ConstantFolder, llvm::IRBuilderDefaultInserter<true> > *builder;
    llvm::Value *value;
    //@}

    /** Initialize the CodeGen internal state to compile a fresh
     * module. This allows reuse of one CodeGen object to compiled
     * multiple related modules (e.g. multiple device kernels). */
    void init_module();

    /** Run all of llvm's optimization passes on the module. */
    void optimize_module();

    /** Add an entry to the symbol table, hiding previous entries with
     * the same name. Call this when new values come into scope. */
    void sym_push(const std::string &name, llvm::Value *value);

    /** Remove an entry for the symbol table, revealing any previous
     * entries with the same name. Call this when values go out of
     * scope. */
    void sym_pop(const std::string &name);

    /** Fetch an entry from the symbol table. If the symbol is not
     * found, it either errors out (if the second arg is true), or
     * returns NULL. */
    llvm::Value* sym_get(const std::string &name, bool must_succeed = true);

    /** Test if an item exists in the symbol table. */
    bool sym_exists(const std::string &name);

    /** Some useful llvm types */
    // @{
    llvm::Type *void_t, *i1, *i8, *i16, *i32, *i64, *f16, *f32, *f64;
    llvm::StructType *buffer_t;
    // @}

    /** The name of the function being generated. */
    std::string function_name;

    /** Emit code that evaluates an expression, and return the llvm
     * representation of the result of the expression. */
    llvm::Value *codegen(Expr);

    /** Emit code that runs a statement. */
    void codegen(Stmt);

    /** Take an llvm Value representing a pointer to a buffer_t,
     * and populate the symbol table with its constituent parts.
     */
    void unpack_buffer(std::string name, llvm::Value *buffer);

    /** Add a definition of buffer_t to the module if it isn't already there. */
    void define_buffer_t();

    /** Codegen an assertion. If false, it bails out and calls the error handler. */
    void create_assertion(llvm::Value *condition, const std::string &message);

    /** Put a string constant in the module as a global variable and return a pointer to it. */
    llvm::Value *create_string_constant(const std::string &str);

    /** Widen an llvm scalar into an llvm vector with the given number of lanes. */
    llvm::Value *create_broadcast(llvm::Value *, int width);

    /** Given an llvm value representing a pointer to a buffer_t, extract various subfields.
     * The *_ptr variants return a pointer to the struct element, while the basic variants
     * load the actual value. */
    // @{
    llvm::Value *buffer_host(llvm::Value *);
    llvm::Value *buffer_dev(llvm::Value *);
    llvm::Value *buffer_host_dirty(llvm::Value *);
    llvm::Value *buffer_dev_dirty(llvm::Value *);
    llvm::Value *buffer_min(llvm::Value *, int);
    llvm::Value *buffer_extent(llvm::Value *, int);
    llvm::Value *buffer_stride(llvm::Value *, int);
    llvm::Value *buffer_elem_size(llvm::Value *);
    llvm::Value *buffer_host_ptr(llvm::Value *);
    llvm::Value *buffer_dev_ptr(llvm::Value *);
    llvm::Value *buffer_host_dirty_ptr(llvm::Value *);
    llvm::Value *buffer_dev_dirty_ptr(llvm::Value *);
    llvm::Value *buffer_min_ptr(llvm::Value *, int);
    llvm::Value *buffer_extent_ptr(llvm::Value *, int);
    llvm::Value *buffer_stride_ptr(llvm::Value *, int);
    llvm::Value *buffer_elem_size_ptr(llvm::Value *);
    // @}

    /** Generate a pointer into a named buffer at a given index, of a
     * given type. The index counts according to the scalar type of
     * the type passed in. */
    // @{
    llvm::Value *codegen_buffer_pointer(std::string buffer, Type type, llvm::Value *index);
    llvm::Value *codegen_buffer_pointer(std::string buffer, Type type, Expr index);
    // @}

    /** Mark a load or store with type-based-alias-analysis metadata
     * so that llvm knows it can reorder loads and stores across
     * different buffers */
    void add_tbaa_metadata(llvm::Instruction *inst, std::string buffer);

    using IRVisitor::visit;

    /** Generate code for various IR nodes. These can be overridden by
     * architecture-specific code to perform peephole
     * optimizations. The result of each is stored in \ref value */
    // @{
    virtual void visit(const IntImm *);
    virtual void visit(const FloatImm *);
    virtual void visit(const StringImm *);
    virtual void visit(const Cast *);
    virtual void visit(const Variable *);
    virtual void visit(const Add *);
    virtual void visit(const Sub *);
    virtual void visit(const Mul *);
    virtual void visit(const Div *);
    virtual void visit(const Mod *);
    virtual void visit(const Min *);
    virtual void visit(const Max *);
    virtual void visit(const EQ *);
    virtual void visit(const NE *);
    virtual void visit(const LT *);
    virtual void visit(const LE *);
    virtual void visit(const GT *);
    virtual void visit(const GE *);
    virtual void visit(const And *);
    virtual void visit(const Or *);
    virtual void visit(const Not *);
    virtual void visit(const Select *);
    virtual void visit(const Load *);
    virtual void visit(const Ramp *);
    virtual void visit(const Broadcast *);
    virtual void visit(const Call *);
    virtual void visit(const Let *);
    virtual void visit(const LetStmt *);
    virtual void visit(const AssertStmt *);
    virtual void visit(const Pipeline *);
    virtual void visit(const For *);
    virtual void visit(const Store *);
    virtual void visit(const Block *);
    virtual void visit(const IfThenElse *);
    virtual void visit(const Evaluate *);
    // @}

    /** Recursive code for generating a gather using a binary tree. */
    llvm::Value *codegen_gather(llvm::Value *indices, const Load *op);

    /** Generate code for an allocate node. It has no default
     * implementation - it must be handled in an architecture-specific
     * way. */
    virtual void visit(const Allocate *) = 0;

    /** Generate code for a free node. It has no default
     * implementation and must be handled in an architecture-specific
     * way. */
    virtual void visit(const Free *) = 0;

    /** Some backends may wish to track entire buffer_t's for each
     * allocation instead of just a host pointer. Those backends
     * should override this method to return true, and when allocating
     * should also place a pointer to the buffer_t in the symbol table
     * under 'allocation_name.buffer'. */
    virtual bool track_buffers() {return false;}

    /** These IR nodes should have been removed during
     * lowering. CodeGen will error out if they are present */
    // @{
    virtual void visit(const Provide *);
    virtual void visit(const Realize *);
    // @}

    /** If we have to bail out of a pipeline midway, this should
     * inject the appropriate target-specific cleanup code. */
    virtual void prepare_for_early_exit() {}

    /** Get the llvm type equivalent to the given halide type in the
     * current context. */
    llvm::Type *llvm_type_of(Type);

    /** Restores the stack pointer to the given value. Call this to
     * free a stack variable. */
    void restore_stack(llvm::Value *saved_stack);

    /** Save the stack directly. You only need to call this if you're
     * doing your own allocas. */
    llvm::Value *save_stack();

    /** If you're doing an Alloca but can't clean it up right now, set
     * this to high and it will get cleaned up at the close of the
     * next For loop. */
    bool need_stack_restore;

    /** Which buffers came in from the outside world (and so we can't
     * guarantee their alignment) */
    std::set<std::string> might_be_misaligned;


private:

    /** All the values in scope at the current code location during
     * codegen. Use sym_push and sym_pop to access. */
    Scope<llvm::Value *> symbol_table;

    /** Alignment info for Int(32) variables in scope. */
    Scope<ModulusRemainder> alignment_info;

    /** String constants already emitted to the module. Tracked to
     * prevent emitting the same string many times. */
    std::map<std::string, llvm::Value *> string_constants;
};

}}

#endif
#ifndef HALIDE_CODEGEN_X86_H
#define HALIDE_CODEGEN_X86_H

/** \file
 * Defines the code-generator for producing x86 machine code
 */

#ifndef HALIDE_CODEGEN_POSIX_H
#define HALIDE_CODEGEN_POSIX_H

/** \file
 * Defines a base-class for code-generators on posixy cpu platforms
 */


namespace Halide {
namespace Internal {

/** A code generator that emits posix code from a given Halide stmt. */
class CodeGen_Posix : public CodeGen {
public:

    /** Create an posix code generator. Processor features can be
     * enabled using the appropriate arguments */
    CodeGen_Posix();

protected:

    /** Some useful llvm types for subclasses */
    // @{
    llvm::Type *i8x8, *i8x16, *i8x32;
    llvm::Type *i16x4, *i16x8, *i16x16;
    llvm::Type *i32x2, *i32x4, *i32x8;
    llvm::Type *i64x2, *i64x4;
    llvm::Type *f32x2, *f32x4, *f32x8;
    llvm::Type *f64x2, *f64x4;
    // @}

    /** Some wildcard variables used for peephole optimizations in
     * subclasses */
    // @{
    Expr wild_i8x8, wild_i16x4, wild_i32x2; // 64-bit signed ints
    Expr wild_u8x8, wild_u16x4, wild_u32x2; // 64-bit unsigned ints
    Expr wild_i8x16, wild_i16x8, wild_i32x4, wild_i64x2; // 128-bit signed ints
    Expr wild_u8x16, wild_u16x8, wild_u32x4, wild_u64x2; // 128-bit unsigned ints
    Expr wild_i8x32, wild_i16x16, wild_i32x8, wild_i64x4; // 256-bit signed ints
    Expr wild_u8x32, wild_u16x16, wild_u32x8, wild_u64x4; // 256-bit unsigned ints
    Expr wild_f32x2; // 64-bit floats
    Expr wild_f32x4, wild_f64x2; // 128-bit floats
    Expr wild_f32x8, wild_f64x4; // 256-bit floats
    Expr min_i8, max_i8, max_u8;
    Expr min_i16, max_i16, max_u16;
    Expr min_i32, max_i32, max_u32;
    Expr min_i64, max_i64, max_u64;
    Expr min_f32, max_f32, min_f64, max_f64;
    // @}

    using CodeGen::visit;

    /** Posix implementation of Allocate. Small constant-sized allocations go
     * on the stack. The rest go on the heap by calling "halide_malloc"
     * and "halide_free" in the standard library. */
    // @{
    void visit(const Allocate *);
    void visit(const Free *);
    // @}

    /** A struct describing heap or stack allocations. */
    struct Allocation {
        llvm::Value *ptr;

        /** How many bytes of stack space used. 0 implies it was a
         * heap allocation. */
        int stack_size;

        /** The stack pointer before the allocation was created. NULL
         * for heap allocations. */
        llvm::Value *saved_stack;
    };

    /** The allocations currently in scope. The stack gets pushed when
     * we enter a new function. */
    Scope<Allocation> allocations;

    /** Allocates some memory on either the stack or the heap, and
     * returns an Allocation object describing it. For heap
     * allocations this calls halide_malloc in the runtime, and for
     * stack allocations it either reuses an existing block from the
     * free_stack_blocks list, or it saves the stack pointer and calls
     * alloca.
     *
     * This call returns the allocation, pushes it onto the
     * 'allocations' map, and adds an entry to the symbol table called
     * name.host that provides the base pointer.
     *
     * When the allocation can be freed call 'free_allocation', and
     * when it goes out of scope call 'destroy_allocation'. */
    Allocation create_allocation(const std::string &name, Type type, Expr size);

    /** Free the memory backing an allocation and pop it from the
     * symbol table and the allocations map. For heap allocations it
     * calls halide_free in the runtime, for stack allocations it
     * marks the block as free so it can be reused. */
    void free_allocation(const std::string &name);

    /** Call this when an allocation goes out of scope. Does nothing
     * for heap allocations. For stack allocations, it restores the
     * stack removes the entry from the free_stack_blocks list. */
    void destroy_allocation(Allocation alloc);

    /** Free all heap allocations in scope. */
    void prepare_for_early_exit();

    /** Initialize the CodeGen internal state to compile a fresh module */
    void init_module();

};

}}

#endif
#ifndef HALIDE_TARGET_H
#define HALIDE_TARGET_H

#include <stdint.h>

namespace llvm {
class Module;
class LLVMContext;
}

namespace Halide {

struct Target {
    enum OS {OSUnknown = 0, Linux, Windows, OSX, Android, IOS, NaCl} os;
    enum Arch {ArchUnknown = 0, X86, ARM} arch;
    int bits; // Must be 0 for unknown, or 32 or 64
    enum Features {JIT = 1, SSE41 = 2, AVX = 4, AVX2 = 8, CUDA = 16, OpenCL = 32, GPUDebug = 64};
    uint64_t features;

    Target() : os(OSUnknown), arch(ArchUnknown), bits(0), features(0) {}
    Target(OS o, Arch a, int b, uint64_t f) : os(o), arch(a), bits(b), features(f) {}
};

/** Return the target corresponding to the host machine. */
EXPORT Target get_host_target();

/** Return the target that Halide will use. If HL_TARGET is set it
 * uses that. Otherwise calls \ref get_native_target */
EXPORT Target get_target_from_environment();

/** Create an llvm module containing the support code for a given target. */
llvm::Module *get_initial_module_for_target(Target, llvm::LLVMContext *);

}


#endif

namespace Halide {
namespace Internal {

/** A code generator that emits x86 code from a given Halide stmt. */
class CodeGen_X86 : public CodeGen_Posix {
public:
    /** Create an x86 code generator. Processor features can be
     * enabled using the appropriate flags in the target struct. */
    CodeGen_X86(Target);

    /** Compile to an internally-held llvm module. Takes a halide
     * statement, the name of the function produced, and the arguments
     * to the function produced. After calling this, call
     * CodeGen::compile_to_file or
     * CodeGen::compile_to_function_pointer to get at the x86 machine
     * code. */
    void compile(Stmt stmt, std::string name, const std::vector<Argument> &args);

    static void test();

protected:
    Target target;

    /** Generate a call to an sse or avx intrinsic */
    // @{
    llvm::Value *call_intrin(Type t, const std::string &name, std::vector<Expr>);
    llvm::Value *call_intrin(llvm::Type *t, const std::string &name, std::vector<llvm::Value *>);
    // @}

    using CodeGen_Posix::visit;

    /** Nodes for which we want to emit specific sse/avx intrinsics */
    // @{
    void visit(const Cast *);
    void visit(const Div *);
    void visit(const Min *);
    void visit(const Max *);
    // @}

    /** Functions for clamped vector load */
    void visit(const Load *);

    std::string mcpu() const;
    std::string mattrs() const;
    bool use_soft_float_abi() const;
};

}}

#endif
#ifndef HALIDE_CODEGEN_GPU_HOST_H
#define HALIDE_CODEGEN_GPU_HOST_H

/** \file
 * Defines the code-generator for producing GPU host code
 */

#ifndef HALIDE_CODEGEN_GPU_DEV_H
#define HALIDE_CODEGEN_GPU_DEV_H

/** \file
 * Defines the code-generator interface for producing GPU device code
 */

#ifndef HALIDE_FUNC_H
#define HALIDE_FUNC_H

/** \file
 *
 * Defines Func - the front-end handle on a halide function, and related classes.
 */

#ifndef HALIDE_VAR_H
#define HALIDE_VAR_H

/** \file
 * Defines the Var - the front-end variable 
 */

#include <string>
#include <sstream>

namespace Halide {

/** A Halide variable, to be used when defining functions. It is just
 * a name, and can be reused in places where no name conflict will
 * occur. It can be used in the left-hand-side of a function
 * definition, or as an Expr. As an Expr, it always has type
 * Int(32). */
class Var {
    std::string _name;
public:
    /** Construct a Var with the given name */
    Var(const std::string &n) : _name(n) {}

    /** Construct a Var with an automatically-generated unique name */
    Var() : _name(Internal::unique_name('v')) {}

    /** Get the name of a Var */
    const std::string &name() const {return _name;}

    /** Test if two Vars are the same. This simply compares the names. */
    bool same_as(const Var &other) {return _name == other._name;}

    /** Implicit var constructor. Implicit variables are injected
     * automatically into a function call if the number of arguments
     * to the function are fewer than its dimensionality and a
     * placeholder ("_") appears in its argument list. Defining a
     * function to equal an expression containing implicit variables
     * similarly appends those implicit variables, in the same order,
     * to the left-hand-side of the definition where the placeholder
     * ('_') appears. A Func without any argument list can be used as
     * an Expr and all arguments will be implicit.
     * 
     * For example, consider the definition:
     *
     \code
     Func f, g;
     Var x, y;
     f(x, y) = 3;
     \endcode
     * 
     * A call to f with fewer than two arguments and a placeholder
     * will have implicit arguments injected automatically, so f(2, _)
     * is equivalent to f(2, _0), where _0 = Var::implicit(0), and f(_)
     * (and indeed f when cast to an Expr) is equivalent to f(_0, _1).
     * The following definitions are all equivalent, differing only in the
     * variable names.
     * 
     \code
     g = f*3;
     g(_) = f(_)*3;
     g(x, _) = f(x, _)*3;
     g(x, y) = f(x, y)*3;
     \endcode
     *
     * These are expanded internally as follows:
     *
     \code
     g(_0, _1) = f(_0, _1)*3;
     g(_0, _1) = f(_0, _1)*3;
     g(x, _0) = f(x, _0)*3;
     g(x, y) = f(x, y)*3;
     \endcode
     *
     * The following, however, defines g as four dimensional:
     \code
     g(x, y, _) = f*3;
     \endcode
     *
     * It is equivalent to:
     *
     \code
     g(x, y, _0, _1) = f(_0, _1)*3;
     \endcode
     * 
     * Expressions requiring differing numbers of implicit variables
     * can be combined. The left-hand-side of a definition injects
     * enough implicit variables to cover all of them:
     *
     \code
     Func h;
     h(x) = x*3;
     g(x) = h + (f + f(x)) * f(x, y);
     \endcode
     * 
     * expands to:
     *
     \code
     Func h;
     h(x) = x*3;
     g(x, _0, _1) = h(_0) + (f(_0, _1) + f(x, _0)) * f(x, y);
     \endcode
     *
     * The first ten implicits, _0 through _9, are predeclared in this
     * header and can be used for scheduling. They should never be
     * used as arguments in a declaration or used in a call.
     * TODO: Think if there is a way to enforce this, or possibly
     * remove these and introduce a scheduling specific syntax for
     * naming them.
     *
     * While it is possible to use Var::implicit to create expressions
     * that can be treated as small anonymous functions, you should
     * not do this. Instead use \ref lambda.
     */
    static Var implicit(int n) {
        std::ostringstream str;
        str << "_" << n;
        return Var(str.str());
    }
   
    /** Return whether a variable name is of the form for an implicit argument.
     * TODO: This is almost guaranteed to incorrectly fire on user
     * declared variables at some point. We should likely prevent
     * user Var declarations from making names of this form.
     */
    static bool is_implicit(const std::string &name) {
        return Internal::starts_with(name, "_") &&
            name.find_first_not_of("0123456789", 1) == std::string::npos;
    }

    /** Return the argument index, i.e. slot number in a call, for an
     *  argument given its name. Returns -1 if the variable is not of
     *  implicit form.
     */
    static int implicit_index(const std::string &name) {
        return is_implicit(name) ? atoi(name.c_str() + 1) : -1;
    }

    static bool is_placeholder(const std::string &name) {
        return name == "_";
    }

    /** A Var can be treated as an Expr of type Int(32) */
    operator Expr() {
        return Internal::Variable::make(Int(32), name());
    }
};

/** This is used to provide a grace period during which old style
 * implicits code will continue to compile with a warning. This makes
 * it easier to convert to the new required placeholder ('_') style.
 * Both variants will work during the transition period. The code under
 * these #ifdef blocks can be completely removed after we finalize the
 * language change.
 */
#define HALIDE_WARNINGS_FOR_OLD_IMPLICITS 1

/** Placeholder for infered arguments.
 */
EXPORT extern Var _;

/** Predeclare the first ten implicit Vars so they can be used in scheduling.
 */
EXPORT extern Var _0, _1, _2, _3, _4, _5, _6, _7, _8, _9;

}

#endif
#ifndef HALIDE_PARAM_H
#define HALIDE_PARAM_H

/** \file
 *
 * Classes for declaring scalar and image parameters to halide pipelines
 */

#include <sstream>
#include <vector>

namespace Halide {

/** A scalar parameter to a halide pipeline. If you're jitting, this
 * should be bound to an actual value of type T using the set method
 * before you realize the function uses this. If you're statically
 * compiling, this param should appear in the argument list. */
template<typename T>
class Param {
    /** A reference-counted handle on the internal parameter object */
    Internal::Parameter param;

public:
    /** Construct a scalar parameter of type T with a unique
     * auto-generated name */
    Param() : param(type_of<T>(), false) {}

    /** Construct a scalar parameter of type T with the given name */
    Param(const std::string &n) : param(type_of<T>(), false, n) {}

    /** Get the name of this parameter */
    const std::string &name() const {
        return param.name();
    }

    /** Get the current value of this parameter. Only meaningful when jitting. */
    T get() const {
        return param.get_scalar<T>();
    }

    /** Set the current value of this parameter. Only meaningful when jitting */
    void set(T val) {
        param.set_scalar<T>(val);
    }

    /** Get the halide type of T */
    Type type() const {
        return type_of<T>();
    }

    /** Get or set the possible range of this parameter. Use undefined
     * Exprs to mean unbounded. */
    // @{
    void set_range(Expr min, Expr max) {
        set_min_value(min);
        set_max_value(max);
    }

    void set_min_value(Expr min) {
        if (min.type() != type_of<T>()) {
            min = Internal::Cast::make(type_of<T>(), min);
        }
        param.set_min_value(min);
    }

    void set_max_value(Expr max) {
        if (max.type() != type_of<T>()) {
            max = Internal::Cast::make(type_of<T>(), max);
        }
        param.set_max_value(max);
    }

    Expr get_min_value() {
        return param.get_min_value();
    }

    Expr get_max_value() {
        return param.get_max_value();
    }
    // @}

    /** You can use this parameter as an expression in a halide
     * function definition */
    operator Expr() const {
        return Internal::Variable::make(type_of<T>(), name(), param);
    }

    /** Using a param as the argument to an external stage treats it
     * as an Expr */
    operator ExternFuncArgument() const {
        return Expr(*this);
    }

    /** Construct the appropriate argument matching this parameter,
     * for the purpose of generating the right type signature when
     * statically compiling halide pipelines. */
    operator Argument() const {
        return Argument(name(), false, type());
    }
};


/** A handle on the output buffer of a pipeline. Used to make static
 * promises about the output size and stride. */
class OutputImageParam {
protected:
    /** A reference-counted handle on the internal parameter object */
    Internal::Parameter param;

    /** The dimensionality of this image. */
    int dims;

    bool add_implicit_args_if_placeholder(std::vector<Expr> &args,
                                          Expr last_arg,
                                          int total_args,
                                          bool placeholder_seen) const {
        const Internal::Variable *var = last_arg.as<Internal::Variable>();
        bool is_placeholder = var != NULL && Var::is_placeholder(var->name);
        if (is_placeholder) {
            assert(!placeholder_seen && "Only one implicit placeholder ('_') allowed in argument list for ImageParam.");
            placeholder_seen = true;

            // The + 1 in the conditional is because one provided argument is an placeholder
            for (int i = 0; i < (dims - total_args + 1); i++) {
                args.push_back(Var::implicit(i));
            }
        } else {
            args.push_back(last_arg);
        }

#if HALIDE_WARNINGS_FOR_OLD_IMPLICITS
        if (!is_placeholder && !placeholder_seen &&
            (int)args.size() == total_args &&
            (int)args.size() < dims) {
            std::cout << "Implicit arguments without placeholders ('_') are deprecated."
                      << " Adding " << dims - args.size()
                      << " arguments to ImageParam " << name() << '\n';
            int i = 0;
            while ((int)args.size() < dims) {
                args.push_back(Var::implicit(i++));

            }
        }
#endif
        return is_placeholder;
    }

public:

    /** Construct a NULL image parameter handle. */
    OutputImageParam() :
        dims(0) {}

    /** Construct an OutputImageParam that wraps an Internal Parameter object. */
    OutputImageParam(const Internal::Parameter &p, int d) :
        param(p), dims(d) {}

    /** Get the name of this Param */
    const std::string &name() const {
        return param.name();
    }

    /** Get the type of the image data this Param refers to */
    Type type() const {
        return param.type();
    }

    /** Is this parameter handle non-NULL */
    bool defined() {
        return param.defined();
    }

    /** Get an expression representing the extent of this image
     * parameter in the given dimension */
    Expr extent(int x) const {
        std::ostringstream s;
        s << name() << ".extent." << x;
        return Internal::Variable::make(Int(32), s.str(), param);
    }

    /** Get an expression representing the stride of this image in the
     * given dimension */
    Expr stride(int x) const {
        std::ostringstream s;
        s << name() << ".stride." << x;
        return Internal::Variable::make(Int(32), s.str(), param);
    }

    /** Set the extent in a given dimension to equal the given
     * expression. Images passed in that fail this check will generate
     * a runtime error. Returns a reference to the ImageParam so that
     * these calls may be chained.
     *
     * This may help the compiler generate better
     * code. E.g:
     \code
     im.set_extent(0, 100);
     \endcode
     * tells the compiler that dimension zero must be of extent 100,
     * which may result in simplification of boundary checks. The
     * value can be an arbitrary expression:
     \code
     im.set_extent(0, im.extent(1));
     \endcode
     * declares that im is a square image (of unknown size), whereas:
     \code
     im.set_extent(0, (im.extent(0)/32)*32);
     \endcode
     * tells the compiler that the extent is a multiple of 32. */
    OutputImageParam &set_extent(int dim, Expr extent) {
        param.set_extent_constraint(dim, extent);
        return *this;
    }

    /** Set the min in a given dimension to equal the given
     * expression. Setting the mins to zero may simplify some
     * addressing math. */
    OutputImageParam &set_min(int dim, Expr min) {
        param.set_min_constraint(dim, min);
        return *this;
    }

    /** Set the stride in a given dimension to equal the given
     * value. This is particularly helpful to set when
     * vectorizing. Known strides for the vectorized dimension
     * generate better code. */
    OutputImageParam &set_stride(int dim, Expr stride) {
        param.set_stride_constraint(dim, stride);
        return *this;
    }

    /** Set the min and extent in one call. */
    OutputImageParam &set_bounds(int dim, Expr min, Expr extent) {
        return set_min(dim, min).set_extent(dim, extent);
    }

    /** Get the dimensionality of this image parameter */
    int dimensions() const {
        return dims;
    };

    /** Get an expression giving the extent in dimension 0, which by
     * convention is the width of the image */
    Expr width() const {
        assert(dims >= 0);
        return extent(0);
    }

    /** Get an expression giving the extent in dimension 1, which by
     * convention is the height of the image */
    Expr height() const {
        assert(dims >= 1);
        return extent(1);
    }

    /** Get an expression giving the extent in dimension 2, which by
     * convention is the channel-count of the image */
    Expr channels() const {
        assert(dims >= 2);
        return extent(2);
    }

    /** Get at the internal parameter object representing this ImageParam. */
    Internal::Parameter parameter() const {
        return param;
    }

    /** Construct the appropriate argument matching this parameter,
     * for the purpose of generating the right type signature when
     * statically compiling halide pipelines. */
    operator Argument() const {
        return Argument(name(), true, type());
    }

};

/** An Image parameter to a halide pipeline. E.g., the input image. */
class ImageParam : public OutputImageParam {

public:

    /** Construct a NULL image parameter handle. */
    ImageParam() : OutputImageParam() {}

    /** Construct an image parameter of the given type and
     * dimensionality, with an auto-generated unique name. */
    ImageParam(Type t, int d) :
        OutputImageParam(Internal::Parameter(t, true), d) {}

    /** Construct an image parameter of the given type and
     * dimensionality, with the given name */
    ImageParam(Type t, int d, const std::string &n) :
        OutputImageParam(Internal::Parameter(t, true, n), d) {}

    /** Bind a buffer or image to this ImageParam. Only relevant for jitting */
    void set(Buffer b) {
        if (b.defined()) assert(b.type() == type() && "Setting buffer of incorrect type");
        param.set_buffer(b);
    }

    /** Get the buffer bound to this ImageParam. Only relevant for jitting */
    Buffer get() const {
        return param.get_buffer();
    }

    /** Construct an expression which loads from this image
     * parameter. The location is extended with enough implicit
     * variables to match the dimensionality of the image
     * (see \ref Var::implicit)
     */
    // @{
    Expr operator()() const {
        assert(dimensions() == 0);
        std::vector<Expr> args;
        return Internal::Call::make(param, args);
    }

    /** Force the args to a call to an image to be int32. */
    static void check_arg_types(const std::string &name, std::vector<Expr> *args) {
        for (size_t i = 0; i < args->size(); i++) {
            Type t = (*args)[i].type();
            if (t.is_float() || (t.is_uint() && t.bits >= 32) || (t.is_int() && t.bits > 32)) {
                std::cerr << "Error: implicit cast from " << t << " to int in argument " << (i+1)
                          << " in call to " << name << " is not allowed. Use an explicit cast.\n";
                assert(false);
            }
            // We're allowed to implicitly cast from other varieties of int
            if (t != Int(32)) {
                (*args)[i] = Internal::Cast::make(Int(32), (*args)[i]);
            }
        }
    }

    Expr operator()(Expr x) const {
        std::vector<Expr> args;
        bool placeholder_seen = false;
        placeholder_seen |= add_implicit_args_if_placeholder(args, x, 1, placeholder_seen);

        assert(args.size() == (size_t)dims);

        check_arg_types(name(), &args);
        return Internal::Call::make(param, args);
    }

    Expr operator()(Expr x, Expr y) const {
        std::vector<Expr> args;
        bool placeholder_seen = false;
        placeholder_seen |= add_implicit_args_if_placeholder(args, x, 2, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, y, 2, placeholder_seen);

        assert(args.size() == (size_t)dims);

        check_arg_types(name(), &args);
        return Internal::Call::make(param, args);
    }

    Expr operator()(Expr x, Expr y, Expr z) const {
        std::vector<Expr> args;
        bool placeholder_seen = false;
        placeholder_seen |= add_implicit_args_if_placeholder(args, x, 3, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, y, 3, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, z, 3, placeholder_seen);

        assert(args.size() == (size_t)dims);

        check_arg_types(name(), &args);
        return Internal::Call::make(param, args);
    }

    Expr operator()(Expr x, Expr y, Expr z, Expr w) const {
        std::vector<Expr> args;
        bool placeholder_seen = false;
        placeholder_seen |= add_implicit_args_if_placeholder(args, x, 4, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, y, 4, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, z, 4, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, w, 4, placeholder_seen);

        assert(args.size() == (size_t)dims);

        check_arg_types(name(), &args);
        return Internal::Call::make(param, args);
    }
    // @}

    /** Treating the image parameter as an Expr is equivalent to call
     * it with no arguments. For example, you can say:
     *
     \code
     ImageParam im(UInt(8), 2);
     Func f;
     f = im*2;
     \endcode
     *
     * This will define f as a two-dimensional function with value at
     * position (x, y) equal to twice the value of the image parameter
     * at the same location.
     */
    operator Expr() const {
        return (*this)(_);
    }
};


}

#endif
#ifndef HALIDE_RDOM_H
#define HALIDE_RDOM_H

/** \file
 * Defines the front-end syntax for reduction domains and reduction
 * variables.
 */


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
#ifndef HALIDE_IMAGE_H
#define HALIDE_IMAGE_H

/** \file
 * Defines Halide's Image data type
 */

#ifndef HALIDE_TUPLE_H
#define HALIDE_TUPLE_H

/** \file
 *
 * Defines Tuple - the front-end handle on small arrays of expressions.
 */

#ifndef HALIDE_IR_OPERATOR_H
#define HALIDE_IR_OPERATOR_H

/** \file
 *
 * Defines various operator overloads and utility functions that make
 * it more pleasant to work with Halide expressions.
 */


namespace Halide {

namespace Internal {
/** Is the expression either an IntImm, a FloatImm, or a Cast of the
 * same, or a Ramp or Broadcast of the same. Doesn't do any constant
 * folding. */
EXPORT bool is_const(Expr e);

/** Is the expression an IntImm, FloatImm of a particular value, or a
 * Cast, or Broadcast of the same. */
EXPORT bool is_const(Expr e, int v);

/** If an expression is an IntImm, return a pointer to its
 * value. Otherwise returns NULL. */
EXPORT const int *as_const_int(Expr e);

/** If an expression is a FloatImm, return a pointer to its
 * value. Otherwise returns NULL. */
EXPORT const float *as_const_float(Expr e);

/** Is the expression a constant integer power of two. Also returns
 * log base two of the expression if it is. */
EXPORT bool is_const_power_of_two(Expr e, int *bits);

/** Is the expression a const (as defined by is_const), and also
 * strictly greater than zero (in all lanes, if a vector expression) */
EXPORT bool is_positive_const(Expr e);

/** Is the expression a const (as defined by is_const), and also
 * strictly less than zero (in all lanes, if a vector expression) */
EXPORT bool is_negative_const(Expr e);

/** Is the expression a const (as defined by is_const), and also equal
 * to zero (in all lanes, if a vector expression) */
EXPORT bool is_zero(Expr e);

/** Is the expression a const (as defined by is_const), and also equal
 * to one (in all lanes, if a vector expression) */
EXPORT bool is_one(Expr e);

/** Is the expression a const (as defined by is_const), and also equal
 * to two (in all lanes, if a vector expression) */
EXPORT bool is_two(Expr e);

/** Given an integer value, cast it into a designated integer type
 * and return the bits as int. Unsigned types are returned as bits in the int
 * and should be cast to unsigned int for comparison.
 * int_cast_constant implements bit manipulations to wrap val into the
 * value range of the Type t.
 * For example, int_cast_constant(UInt(16), -1) returns 65535
 * int_cast_constant(Int(8), 128) returns -128
 */
EXPORT int int_cast_constant(Type t, int val);

/** Construct a const of the given type */
EXPORT Expr make_const(Type t, int val);

/** Construct a boolean constant from a C++ boolean value.
 * May also be a vector if width is given.
 * It is not possible to coerce a C++ boolean to Expr because
 * if we provide such a path then char objects can ambiguously
 * be converted to Halide Expr or to std::string.  The problem
 * is that C++ does not have a real bool type - it is in fact
 * close enough to char that C++ does not know how to distinguish them.
 * make_bool is the explicit coercion. */
EXPORT Expr make_bool(bool val, int width = 1);

/** Construct the representation of zero in the given type */
EXPORT Expr make_zero(Type t);

/** Construct the representation of one in the given type */
EXPORT Expr make_one(Type t);

/** Construct the representation of two in the given type */
EXPORT Expr make_two(Type t);

/** Construct the constant boolean true. May also be a vector of
 * trues, if a width argument is given. */
EXPORT Expr const_true(int width = 1);

/** Construct the constant boolean false. May also be a vector of
 * falses, if a width argument is given. */
EXPORT Expr const_false(int width = 1);

/** Coerce the two expressions to have the same type, using C-style
 * casting rules. For the purposes of casting, a boolean type is
 * UInt(1). We use the following procedure:
 *
 * If the types already match, do nothing.
 *
 * Then, if one type is a vector and the other is a scalar, the scalar
 * is broadcast to match the vector width, and we continue.
 *
 * Then, if one type is floating-point and the other is not, the
 * non-float is cast to the floating-point type, and we're done.
 *
 * Then, if neither is a float but one of the two is a constant, the
 * constant is cast to match the non-const type and we're done. For
 * example, e has type UInt(8), then (e*32) also has type UInt(8),
 * despite the overflow that may occur. Note that this also means that
 * (e*(-1)) is positive, and is equivalent to (e*255) - i.e. the (-1)
 * is cast to a UInt(8) before the multiplication.
 *
 * Then, if both types are unsigned ints, the one with fewer bits is
 * cast to match the one with more bits and we're done.
 *
 * Then, if both types are signed ints, the one with fewer bits is
 * cast to match the one with more bits and we're done.
 *
 * Finally, if one type is an unsigned int and the other type is a signed
 * int, both are cast to a signed int with the greater of the two
 * bit-widths. For example, matching an Int(8) with a UInt(16) results
 * in an Int(16).
 *
 */
EXPORT void match_types(Expr &a, Expr &b);

/** Halide's vectorizable transcendentals. */
// @{
EXPORT Expr halide_log(Expr a);
EXPORT Expr halide_exp(Expr a);
// @}

/** Raise an expression to an integer power by repeatedly multiplying
 * it by itself. */
EXPORT Expr raise_to_integer_power(Expr a, int b);


}

/** Cast an expression to the halide type corresponding to the C++ type T. */
template<typename T>
inline Expr cast(Expr a) {
    return cast(type_of<T>(), a);
}

/** Cast an expression to a new type. */
inline Expr cast(Type t, Expr a) {
    assert(a.defined() && "cast of undefined");
    if (a.type() == t) return a;
    if (t.is_vector()) {
        if (a.type().is_scalar()) {
            return Internal::Broadcast::make(cast(t.element_of(), a), t.width);
        } else if (const Internal::Broadcast *b = a.as<Internal::Broadcast>()) {
            assert(b->width == t.width);
            return Internal::Broadcast::make(cast(t.element_of(), b->value), t.width);
        }
    }
    return Internal::Cast::make(t, a);
}

/** Return the sum of two expressions, doing any necessary type
 * coercion using \ref Internal::match_types */
inline Expr operator+(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator+ of undefined");
    Internal::match_types(a, b);
    return Internal::Add::make(a, b);
}

/** Modify the first expression to be the sum of two expressions,
 * without changing its type. This casts the second argument to match
 * the type of the first. */
inline Expr &operator+=(Expr &a, Expr b) {
    assert(a.defined() && b.defined() && "operator+= of undefined");
    a = Internal::Add::make(a, cast(a.type(), b));
    return a;
}

/** Return the difference of two expressions, doing any necessary type
 * coercion using \ref Internal::match_types */
inline Expr operator-(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator- of undefined");
    Internal::match_types(a, b);
    return Internal::Sub::make(a, b);
}

/** Return the negative of the argument. Does no type casting, so more
 * formally: return that number which when added to the original,
 * yields zero of the same type. For unsigned integers the negative is
 * still an unsigned integer. E.g. in UInt(8), the negative of 56 is
 * 200, because 56 + 200 == 0 */
inline Expr operator-(Expr a) {
    assert(a.defined() && "operator- of undefined");
    return Internal::Sub::make(Internal::make_zero(a.type()), a);
}

/** Modify the first expression to be the difference of two expressions,
 * without changing its type. This casts the second argument to match
 * the type of the first. */
inline Expr &operator-=(Expr &a, Expr b) {
    assert(a.defined() && b.defined() && "operator-= of undefined");
    a = Internal::Sub::make(a, cast(a.type(), b));
    return a;
}

/** Return the product of two expressions, doing any necessary type
 * coercion using \ref Internal::match_types */
inline Expr operator*(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator* of undefined");
    Internal::match_types(a, b);
    return Internal::Mul::make(a, b);
}

/** Modify the first expression to be the product of two expressions,
 * without changing its type. This casts the second argument to match
 * the type of the first. */
inline Expr &operator*=(Expr &a, Expr b) {
    assert(a.defined() && b.defined() && "operator*= of undefined");
    a = Internal::Mul::make(a, cast(a.type(), b));
    return a;
}

/** Return the ratio of two expressions, doing any necessary type
 * coercion using \ref Internal::match_types */
inline Expr operator/(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator/ of undefined");
    assert(!Internal::is_const(b, 0) && "operator/ with constant 0 divisor.");
    Internal::match_types(a, b);
    return Internal::Div::make(a, b);
}

/** Modify the first expression to be the ratio of two expressions,
 * without changing its type. This casts the second argument to match
 * the type of the first. */
inline Expr &operator/=(Expr &a, Expr b) {
    assert(a.defined() && b.defined() && "operator/= of undefined");
    assert(!Internal::is_const(b, 0) && "operator/= with constant 0 divisor.");
    a = Internal::Div::make(a, cast(a.type(), b));
    return a;
}

/** Return the first argument reduced modulo the second, doing any
 * necessary type coercion using \ref Internal::match_types */
inline Expr operator%(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator% of undefined");
    assert(!Internal::is_const(b, 0) && "operator% with constant 0 divisor.");
    Internal::match_types(a, b);
    return Internal::Mod::make(a, b);
}

/** Return a boolean expression that tests whether the first argument
 * is greater than the second, after doing any necessary type coercion
 * using \ref Internal::match_types */
inline Expr operator>(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator> of undefined");
    Internal::match_types(a, b);
    return Internal::GT::make(a, b);
}

/** Return a boolean expression that tests whether the first argument
 * is less than the second, after doing any necessary type coercion
 * using \ref Internal::match_types */
inline Expr operator<(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator< of undefined");
    Internal::match_types(a, b);
    return Internal::LT::make(a, b);
}

/** Return a boolean expression that tests whether the first argument
 * is less than or equal to the second, after doing any necessary type
 * coercion using \ref Internal::match_types */
inline Expr operator<=(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator<= of undefined");
    Internal::match_types(a, b);
    return Internal::LE::make(a, b);
}

/** Return a boolean expression that tests whether the first argument
 * is greater than or equal to the second, after doing any necessary
 * type coercion using \ref Internal::match_types */

inline Expr operator>=(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator>= of undefined");
    Internal::match_types(a, b);
    return Internal::GE::make(a, b);
}

/** Return a boolean expression that tests whether the first argument
 * is equal to the second, after doing any necessary type coercion
 * using \ref Internal::match_types */
inline Expr operator==(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator== of undefined");
    Internal::match_types(a, b);
    return Internal::EQ::make(a, b);
}

/** Return a boolean expression that tests whether the first argument
 * is not equal to the second, after doing any necessary type coercion
 * using \ref Internal::match_types */
inline Expr operator!=(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "operator!= of undefined");
    Internal::match_types(a, b);
    return Internal::NE::make(a, b);
}

/** Returns the logical and of the two arguments */
inline Expr operator&&(Expr a, Expr b) {
    return Internal::And::make(a, b);
}

/** Returns the logical or of the two arguments */
inline Expr operator||(Expr a, Expr b) {
    return Internal::Or::make(a, b);
}

/** Returns the logical not the argument */
inline Expr operator!(Expr a) {
    return Internal::Not::make(a);
}

/** Returns an expression representing the greater of the two
 * arguments, after doing any necessary type coercion using
 * \ref Internal::match_types. Vectorizes cleanly on most platforms
 * (with the exception of integer types on x86 without SSE4). */
inline Expr max(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "max of undefined");
    Internal::match_types(a, b);
    return Internal::Max::make(a, b);
}

/** Returns an expression representing the lesser of the two
 * arguments, after doing any necessary type coercion using
 * \ref Internal::match_types. Vectorizes cleanly on most platforms
 * (with the exception of integer types on x86 without SSE4). */
inline Expr min(Expr a, Expr b) {
    assert(a.defined() && b.defined() && "min of undefined");
    Internal::match_types(a, b);
    return Internal::Min::make(a, b);
}

/** Clamps an expression to lie within the given bounds. The bounds
 * are type-cast to match the expression. Vectorizes as well as min/max. */
inline Expr clamp(Expr a, Expr min_val, Expr max_val) {
    assert(a.defined() && min_val.defined() && max_val.defined() &&
           "clamp of undefined");
    min_val = cast(a.type(), min_val);
    max_val = cast(a.type(), max_val);
    return Internal::Max::make(Internal::Min::make(a, max_val), min_val);
}

/** Returns the absolute value of a signed integer or floating-point
 * expression. Vectorizes cleanly. */
inline Expr abs(Expr a) {
    assert(a.defined() && "abs of undefined");
    if (a.type() == Int(8))
        return Internal::Call::make(Int(8), "abs_i8", vec(a), Internal::Call::Extern);
    if (a.type() == Int(16))
        return Internal::Call::make(Int(16), "abs_i16", vec(a), Internal::Call::Extern);
    if (a.type() == Int(32))
        return Internal::Call::make(Int(32), "abs_i32", vec(a), Internal::Call::Extern);
    if (a.type() == Int(64))
        return Internal::Call::make(Int(64), "abs_i64", vec(a), Internal::Call::Extern);
    if (a.type() == Float(32))
        return Internal::Call::make(Float(32), "abs_f32", vec(a), Internal::Call::Extern);
    if (a.type() == Float(64))
        return Internal::Call::make(Float(64), "abs_f64", vec(a), Internal::Call::Extern);
    assert(false && "Invalid type for abs");
    return 0; // prevent "control reaches end of non-void function" error
}

/** Returns an expression similar to the ternary operator in C, except
 * that it always evaluates all arguments. If the first argument is
 * true, then return the second, else return the third. Typically
 * vectorizes cleanly, but benefits from SSE41 or newer on x86. */
inline Expr select(Expr condition, Expr true_value, Expr false_value) {

    if (as_const_int(condition)) {
        // Why are you doing this? We'll preserve the select node until constant folding for you.
        condition = cast(Bool(), condition);
    }

    // Coerce int literals to the type of the other argument
    if (as_const_int(true_value)) {
        true_value = cast(false_value.type(), true_value);
    }
    if (as_const_int(false_value)) {
        false_value = cast(true_value.type(), false_value);
    }

    return Internal::Select::make(condition, true_value, false_value);
}

/** Return the sine of a floating-point expression. If the argument is
 * not floating-point, it is cast to Float(32). Does not vectorize
 * well. */
inline Expr sin(Expr x) {
    assert(x.defined() && "sin of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "sin_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "sin_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the arcsine of a floating-point expression. If the argument
 * is not floating-point, it is cast to Float(32). Does not vectorize
 * well. */
inline Expr asin(Expr x) {
    assert(x.defined() && "asin of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "asin_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "asin_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the cosine of a floating-point expression. If the argument
 * is not floating-point, it is cast to Float(32). Does not vectorize
 * well. */
inline Expr cos(Expr x) {
    assert(x.defined() && "cos of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "cos_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "cos_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the arccosine of a floating-point expression. If the
 * argument is not floating-point, it is cast to Float(32). Does not
 * vectorize well. */
inline Expr acos(Expr x) {
    assert(x.defined() && "acos of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "acos_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "acos_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the tangent of a floating-point expression. If the argument
 * is not floating-point, it is cast to Float(32). Does not vectorize
 * well. */
inline Expr tan(Expr x) {
    assert(x.defined() && "tan of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "tan_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "tan_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the arctangent of a floating-point expression. If the
 * argument is not floating-point, it is cast to Float(32). Does not
 * vectorize well. */
inline Expr atan(Expr x) {
    assert(x.defined() && "atan of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "atan_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "atan_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the angle of a floating-point gradient. If the argument is
 * not floating-point, it is cast to Float(32). Does not vectorize
 * well. */
inline Expr atan2(Expr y, Expr x) {
    assert(x.defined() && y.defined() && "atan2 of undefined");

    if (y.type() == Float(64)) {
        x = cast<double>(x);
        return Internal::Call::make(Float(64), "atan2_f64", vec(y, x), Internal::Call::Extern);
    } else {
        y = cast<float>(y);
        x = cast<float>(x);
        return Internal::Call::make(Float(32), "atan2_f32", vec(y, x), Internal::Call::Extern);
    }
}

/** Return the hyperbolic sine of a floating-point expression.  If the
 *  argument is not floating-point, it is cast to Float(32). Does not
 *  vectorize well. */
inline Expr sinh(Expr x) {
    assert(x.defined() && "sinh of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "sinh_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "sinh_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the hyperbolic arcsinhe of a floating-point expression.  If
 * the argument is not floating-point, it is cast to Float(32). Does
 * not vectorize well. */
inline Expr asinh(Expr x) {
    assert(x.defined() && "asinh of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "asinh_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "asinh_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the hyperbolic cosine of a floating-point expression.  If
 * the argument is not floating-point, it is cast to Float(32). Does
 * not vectorize well. */
inline Expr cosh(Expr x) {
    assert(x.defined() && "cosh of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "cosh_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "cosh_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the hyperbolic arccosine of a floating-point expression.
 * If the argument is not floating-point, it is cast to
 * Float(32). Does not vectorize well. */
inline Expr acosh(Expr x) {
    assert(x.defined() && "acosh of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "acosh_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "acosh_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the hyperbolic tangent of a floating-point expression.  If
 * the argument is not floating-point, it is cast to Float(32). Does
 * not vectorize well. */
inline Expr tanh(Expr x) {
    assert(x.defined() && "tanh of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "tanh_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "tanh_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the hyperbolic arctangent of a floating-point expression.
 * If the argument is not floating-point, it is cast to
 * Float(32). Does not vectorize well. */
inline Expr atanh(Expr x) {
    assert(x.defined() && "atanh of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "atanh_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "atanh_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the square root of a floating-point expression. If the
 * argument is not floating-point, it is cast to Float(32). Typically
 * vectorizes cleanly. */
inline Expr sqrt(Expr x) {
    assert(x.defined() && "sqrt of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "sqrt_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "sqrt_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the square root of the sum of the squares of two
 * floating-point expressions. If the argument is not floating-point,
 * it is cast to Float(32). Vectorizes cleanly. */
inline Expr hypot(Expr x, Expr y) {
    return sqrt(x*x + y*y);
}

/** Return the exponential of a floating-point expression. If the
 * argument is not floating-point, it is cast to Float(32). For
 * Float(64) arguments, this calls the system exp function, and does
 * not vectorize well. For Float(32) arguments, this function is
 * vectorizable, does the right thing for extremely small or extremely
 * large inputs, and is accurate up to the last bit of the
 * mantissa. Vectorizes cleanly. */
inline Expr exp(Expr x) {
    assert(x.defined() && "exp of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "exp_f64", vec(x), Internal::Call::Extern);
    } else {
        // return Internal::Call::make(Float(32), "exp_f32", vec(cast<float>(x)), Internal::Call::Extern);
        return Internal::halide_exp(cast<float>(x));
    }
}

/** Return the logarithm of a floating-point expression. If the
 * argument is not floating-point, it is cast to Float(32). For
 * Float(64) arguments, this calls the system log function, and does
 * not vectorize well. For Float(32) arguments, this function is
 * vectorizable, does the right thing for inputs <= 0 (returns -inf or
 * nan), and is accurate up to the last bit of the
 * mantissa. Vectorizes cleanly. */
inline Expr log(Expr x) {
    assert(x.defined() && "log of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "log_f64", vec(x), Internal::Call::Extern);
    } else {
        // return Internal::Call::make(Float(32), "log_f32", vec(cast<float>(x)), Internal::Call::Extern);
        return Internal::halide_log(cast<float>(x));
    }
}

/** Return one floating point expression raised to the power of
 * another. The type of the result is given by the type of the first
 * argument. If the first argument is not a floating-point type, it is
 * cast to Float(32). For Float(32), cleanly vectorizable, and
 * accurate up to the last few bits of the mantissa. Gets worse when
 * approaching overflow. Vectorizes cleanly. */
inline Expr pow(Expr x, Expr y) {
    assert(x.defined() && y.defined() && "pow of undefined");

    if (const int *i = as_const_int(y)) {
        return raise_to_integer_power(x, *i);
    }

    if (x.type() == Float(64)) {
        y = cast<double>(y);
        return Internal::Call::make(Float(64), "pow_f64", vec(x, y), Internal::Call::Extern);
    } else {
        x = cast<float>(x);
        y = cast<float>(y);
        return Internal::halide_exp(Internal::halide_log(x) * y);
    }
}

/** Fast approximate cleanly vectorizable log for Float(32). Returns
 * nonsense for x <= 0.0f. Accurate up to the last 5 bits of the
 * mantissa. Vectorizes cleanly. */
EXPORT Expr fast_log(Expr x);

/** Fast approximate cleanly vectorizable exp for Float(32). Returns
 * nonsense for inputs that would overflow or underflow. Typically
 * accurate up to the last 5 bits of the mantissa. Gets worse when
 * approaching overflow. Vectorizes cleanly. */
EXPORT Expr fast_exp(Expr x);

/** Fast approximate cleanly vectorizable pow for Float(32). Returns
 * nonsense for x < 0.0f. Accurate up to the last 5 bits of the
 * mantissa for typical exponents. Gets worse when approaching
 * overflow. Vectorizes cleanly. */
inline Expr fast_pow(Expr x, Expr y) {
    if (const int *i = as_const_int(y)) {
        return raise_to_integer_power(x, *i);
    }

    x = cast<float>(x);
    y = cast<float>(y);
    return select(x == 0.0f, 0.0f, fast_exp(fast_log(x) * y));
}

/** Return the greatest whole number less than or equal to a
 * floating-point expression. If the argument is not floating-point,
 * it is cast to Float(32). The return value is still in floating
 * point, despite being a whole number. Vectorizes cleanly. */
inline Expr floor(Expr x) {
    assert(x.defined() && "floor of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "floor_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "floor_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the least whole number greater than or equal to a
 * floating-point expression. If the argument is not floating-point,
 * it is cast to Float(32). The return value is still in floating
 * point, despite being a whole number. Vectorizes cleanly. */
inline Expr ceil(Expr x) {
    assert(x.defined() && "ceil of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "ceil_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "ceil_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Return the whole number closest to a floating-point expression. If
 * the argument is not floating-point, it is cast to Float(32). The
 * return value is still in floating point, despite being a whole
 * number. On ties, we round up. Vectorizes cleanly. */
inline Expr round(Expr x) {
    assert(x.defined() && "round of undefined");
    if (x.type() == Float(64)) {
        return Internal::Call::make(Float(64), "round_f64", vec(x), Internal::Call::Extern);
    } else {
        return Internal::Call::make(Float(32), "round_f32", vec(cast<float>(x)), Internal::Call::Extern);
    }
}

/** Reinterpret the bits of one value as another type. */
inline Expr reinterpret(Type t, Expr e) {
    assert(e.defined() && "reinterpret of undefined");
    assert((t.bits * t.width) == (e.type().bits * e.type().width));
    return Internal::Call::make(t, Internal::Call::reinterpret, vec(e), Internal::Call::Intrinsic);
}

template<typename T>
inline Expr reinterpret(Expr e) {
    return reinterpret(type_of<T>(), e);
}

/** Return the bitwise and of two expressions (which need not have the
 * same type). The type of the result is the type of the first
 * argument. */
inline Expr operator&(Expr x, Expr y) {
    assert(x.defined() && y.defined() && "bitwise and of undefined");
    // First widen or narrow, then bitcast.
    if (y.type().bits != x.type().bits) {
        Type t = y.type();
        t.bits = x.type().bits;
        y = cast(t, y);
    }
    if (y.type() != x.type()) {
        y = reinterpret(x.type(), y);
    }
    return Internal::Call::make(x.type(), Internal::Call::bitwise_and, vec(x, y), Internal::Call::Intrinsic);
}

/** Return the bitwise or of two expressions (which need not have the
 * same type). The type of the result is the type of the first
 * argument. */
inline Expr operator|(Expr x, Expr y) {
    assert(x.defined() && y.defined() && "bitwise or of undefined");
    // First widen or narrow, then bitcast.
    if (y.type().bits != x.type().bits) {
        Type t = y.type();
        t.bits = x.type().bits;
        y = cast(t, y);
    }
    if (y.type() != x.type()) {
        y = reinterpret(x.type(), y);
    }
    return Internal::Call::make(x.type(), Internal::Call::bitwise_or, vec(x, y), Internal::Call::Intrinsic);
}

/** Return the bitwise exclusive or of two expressions (which need not
 * have the same type). The type of the result is the type of the
 * first argument. */
inline Expr operator^(Expr x, Expr y) {
    assert(x.defined() && y.defined() && "bitwise or of undefined");
    // First widen or narrow, then bitcast.
    if (y.type().bits != x.type().bits) {
        Type t = y.type();
        t.bits = x.type().bits;
        y = cast(t, y);
    }
    if (y.type() != x.type()) {
        y = reinterpret(x.type(), y);
    }
    return Internal::Call::make(x.type(), Internal::Call::bitwise_xor, vec(x, y), Internal::Call::Intrinsic);
}

/** Return the bitwise not of an expression. */
inline Expr operator~(Expr x) {
    assert(x.defined() && "bitwise or of undefined");
    return Internal::Call::make(x.type(), Internal::Call::bitwise_not, vec(x), Internal::Call::Intrinsic);
}

/** Shift the bits of an integer value left. This is actually less
 * efficient than multiplying by 2^n, because Halide's optimization
 * passes understand multiplication, and will compile it to
 * shifting. This operator is only for if you really really need bit
 * shifting (e.g. because the exponent is a run-time parameter). The
 * type of the result is equal to the type of the first argument. Both
 * arguments must have integer type. */
inline Expr operator<<(Expr x, Expr y) {
    assert(x.defined() && y.defined() && "shift left of undefined");
    assert(!x.type().is_float() && "First argument to shift left is a float.");
    assert(!y.type().is_float() && "Second argument to shift left is a float.");
    Internal::match_types(x, y);
    return Internal::Call::make(x.type(), Internal::Call::shift_left, vec(x, y), Internal::Call::Intrinsic);
}

/** Shift the bits of an integer value right. Does sign extension for
 * signed integers. This is less efficient than dividing by a power of
 * two. Halide's definition of division (always round to negative
 * infinity) means that all divisions by powers of two get compiled to
 * bit-shifting, and Halide's optimization routines understand
 * division and can work with it. The type of the result is equal to
 * the type of the first argument. Both arguments must have integer
 * type. */
inline Expr operator>>(Expr x, Expr y) {
    assert(x.defined() && y.defined() && "shift right of undefined");
    assert(!x.type().is_float() && "First argument to shift right is a float.");
    assert(!y.type().is_float() && "Second argument to shift right is a float.");
    Internal::match_types(x, y);
    return Internal::Call::make(x.type(), Internal::Call::shift_right, vec(x, y), Internal::Call::Intrinsic);
}

/** Linear interpolate between the two values according to a weight.
 * \param zero_val The result when weight is 0
 * \param one_val The result when weight is 1
 * \param weight The interpolation amount
 *
 * Both zero_val and one_val must have the same type. All types are
 * supported, including bool.
 *
 * The weight is treated as its own type and must be float or an
 * unsigned integer type. It is scaled to the bit-size of the type of
 * x and y if they are integer, or converted to float if they are
 * float. Integer weights are converted to float via division by the
 * full-range value of the weight's type. Floating-point weights used
 * to interpolate between integer values must be between 0.0f and
 * 1.0f, and an error may be signaled if it is not provably so. (clamp
 * operators can be added to provide proof. Currently an error is only
 * signalled for constant weights.)
 *
 * For integer linear interpolation, out of range values cannot be
 * represented. In particular, weights that are conceptually less than
 * 0 or greater than 1.0 are not representable. As such the result is
 * always between x and y (inclusive of course). For lerp with
 * floating-point values and floating-point weight, the full range of
 * a float is valid, however underflow and overflow can still occur.
 *
 * Ordering is not required between zero_val and one_val:
 *     lerp(42, 69, .5f) == lerp(69, 42, .5f) == 56
 *
 * Results for integer types are for exactly rounded arithmetic. As
 * such, there are cases where 16-bit and float differ because 32-bit
 * floating-point (float) does not have enough precision to produce
 * the exact result. (Likely true for 32-bit integer
 * vs. double-precision floating-point as well.)
 *
 * At present, double precision and 64-bit integers are not supported.
 *
 * Generally, lerp will vectorize as if it were an operation on a type
 * twice the bit size of the inferred type for x and y.
 *
 * Some examples:
 * \code
 *
 *     // Since Halide does not have direct type delcarations, casts
 *     // below are used to indicate the types of the parameters.
 *     // Such casts not required or expected in actual code where types
 *     // are inferred.
 *
 *     lerp(cast<float>(x), cast<float>(y), cast<float>(w)) ->
 *       x * (1.0f - w) + y * w
 *
 *     lerp(cast<uint8_t>(x), cast<uint8_t>(y), cast<uint8_t>(w)) ->
 *       cast<uint8_t>(cast<uint8_t>(x) * (1.0f - cast<uint8_t>(w) / 255.0f) +
 *                     cast<uint8_t>(y) * cast<uint8_t>(w) / 255.0f + .5f)
 *
 *     // Note addition in Halide promoted uint8_t + int8_t to int16_t already,
 *     // the outer cast is added for clarity.
 *     lerp(cast<uint8_t>(x), cast<int8_t>(y), cast<uint8_t>(w)) ->
 *       cast<int16_t>(cast<uint8_t>(x) * (1.0f - cast<uint8_t>(w) / 255.0f) +
 *                     cast<int8_t>(y) * cast<uint8_t>(w) / 255.0f + .5f)
 *
 *     lerp(cast<int8_t>(x), cast<int8_t>(y), cast<float>(w)) ->
 *       cast<int8_t>(cast<int8_t>(x) * (1.0f - cast<float>(w)) +
 *                    cast<int8_t>(y) * cast<uint8_t>(w))
 *
 * \endcode
 * */
inline Expr lerp(Expr zero_val, Expr one_val, Expr weight) {
    assert(zero_val.defined() && "lerp with undefined zero value");
    assert(one_val.defined()  && "lerp with undefined one value");
    assert(weight.defined()   && "lerp with undefined weight");

    // We allow integer constants through, so that you can say things
    // like lerp(0, cast<uint8_t>(x), alpha) and produce an 8-bit
    // result. Note that lerp(0.0f, cast<uint8_t>(x), alpha) will
    // produce an error, as will lerp(0.0f, cast<double>(x),
    // alpha). lerp(0, cast<float>(x), alpha) is also allowed and will
    // produce a float result.
    if (as_const_int(zero_val)) {
        zero_val = cast(one_val.type(), zero_val);
    }
    if (as_const_int(one_val)) {
        one_val = cast(zero_val.type(), one_val);
    }

    assert(zero_val.type() == one_val.type() &&
           "lerp zero and one values must be the same type.");
    assert((weight.type().is_uint() || weight.type().is_float()) &&
           "lerp weight must be unsigned or float.");
    assert((zero_val.type().is_float() || zero_val.type().width <= 32) &&
           "lerp with 64-bit integers is not supported.");
    // Compilation error for constant weight that is out of range for integer use
    // as this seems like an easy to catch gotcha.
    if (!zero_val.type().is_float()) {
        const float *const_weight = as_const_float(weight);
        if (const_weight != NULL) {
            assert(*const_weight >= 0.0f && *const_weight <= 1.0f &&
                   "floating-point weight for lerp with integer arguments must be between 0.0f and 1.0f.");
        }
    }
    return Internal::Call::make(zero_val.type(), Internal::Call::lerp,
                                vec(zero_val, one_val, weight),
                                Internal::Call::Intrinsic);
}

}


#endif
#include <vector>

namespace Halide {

class FuncRefVar;
class FuncRefExpr;

/** Create a small array of Exprs for defining and calling functions
 * with multiple outputs. */
class Tuple {
private:
    std::vector<Expr> exprs;
public:
    /** The number of elements in the tuple. */
    size_t size() const { return exprs.size(); }

    /** Get a reference to an element. */
    Expr &operator[](size_t x) {
        assert((x < exprs.size()) && "Tuple access out of bounds");
        return exprs[x];
    }

    /** Get a copy of an element. */
    Expr operator[](size_t x) const {
        assert((x < exprs.size()) && "Tuple access out of bounds");
        return exprs[x];
    }

    /** Construct a Tuple from some Exprs. */
    //@{
    Tuple(Expr a, Expr b) :
        exprs(Internal::vec<Expr>(a, b)) {
    }

    Tuple(Expr a, Expr b, Expr c) :
        exprs(Internal::vec<Expr>(a, b, c)) {
    }

    Tuple(Expr a, Expr b, Expr c, Expr d) :
        exprs(Internal::vec<Expr>(a, b, c, d)) {
    }

    Tuple(Expr a, Expr b, Expr c, Expr d, Expr e) :
        exprs(Internal::vec<Expr>(a, b, c, d, e)) {
    }

    Tuple(Expr a, Expr b, Expr c, Expr d, Expr e, Expr f) :
        exprs(Internal::vec<Expr>(a, b, c, d, e, f)) {
    }
    //@}

    /** Construct a Tuple from a vector of Exprs */
    explicit Tuple(const std::vector<Expr> &e) : exprs(e) {
        assert((e.size() > 0) && "Tuples must have at least one element\n");
    }

    /** Construct a Tuple from a function reference. */
    // @{
    EXPORT Tuple(const FuncRefVar &);
    EXPORT Tuple(const FuncRefExpr &);
    // @}

    /** Treat the tuple as a vector of Exprs */
    const std::vector<Expr> &as_vector() const {
        return exprs;
    }
};

/** Funcs with Tuple values return multiple buffers when you realize
 * them. Tuples are to Exprs as Realizations are to Buffers. */
class Realization {
private:
    std::vector<Buffer> buffers;
public:
    /** The number of elements in the tuple. */
    size_t size() const { return buffers.size(); }

    /** Get a reference to an element. */
    Buffer &operator[](size_t x) {
        assert(x < buffers.size() && "Realization access out of bounds");
        return buffers[x];
    }

    /** Get a copy of an element. */
    Buffer operator[](size_t x) const {
        assert((x < buffers.size()) && "Realization access out of bounds");
        return buffers[x];
    }

    /** Single-element realizations are implicitly castable to Buffers. */
    operator Buffer() const {
        assert((buffers.size() == 1) && "Can only cast single-element realizations to buffers or images");
        return buffers[0];
    }

    /** Construct a Realization from some Buffers. */
    //@{
    Realization(Buffer a, Buffer b) :
        buffers(Internal::vec<Buffer>(a, b)) {}

    Realization(Buffer a, Buffer b, Buffer c) :
        buffers(Internal::vec<Buffer>(a, b, c)) {}

    Realization(Buffer a, Buffer b, Buffer c, Buffer d) :
        buffers(Internal::vec<Buffer>(a, b, c, d)) {}

    Realization(Buffer a, Buffer b, Buffer c, Buffer d, Buffer e) :
        buffers(Internal::vec<Buffer>(a, b, c, d, e)) {}

    Realization(Buffer a, Buffer b, Buffer c, Buffer d, Buffer e, Buffer f) :
        buffers(Internal::vec<Buffer>(a, b, c, d, e, f)) {}
    //@}

    /** Construct a Realization from a vector of Buffers */
    explicit Realization(const std::vector<Buffer> &e) : buffers(e) {
        assert(e.size() > 0 && "Realizations must have at least one element\n");
    }

    /** Treat the Realization as a vector of Buffers */
    const std::vector<Buffer> &as_vector() const {
        return buffers;
    }
};

/** Equivalents of some standard operators for tuples. */
// @{
inline Tuple tuple_select(Tuple condition, const Tuple &true_value, const Tuple &false_value) {
    Tuple result(std::vector<Expr>(condition.size()));
    for (size_t i = 0; i < result.size(); i++) {
        result[i] = select(condition[i], true_value[i], false_value[i]);
    }
    return result;
}

inline Tuple tuple_select(Expr condition, const Tuple &true_value, const Tuple &false_value) {
    Tuple result(std::vector<Expr>(true_value.size()));
    for (size_t i = 0; i < result.size(); i++) {
        result[i] = select(condition, true_value[i], false_value[i]);
    }
    return result;
}
// @}

}

#endif

namespace Halide {

/** A reference-counted handle on a dense multidimensional array
 * containing scalar values of type T. Can be directly accessed and
 * modified. May have up to four dimensions. Color images are
 * represented as three-dimensional, with the third dimension being
 * the color channel. In general we store color images in
 * color-planes, as opposed to packed RGB, because this tends to
 * vectorize more cleanly. */
template<typename T>
class Image {
private:
    /** The underlying memory object */
    Buffer buffer;

    /** These fields are also stored in the buffer, but they're cached
     * here in the handle to make operator() fast. This is safe to do
     * because the buffer is never modified
     */
    // @{
    T *origin;
    int stride_0, stride_1, stride_2, stride_3, dims;
    // @}

    /** Prepare the buffer to be used as an image. Makes sure that the
     * cached strides are correct, and that the image data is on the
     * host. */
    void prepare_for_direct_pixel_access() {
        // Make sure buffer has been copied to host. This is a no-op
        // if there's no device involved.
        buffer.copy_to_host();

        // We're probably about to modify the pixels, so to be
        // conservative we'd better set host dirty. If you're sure
        // you're not going to modify this memory via the Image
        // object, then you can call set_host_dirty(false) on the
        // underlying buffer.
        buffer.set_host_dirty(true);

        if (buffer.defined()) {
            origin = (T *)buffer.host_ptr();
            stride_0 = buffer.stride(0);
            stride_1 = buffer.stride(1);
            stride_2 = buffer.stride(2);
            stride_3 = buffer.stride(3);
            // The host pointer points to the mins vec, but we want to
            // point to the origin of the coordinate system.
            origin -= (buffer.min(0) * stride_0 +
                       buffer.min(1) * stride_1 +
                       buffer.min(2) * stride_2 +
                       buffer.min(3) * stride_3);
            dims = buffer.dimensions();
        } else {
            origin = NULL;
            stride_0 = stride_1 = stride_2 = stride_3 = 0;
            dims = 0;
        }
    }

    bool add_implicit_args_if_placeholder(std::vector<Expr> &args,
                                          Expr last_arg,
                                          int total_args,
                                          bool placeholder_seen) const {
        const Internal::Variable *var = last_arg.as<Internal::Variable>();
        bool is_placeholder = var != NULL && Var::is_placeholder(var->name);
        if (is_placeholder) {
            assert(!placeholder_seen && "Only one placeholder ('_') allowed in argument list for Image.");
            placeholder_seen = true;

            // The + 1 in the conditional is because one provided argument is an placeholder
            for (int i = 0; i < (dims - total_args + 1); i++) {
                args.push_back(Var::implicit(i));
            }
        } else {
            args.push_back(last_arg);
        }

#if HALIDE_WARNINGS_FOR_OLD_IMPLICITS
        if (!is_placeholder && !placeholder_seen &&
            (int)args.size() == total_args &&
            (int)args.size() < dims) {
            std::cout << "Implicit arguments without placeholders ('_') are deprecated. "
                      << "Adding " << dims - args.size()
                      << " arguments to Image " << buffer.name() << '\n';
            int i = 0;
            while ((int)args.size() < dims) {
                args.push_back(Var::implicit(i++));

            }
        }
#endif

        return is_placeholder;
    }

public:
    /** Construct an undefined image handle */
    Image() : origin(NULL), stride_0(0), stride_1(0), stride_2(0), stride_3(0), dims(0) {}

    /** Allocate an image with the given dimensions. */
    // @{
    Image(int x, int y = 0, int z = 0, int w = 0, const std::string &name = "") :
        buffer(Buffer(type_of<T>(), x, y, z, w, NULL, name)) {
        prepare_for_direct_pixel_access();
    }

    Image(int x, int y, int z, const std::string &name) :
        buffer(Buffer(type_of<T>(), x, y, z, 0, NULL, name)) {
        prepare_for_direct_pixel_access();
    }

    Image(int x, int y, const std::string &name) :
        buffer(Buffer(type_of<T>(), x, y, 0, 0, NULL, name)) {
        prepare_for_direct_pixel_access();
    }

    Image(int x, const std::string &name) :
        buffer(Buffer(type_of<T>(), x, 0, 0, 0, NULL, name)) {
        prepare_for_direct_pixel_access();
    }
    // @}

    /** Wrap a buffer in an Image object, so that we can directly
     * access its pixels in a type-safe way. */
    Image(const Buffer &buf) : buffer(buf) {
        if (type_of<T>() != buffer.type()) {
            std::cerr << "Can't construct Image of type " << type_of<T>()
                      << " from buffer of type " << buffer.type() << '\n';
            assert(false);
        }
        prepare_for_direct_pixel_access();
    }

    /** Wrap a single-element realization in an Image object. */
    Image(const Realization &r) : buffer(r) {
        if (type_of<T>() != buffer.type()) {
            std::cerr << "Can't construct Image of type " << type_of<T>()
                      << " from buffer of type " << buffer.type() << '\n';
            assert(false);
        }
        prepare_for_direct_pixel_access();
    }

    /** Wrap a buffer_t in an Image object, so that we can access its
     * pixels. */
    Image(const buffer_t *b, const std::string &name = "") : buffer(type_of<T>(), b, name) {
        prepare_for_direct_pixel_access();
    }

    /** Manually copy-back data to the host, if it's on a device. This
     * is done for you if you construct an image from a buffer, but
     * you might need to call this if you realize a gpu kernel into an
     * existing image */
    void copy_to_host() {
        buffer.copy_to_host();
    }

    /** Mark the buffer as dirty-on-host.  is done for you if you
     * construct an image from a buffer, but you might need to call
     * this if you realize a gpu kernel into an existing image, or
     * modify the data via some other back-door. */
    void set_host_dirty(bool dirty = true) {
        buffer.set_host_dirty(dirty);
    }

    /** Check if this image handle points to actual data */
    bool defined() const {
        return buffer.defined();
    }

    /** Get the dimensionality of the data. Typically two for grayscale images, and three for color images. */
    int dimensions() const {
        return dims;
    }

    /** Get the size of a dimension */
    int extent(int dim) const {
        assert(defined());
        assert(dim >= 0 && dim < dims && "dimension out of bounds in call to Image::extent");
        return buffer.extent(dim);
    }

    /** Get the min coordinate of a dimension. The top left of the
     * image represents this point in a function that was realized
     * into this image. */
    int min(int dim) const {
        assert(defined());
        assert(dim >= 0 && dim < dims && "dimension out of bounds in call to Image::min");
        return buffer.min(dim);
    }

    /** Set the min coordinates of a dimension. */
    void set_min(int m0, int m1 = 0, int m2 = 0, int m3 = 0) {
        assert(defined());
        buffer.set_min(m0, m1, m2, m3);
        // Move the origin
        prepare_for_direct_pixel_access();
    }

    /** Get the number of elements in the buffer between two adjacent
     * elements in the given dimension. For example, the stride in
     * dimension 0 is usually 1, and the stride in dimension 1 is
     * usually the extent of dimension 0. This is not necessarily true
     * though. */
    int stride(int dim) const {
        assert(defined());
        assert(dim >= 0 && dim < dims && "dimension out of bounds in call to Image::stride");
        return buffer.stride(dim);
    }

    /** Get the extent of dimension 0, which by convention we use as
     * the width of the image. Unlike extent(0), returns one if the
     * buffer is zero-dimensional. */
    int width() const {
        if (dimensions() < 1) return 1;
        return extent(0);
    }

    /** Get the extent of dimension 1, which by convention we use as
     * the height of the image. Unlike extent(1), returns one if the
     * buffer has fewer than two dimensions. */
    int height() const {
        if (dimensions() < 2) return 1;
        return extent(1);
    }

    /** Get the extent of dimension 2, which by convention we use as
     * the number of color channels (often 3). Unlike extent(2),
     * returns one if the buffer has fewer than three dimensions. */
    int channels() const {
        if (dimensions() < 3) return 1;
        return extent(2);
    }

    /** Get a pointer to the element at the min location. */
    T *data() const {
        assert(defined());
        T *ptr = origin;
        for (int i = 0; i < dims; i++) {
            ptr += min(i) * stride(i);
        }
        return ptr;
    }

    /** Assuming this image is one-dimensional, get the value of the
     * element at position x */
    T operator()(int x) const {
        return origin[x];
    }

    /** Assuming this image is two-dimensional, get the value of the
     * element at position (x, y) */
    T operator()(int x, int y) const {
        return origin[x*stride_0 + y*stride_1];
    }

    /** Assuming this image is three-dimensional, get the value of the
     * element at position (x, y, z) */
    T operator()(int x, int y, int z) const {
        return origin[x*stride_0 + y*stride_1 + z*stride_2];
    }

    /** Assuming this image is four-dimensional, get the value of the
     * element at position (x, y, z, w) */
    T operator()(int x, int y, int z, int w) const {
        return origin[x*stride_0 + y*stride_1 + z*stride_2 + w*stride_3];
    }

    /** Assuming this image is one-dimensional, get a reference to the
     * element at position x */
    T &operator()(int x) {
        return origin[x*stride_0];
    }

    /** Assuming this image is two-dimensional, get a reference to the
     * element at position (x, y) */
    T &operator()(int x, int y) {
        return origin[x*stride_0 + y*stride_1];
    }

    /** Assuming this image is three-dimensional, get a reference to the
     * element at position (x, y, z) */
    T &operator()(int x, int y, int z) {
        return origin[x*stride_0 + y*stride_1 + z*stride_2];
    }

    /** Assuming this image is four-dimensional, get a reference to the
     * element at position (x, y, z, w) */
    T &operator()(int x, int y, int z, int w) {
        return origin[x*stride_0 + y*stride_1 + z*stride_2 + w*stride_3];
    }

    /** Construct an expression which loads from this image. The
     * location is composed of enough implicit variables to match the
     * dimensionality of the image (see \ref Var::implicit) */
    Expr operator()() const {
        assert(dims == 0);
        std::vector<Expr> args;
        return Internal::Call::make(buffer, args);
    }

    /** Construct an expression which loads from this image. The
     * location is extended with enough implicit variables to match
     * the dimensionality of the image (see \ref Var::implicit) */
    // @{
    Expr operator()(Expr x) const {
        std::vector<Expr> args;
        bool placeholder_seen = false;
        placeholder_seen |= add_implicit_args_if_placeholder(args, x, 1, placeholder_seen);

        assert(args.size() == (size_t)dims);

        ImageParam::check_arg_types(buffer.name(), &args);

        return Internal::Call::make(buffer, args);
    }

    Expr operator()(Expr x, Expr y) const {
        std::vector<Expr> args;
        bool placeholder_seen = false;
        placeholder_seen |= add_implicit_args_if_placeholder(args, x, 2, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, y, 2, placeholder_seen);

        assert(args.size() == (size_t)dims);

        ImageParam::check_arg_types(buffer.name(), &args);

        return Internal::Call::make(buffer, args);
    }

    Expr operator()(Expr x, Expr y, Expr z) const {
        std::vector<Expr> args;
        bool placeholder_seen = false;
        placeholder_seen |= add_implicit_args_if_placeholder(args, x, 3, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, y, 3, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, z, 3, placeholder_seen);

        assert(args.size() == (size_t)dims);

        ImageParam::check_arg_types(buffer.name(), &args);

        return Internal::Call::make(buffer, args);
    }

    Expr operator()(Expr x, Expr y, Expr z, Expr w) const {
        std::vector<Expr> args;
        bool placeholder_seen = false;
        placeholder_seen |= add_implicit_args_if_placeholder(args, x, 4, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, y, 4, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, z, 4, placeholder_seen);
        placeholder_seen |= add_implicit_args_if_placeholder(args, w, 4, placeholder_seen);

        assert(args.size() == (size_t)dims);

        ImageParam::check_arg_types(buffer.name(), &args);

        return Internal::Call::make(buffer, args);
    }
    // @}

    /** Get a pointer to the raw buffer_t that this image holds */
    buffer_t *raw_buffer() const {return buffer.raw_buffer();}

    /** Get a handle on the Buffer that this image holds */
    operator Buffer() const {return buffer;}

    /** Convert this image to an argument to a halide pipeline. */
    operator Argument() const {
        return Argument(buffer);
    }

    /** Convert this image to an argument to an extern stage. */
    operator ExternFuncArgument() const {
        return ExternFuncArgument(buffer);
    }

    /** Treating the image as an Expr is equivalent to call it with no
     * arguments. For example, you can say:
     *
     \code
     Image im(10, 10);
     Func f;
     f = im*2;
     \endcode
     *
     * This will define f as a two-dimensional function with value at
     * position (x, y) equal to twice the value of the image at the
     * same location.
     */
    operator Expr() const {return (*this)(_);}


};

}

#endif

namespace Halide {

/** A fragment of front-end syntax of the form f(x, y, z), where x,
 * y, z are Vars. It could be the left-hand side of a function
 * definition, or it could be a call to a function. We don't know
 * until we see how this object gets used.
 */
class FuncRefExpr;

class FuncRefVar {
    Internal::Function func;
    int implicit_placeholder_pos;
    std::vector<std::string> args;
    std::vector<std::string> args_with_implicit_vars(const std::vector<Expr> &e) const;
public:
    FuncRefVar(Internal::Function, const std::vector<Var> &, int placeholder_pos = -1);

    /**  Use this as the left-hand-side of a definition. */
    EXPORT void operator=(Expr);

    /** Use this as the left-hand-side of a definition for a Func with
     * multiple outputs. */
    EXPORT void operator=(const Tuple &);

    /** Define this function as a sum reduction over the negative of
     * the given expression. The expression should refer to some RDom
     * to sum over. If the function does not already have a pure
     * definition, this sets it to zero.
     */
    EXPORT void operator+=(Expr);

    /** Define this function as a sum reduction over the given
     * expression. The expression should refer to some RDom to sum
     * over. If the function does not already have a pure definition,
     * this sets it to zero.
     */
    EXPORT void operator-=(Expr);

    /** Define this function as a product reduction. The expression
     * should refer to some RDom to take the product over. If the
     * function does not already have a pure definition, this sets it
     * to 1.
     */
    EXPORT void operator*=(Expr);

    /** Define this function as the product reduction over the inverse
     * of the expression. The expression should refer to some RDom to
     * take the product over. If the function does not already have a
     * pure definition, this sets it to 1.
     */
    EXPORT void operator/=(Expr);

    /** Override the usual assignment operator, so that
     * f(x, y) = g(x, y) defines f.
     */
    // @{
    EXPORT void operator=(const FuncRefVar &e);
    EXPORT void operator=(const FuncRefExpr &e);
    // @}

    /** Use this FuncRefVar as a call to the function, and not as the
     * left-hand-side of a definition. Only works for single-output
     * funcs.
     */
    EXPORT operator Expr() const;

    /** When a FuncRefVar refers to a function that provides multiple
     * outputs, you can access each output as an Expr using
     * operator[] */
    EXPORT Expr operator[](int) const;

    /** How many outputs does the function this refers to produce. */
    EXPORT size_t size() const;
};

/** A fragment of front-end syntax of the form f(x, y, z), where x, y,
 * z are Exprs. If could be the left hand side of a reduction
 * definition, or it could be a call to a function. We don't know
 * until we see how this object gets used.
 */
class FuncRefExpr {
    Internal::Function func;
    int implicit_placeholder_pos;
    std::vector<Expr> args;
    std::vector<Expr> args_with_implicit_vars(const std::vector<Expr> &e) const;
public:
    FuncRefExpr(Internal::Function, const std::vector<Expr> &,
                int placeholder_pos = -1);
    FuncRefExpr(Internal::Function, const std::vector<std::string> &,
                int placeholder_pos = -1);

    /** Use this as the left-hand-side of a reduction definition (see
     * \ref RDom). The function must already have a pure definition.
     */
    EXPORT void operator=(Expr);

    /** Use this as the left-hand-side of a reduction definition for a
     * Func with multiple outputs. */
    EXPORT void operator=(const Tuple &);

    /** Define this function as a sum reduction over the negative of
     * the given expression. The expression should refer to some RDom
     * to sum over. If the function does not already have a pure
     * definition, this sets it to zero.
     */
    EXPORT void operator+=(Expr);

    /** Define this function as a sum reduction over the given
     * expression. The expression should refer to some RDom to sum
     * over. If the function does not already have a pure definition,
     * this sets it to zero.
     */
    EXPORT void operator-=(Expr);

    /** Define this function as a product reduction. The expression
     * should refer to some RDom to take the product over. If the
     * function does not already have a pure definition, this sets it
     * to 1.
     */
    EXPORT void operator*=(Expr);

    /** Define this function as the product reduction over the inverse
     * of the expression. The expression should refer to some RDom to
     * take the product over. If the function does not already have a
     * pure definition, this sets it to 1.
     */
    EXPORT void operator/=(Expr);

    /* Override the usual assignment operator, so that
     * f(x, y) = g(x, y) defines f.
     */
    // @{
    EXPORT void operator=(const FuncRefVar &);
    EXPORT void operator=(const FuncRefExpr &);
    // @}

    /** Use this as a call to the function, and not the left-hand-side
     * of a definition. Only works for single-output Funcs. */
    EXPORT operator Expr() const;

    /** When a FuncRefExpr refers to a function that provides multiple
     * outputs, you can access each output as an Expr using
     * operator[].
     */
    EXPORT Expr operator[](int) const;

    /** How many outputs does the function this refers to produce. */
    EXPORT size_t size() const;
};

/** A wrapper around a schedule used for common schedule manipulations */
class ScheduleHandle {
    Internal::Schedule &schedule;
    void set_dim_type(Var var, Internal::For::ForType t);
    void dump_argument_list();
public:
    ScheduleHandle(Internal::Schedule &s) : schedule(s) {}

    /** Split a dimension into inner and outer subdimensions with the
     * given names, where the inner dimension iterates from 0 to
     * factor-1. The inner and outer subdimensions can then be dealt
     * with using the other scheduling calls. It's ok to reuse the old
     * variable name as either the inner or outer variable. */
    EXPORT ScheduleHandle &split(Var old, Var outer, Var inner, Expr factor);

    EXPORT ScheduleHandle &fuse(Var inner, Var outer, Var fused);

    /** Mark a dimension to be traversed in parallel */
    EXPORT ScheduleHandle &parallel(Var var);

    /** Mark a dimension to be computed all-at-once as a single
     * vector. The dimension should have constant extent -
     * e.g. because it is the inner dimension following a split by a
     * constant factor. For most uses of vectorize you want the two
     * argument form. The variable to be vectorized should be the
     * innermost one. */
    EXPORT ScheduleHandle &vectorize(Var var);

    /** Mark a dimension to be completely unrolled. The dimension
     * should have constant extent - e.g. because it is the inner
     * dimension following a split by a constant factor. For most uses
     * of unroll you want the two-argument form. */
    EXPORT ScheduleHandle &unroll(Var var);

    /** Split a dimension by the given factor, then vectorize the
     * inner dimension. This is how you vectorize a loop of unknown
     * size. The variable to be vectorized should be the innermost
     * one. After this call, var refers to the outer dimension of the
     * split. */
    EXPORT ScheduleHandle &vectorize(Var var, int factor);

    /** Split a dimension by the given factor, then unroll the inner
     * dimension. This is how you unroll a loop of unknown size by
     * some constant factor. After this call, var refers to the outer
     * dimension of the split. */
    EXPORT ScheduleHandle &unroll(Var var, int factor);

    /** Statically declare that the range over which a function should
     * be evaluated is given by the second and third arguments. This
     * can let Halide perform some optimizations. E.g. if you know
     * there are going to be 4 color channels, you can completely
     * vectorize the color channel dimension without the overhead of
     * splitting it up. If bounds inference decides that it requires
     * more of this function than the bounds you have stated, a
     * runtime error will occur when you try to run your pipeline. */
    EXPORT ScheduleHandle &bound(Var var, Expr min, Expr extent);

    /** Split two dimensions at once by the given factors, and then
     * reorder the resulting dimensions to be xi, yi, xo, yo from
     * innermost outwards. This gives a tiled traversal. */
    EXPORT ScheduleHandle &tile(Var x, Var y, Var xo, Var yo, Var xi, Var yi, Expr xfactor, Expr yfactor);

    /** A shorter form of tile, which reuses the old variable names as
     * the new outer dimensions */
    EXPORT ScheduleHandle &tile(Var x, Var y, Var xi, Var yi, Expr xfactor, Expr yfactor);

    /** Reorder variables to have the given nesting order, from
     * innermost out */
    EXPORT ScheduleHandle &reorder(const std::vector<Var> &vars);

    /** Reorder two dimensions so that x is traversed inside y. Does
     * not affect the nesting order of other dimensions. E.g, if you
     * say foo(x, y, z, w) = bar; foo.reorder(w, x); then foo will be
     * traversed in the order (w, y, z, x), from innermost
     * outwards. */
    EXPORT ScheduleHandle &reorder(Var x, Var y);

    /** Reorder three dimensions to have the given nesting order, from
     * innermost out */
    EXPORT ScheduleHandle &reorder(Var x, Var y, Var z);

    /** Reorder four dimensions to have the given nesting order, from
     * innermost out */
    EXPORT ScheduleHandle &reorder(Var x, Var y, Var z, Var w);

    /** Reorder five dimensions to have the given nesting order, from
     * innermost out */
    EXPORT ScheduleHandle &reorder(Var x, Var y, Var z, Var w, Var t);

    /** Reorder six dimensions to have the given nesting order, from
     * innermost out */
    EXPORT ScheduleHandle &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2);

    /** Reorder seven dimensions to have the given nesting order, from
     * innermost out */
    EXPORT ScheduleHandle &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2, Var t3);

    /** Reorder eight dimensions to have the given nesting order, from
     * innermost out */
    EXPORT ScheduleHandle &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2, Var t3, Var t4);

    /** Reorder nine dimensions to have the given nesting order, from
     * innermost out */
    EXPORT ScheduleHandle &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2, Var t3, Var t4, Var t5);

    /** Reorder ten dimensions to have the given nesting order, from
     * innermost out */
    EXPORT ScheduleHandle &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2, Var t3, Var t4, Var t5, Var t6);

    /** Rename a dimension. Equivalent to split with a inner size of one. */
    EXPORT ScheduleHandle &rename(Var old_name, Var new_name);

    /** Tell Halide that the following dimensions correspond to cuda
     * thread indices. This is useful if you compute a producer
     * function within the block indices of a consumer function, and
     * want to control how that function's dimensions map to cuda
     * threads. If the selected target is not ptx, this just marks
     * those dimensions as parallel. */
    // @{
    EXPORT ScheduleHandle &cuda_threads(Var thread_x);
    EXPORT ScheduleHandle &cuda_threads(Var thread_x, Var thread_y);
    EXPORT ScheduleHandle &cuda_threads(Var thread_x, Var thread_y, Var thread_z);
    // @}

    /** Tell Halide that the following dimensions correspond to cuda
     * block indices. This is useful for scheduling stages that will
     * run serially within each cuda block. If the selected target is
     * not ptx, this just marks those dimensions as parallel. */
    // @{
    EXPORT ScheduleHandle &cuda_blocks(Var block_x);
    EXPORT ScheduleHandle &cuda_blocks(Var block_x, Var block_y);
    EXPORT ScheduleHandle &cuda_blocks(Var block_x, Var block_y, Var block_z);
    // @}

    /** Tell Halide that the following dimensions correspond to cuda
     * block indices and thread indices. If the selected target is not
     * ptx, these just mark the given dimensions as parallel. The
     * dimensions are consumed by this call, so do all other
     * unrolling, reordering, etc first. */
    // @{
    EXPORT ScheduleHandle &cuda(Var block_x, Var thread_x);
    EXPORT ScheduleHandle &cuda(Var block_x, Var block_y,
                                Var thread_x, Var thread_y);
    EXPORT ScheduleHandle &cuda(Var block_x, Var block_y, Var block_z,
                                Var thread_x, Var thread_y, Var thread_z);
    // @}

    /** Short-hand for tiling a domain and mapping the tile indices
     * to cuda block indices and the coordinates within each tile to
     * cuda thread indices. Consumes the variables given, so do all
     * other scheduling first. */
    // @{
    EXPORT ScheduleHandle &cuda_tile(Var x, int x_size);
    EXPORT ScheduleHandle &cuda_tile(Var x, Var y, int x_size, int y_size);
    EXPORT ScheduleHandle &cuda_tile(Var x, Var y, Var z,
                                     int x_size, int y_size, int z_size);
    // @}

};

/** A halide function. This class represents one stage in a Halide
 * pipeline, and is the unit by which we schedule things. By default
 * they are aggressively inlined, so you are encouraged to make lots
 * of little functions, rather than storing things in Exprs. */
class Func {

    /** A handle on the internal halide function that this
     * represents */
    Internal::Function func;

    /** When you make a reference to this function to with fewer
     * arguments that it has dimensions, the argument list is bulked
     * up with 'implicit' vars with canonical names. This lets you
     * pass around partially-applied halide functions. */
    // @{
    int add_implicit_vars(std::vector<Var> &) const;
    int add_implicit_vars(std::vector<Expr> &) const;
    // @}

    /** The lowered imperative form of this function. Cached here so
     * that recompilation for different targets doesn't require
     * re-lowering */
    Internal::Stmt lowered;

    /** A JIT-compiled version of this function that we save so that
     * we don't have to rejit every time we want to evaluated it. */
    Internal::JITCompiledModule compiled_module;

    /** The current error handler used for realizing this
     * function. May be NULL. Only relevant when jitting. */
    void (*error_handler)(const char *);

    /** The current custom allocator used for realizing this
     * function. May be NULL. Only relevant when jitting. */
    // @{
    void *(*custom_malloc)(size_t);
    void (*custom_free)(void *);
    // @}

    /** The current custom parallel task launcher and handler for
     * realizing this function. May be NULL. */
    // @{
    int (*custom_do_par_for)(int (*)(int, uint8_t *), int, int, uint8_t *);
    int (*custom_do_task)(int (*)(int, uint8_t *), int, uint8_t *);
    // @}

    /** The current custom tracing functions. May be NULL. */
    // @{
    void (*custom_trace)(const char *, int32_t, int32_t, int32_t, int32_t, int32_t, const void *, int32_t, const int32_t *);
    // @}

    /** Pointers to current values of the automatically inferred
     * arguments (buffers and scalars) used to realize this
     * function. Only relevant when jitting. We can hold these things
     * with raw pointers instead of reference-counted handles, because
     * func indirectly holds onto them with reference-counted handles
     * via its value Expr. */
    std::vector<const void *> arg_values;

    /** Some of the arg_values need to be rebound on every call if the
     * image params change. The pointers for the scalar params will
     * still be valid though. */
    std::vector<std::pair<int, Internal::Parameter> > image_param_args;

public:
    EXPORT static void test();

    /** Declare a new undefined function with the given name */
    EXPORT explicit Func(const std::string &name);

    /** Declare a new undefined function with an
     * automatically-generated unique name */
    EXPORT Func();

    /** Declare a new function with an automatically-generated unique
     * name, and define it to return the given expression (which may
     * not contain free variables). */
    EXPORT explicit Func(Expr e);

    /** Generate a new uniquely-named function that returns the given
     * buffer. Has the same dimensionality as the buffer. Useful for
     * passing Images to c++ functions that expect Funcs */
    //@{
    //EXPORT Func(Buffer image);
    /*
    template<typename T> Func(Image<T> image) {
        (*this) = Func(Buffer(image));
    }
    */
    //@}

    /** Evaluate this function over some rectangular domain and return
     * the resulting buffer or buffers. The buffer should probably be
     * instantly wrapped in an Image class of the appropriate
     * type. That is, do this:
     *
     * f(x) = sin(x);
     * Image<float> im = f.realize(...);
     *
     * not this:
     *
     * f(x) = sin(x)
     * Buffer im = f.realize(...)
     *
     * If your Func has multiple values, because you defined it using
     * a Tuple, then casting the result of a realize call to a buffer
     * or image will produce a run-time errorInstead you should do the
     * following:
     *
     * f(x) = Tuple(x, sin(x));
     * Realization r = f.realize(...);
     * Image<int> im0 = r[0];
     * Image<float> im1 = r[1];
     *
     */
    EXPORT Realization realize(int x_size = 0, int y_size = 0, int z_size = 0, int w_size = 0);

    /** Evaluate this function into an existing allocated buffer or
     * buffers. If the buffer is also one of the arguments to the
     * function, strange things may happen, as the pipeline isn't
     * necessarily safe to run in-place. If you pass multiple buffers,
     * they must have matching sizes. */
    // @{
    EXPORT void realize(Realization dst);
    EXPORT void realize(Buffer dst);
    // @}

    /** For a given size of output, or a given output buffer,
     * determine the bounds required of all unbound ImageParams
     * referenced. Communicates the result by allocating new buffers
     * of the appropriate size and binding them to the unbound
     * ImageParams. */
    // @{
    EXPORT void infer_input_bounds(int x_size = 0, int y_size = 0, int z_size = 0, int w_size = 0);
    EXPORT void infer_input_bounds(Realization dst);
    EXPORT void infer_input_bounds(Buffer dst);
    // @}

    /** Statically compile this function to llvm bitcode, with the
     * given filename (which should probably end in .bc), type
     * signature, and C function name (which defaults to the same name
     * as this halide function */
    EXPORT void compile_to_bitcode(const std::string &filename, std::vector<Argument>, const std::string &fn_name = "");

    /** Statically compile this function to an object file, with the
     * given filename (which should probably end in .o or .obj), type
     * signature, and C function name (which defaults to the same name
     * as this halide function. You probably don't want to use this directly - instead call compile_to_file.  */
    EXPORT void compile_to_object(const std::string &filename, std::vector<Argument>, const std::string &fn_name = "");

    /** Emit a header file with the given filename for this
     * function. The header will define a function with the type
     * signature given by the second argument, and a name given by the
     * third. The name defaults to the same name as this halide
     * function. You don't actually have to have defined this function
     * yet to call this. You probably don't want to use this directly
     * - instead call compile_to_file. */
    EXPORT void compile_to_header(const std::string &filename, std::vector<Argument>, const std::string &fn_name = "");

    /** Statically compile this function to text assembly equivalent
     * to the object file generated by compile_to_object. This is
     * useful for checking what Halide is producing without having to
     * disassemble anything, or if you need to feed the assembly into
     * some custom toolchain to produce an object file (e.g. iOS) */
    EXPORT void compile_to_assembly(const std::string &filename, std::vector<Argument>, const std::string &fn_name = "");
    /** Statically compile this function to C source code. This is
     * useful for providing fallback code paths that will compile on
     * many platforms. Vectorization will fail, and parallelization
     * will produce serial code. */
    EXPORT void compile_to_c(const std::string &filename, std::vector<Argument>, const std::string &fn_name = "");

    /** Write out an internal representation of lowered code. Useful
     * for analyzing and debugging scheduling. Canonical extension is
     * .stmt, which must be supplied in filename. */
    EXPORT void compile_to_lowered_stmt(const std::string &filename);

    /** Compile to object file and header pair, with the given
     * arguments. Also names the C function to match the first
     * argument.
     */
    //@{
    EXPORT void compile_to_file(const std::string &filename_prefix, std::vector<Argument> args);
    EXPORT void compile_to_file(const std::string &filename_prefix);
    EXPORT void compile_to_file(const std::string &filename_prefix, Argument a);
    EXPORT void compile_to_file(const std::string &filename_prefix, Argument a, Argument b);
    EXPORT void compile_to_file(const std::string &filename_prefix, Argument a, Argument b, Argument c);
    EXPORT void compile_to_file(const std::string &filename_prefix, Argument a, Argument b, Argument c, Argument d);
    EXPORT void compile_to_file(const std::string &filename_prefix, Argument a, Argument b, Argument c, Argument d, Argument e);
    // @}

    /** Eagerly jit compile the function to machine code. This
     * normally happens on the first call to realize. If you're
     * running your halide pipeline inside time-sensitive code and
     * wish to avoid including the time taken to compile a pipeline,
     * then you can call this ahead of time. Returns the raw function
     * pointer to the compiled pipeline. */
    EXPORT void *compile_jit();

    /** Set the error handler function that be called in the case of
     * runtime errors during halide pipelines. If you are compiling
     * statically, you can also just define your own function with
     * signature
     \code
     extern "C" halide_error(const char *)
     \endcode
     * This will clobber Halide's version.
     */
    EXPORT void set_error_handler(void (*handler)(const char *));

    /** Set a custom malloc and free for halide to use. Malloc should
     * return 32-byte aligned chunks of memory. If compiling
     * statically, routines with appropriate signatures can be
     * provided directly
     \code
     extern "C" void *halide_malloc(size_t)
     extern "C" void halide_free(void *)
     \endcode
     * These will clobber Halide's versions. See \file HalideRuntime.h
     * for declarations.
     */
    EXPORT void set_custom_allocator(void *(*malloc)(size_t), void (*free)(void *));

    /** Set a custom task handler to be called by the parallel for
     * loop. It is useful to set this if you want to do some
     * additional bookkeeping at the granularity of parallel
     * tasks. The default implementation does this:
     \code
     extern "C" int halide_do_task(int (*f)(int, uint8_t *), int idx, uint8_t *state) {
         return f(idx, state);
     }
     \endcode
     * If you are statically compiling, you can also just define your
     * own version of the above function, and it will clobber Halide's
     * version.
     *
     * If you're trying to use a custom parallel runtime, you probably
     * don't want to call this. See instead \ref Func::set_custom_do_par_for .
    */
    EXPORT void set_custom_do_task(int (*custom_do_task)(int (*)(int, uint8_t *), int, uint8_t *));

    /** Set a custom parallel for loop launcher. Useful if your app
     * already manages a thread pool. The default implementation is
     * equivalent to this:
     \code
     extern "C" int halide_do_par_for(int (*f)(int uint8_t *), int min, int extent, uint8_t *state) {
         int exit_status = 0;
         parallel for (int idx = min; idx < min+extent; idx++) {
             int job_status = halide_do_task(f, idx, state);
             if (job_status) exit_status = job_status;
         }
         return exit_status;
     }
     \endcode
     *
     * However, notwithstanding the above example code, if one task
     * fails, we may skip over other tasks, and if two tasks return
     * different error codes, we may select one arbitrarily to return.
     *
     * If you are statically compiling, you can also just define your
     * own version of the above function, and it will clobber Halide's
     * version.
     */
    EXPORT void set_custom_do_par_for(int (*custom_do_par_for)(int (*)(int, uint8_t *), int, int, uint8_t *));

    /** Set custom routines to call when tracing is enabled. Call this
     * on the output Func of your pipeline. This then sets custom
     * routines for the entire pipeline, not just calls to this
     * Func.
     *
     * If you are statically compiling, you can also just define your
     * own versions of the tracing functions (see HalideRuntime.h),
     * and they will clobber Halide's versions. */
    EXPORT void set_custom_trace(Internal::JITCompiledModule::TraceFn);

    /** When this function is compiled, include code that dumps its values
     * to a file after it is realized, for the purpose of debugging.
     * The file covers the realized extent at the point in the schedule that
     * debug_to_file appears.
     *
     * If filename ends in ".tif" or ".tiff" (case insensitive) the file
     * is in TIFF format and can be read by standard tools. Oherwise, the
     * file format is as follows:
     *
     * All data is in the byte-order of the target platform.  First, a
     * 20 byte-header containing four 32-bit ints, giving the extents
     * of the first four dimensions.  Dimensions beyond four are
     * folded into the fourth.  Then, a fifth 32-bit int giving the
     * data type of the function. The typecodes are given by: float =
     * 0, double = 1, uint8_t = 2, int8_t = 3, uint16_t = 4, int16_t =
     * 5, uint32_t = 6, int32_t = 7, uint64_t = 8, int64_t = 9. The
     * data follows the header, as a densely packed array of the given
     * size and the given type. If given the extension .tmp, this file
     * format can be natively read by the program ImageStack. */
    EXPORT void debug_to_file(const std::string &filename);

    /** The name of this function, either given during construction,
     * or automatically generated. */
    EXPORT const std::string &name() const;

    /** Get the pure arguments. */
    EXPORT std::vector<Var> args() const;

    /** The right-hand-side value of the pure definition of this
     * function. Causes an error if there's no pure definition, or if
     * the function is defined to return multiple values. */
    EXPORT Expr value() const;

    /** The values returned by this function. An error if the function
     * has not been been defined. Returns a Tuple with one element for
     * functions defined to return a single value. */
    EXPORT Tuple values() const;

    /** Does this function have at least a pure definition. */
    EXPORT bool defined() const;

    /** Get the left-hand-side of the reduction definition. An empty
     * vector if there's no reduction definition. */
    EXPORT const std::vector<Expr> &reduction_args() const;

    /** Get the right-hand-side of the reduction definition. An error
     * if there's no reduction definition. */
    EXPORT Expr reduction_value() const;

    /** Get the right-hand-side of the reduction definition for
     * functions that returns multiple values. An error if there's no
     * reduction definition. Returns a Tuple with one element for
     * functions that return a single value. */
    EXPORT Tuple reduction_values() const;

    /** Get the reduction domain for the reduction definition. Returns
     * an undefined RDom if there's no reduction definition. */
    EXPORT RDom reduction_domain() const;

    /** Is this function a reduction? */
    EXPORT bool is_reduction() const;

    /** Is this function external? */
    EXPORT bool is_extern() const;

    /** Add an extern definition for this Func. */
    // @{
    EXPORT void define_extern(const std::string &function_name,
                              const std::vector<ExternFuncArgument> &params,
                              Type t,
                              int dimensionality) {
        define_extern(function_name, params, Internal::vec<Type>(t), dimensionality);
    }

    EXPORT void define_extern(const std::string &function_name,
                              const std::vector<ExternFuncArgument> &params,
                              const std::vector<Type> &types,
                              int dimensionality);
    // @}

    /** Get the types of the outputs of this Func. */
    EXPORT const std::vector<Type> &output_types() const;

    /** Get the number of outputs of this Func. */
    EXPORT int outputs() const;

    /** Get the name of the extern function called for an extern
     * definition. */
    EXPORT const std::string &extern_function_name() const;

    /** The dimensionality (number of arguments) of this
     * function. Zero if the function is not yet defined. */
    EXPORT int dimensions() const;

    /** Construct either the left-hand-side of a definition, or a call
     * to a functions that happens to only contain vars as
     * arguments. If the function has already been defined, and fewer
     * arguments are given than the function has dimensions, then
     * enough implicit vars are added to the end of the argument list
     * to make up the difference (see \ref Var::implicit) */
    // @{
    EXPORT FuncRefVar operator()() const;
    EXPORT FuncRefVar operator()(Var x) const;
    EXPORT FuncRefVar operator()(Var x, Var y) const;
    EXPORT FuncRefVar operator()(Var x, Var y, Var z) const;
    EXPORT FuncRefVar operator()(Var x, Var y, Var z, Var w) const;
    EXPORT FuncRefVar operator()(Var x, Var y, Var z, Var w, Var u) const;
    EXPORT FuncRefVar operator()(Var x, Var y, Var z, Var w, Var u, Var v) const;
    EXPORT FuncRefVar operator()(std::vector<Var>) const;
    // @}

    /** Either calls to the function, or the left-hand-side of a
     * reduction definition (see \ref RDom). If the function has
     * already been defined, and fewer arguments are given than the
     * function has dimensions, then enough implicit vars are added to
     * the end of the argument list to make up the difference. (see
     * \ref Var::implicit)*/
    // @{
    EXPORT FuncRefExpr operator()(Expr x) const;
    EXPORT FuncRefExpr operator()(Expr x, Expr y) const;
    EXPORT FuncRefExpr operator()(Expr x, Expr y, Expr z) const;
    EXPORT FuncRefExpr operator()(Expr x, Expr y, Expr z, Expr w) const;
    EXPORT FuncRefExpr operator()(Expr x, Expr y, Expr z, Expr w, Expr u) const;
    EXPORT FuncRefExpr operator()(Expr x, Expr y, Expr z, Expr w, Expr u, Expr v) const;
    EXPORT FuncRefExpr operator()(std::vector<Expr>) const;
    // @}

    /** Scheduling calls that control how the domain of this function
     * is traversed. See the documentation for ScheduleHandle for the
     * meanings. */
    // @{
    EXPORT Func &split(Var old, Var outer, Var inner, Expr factor);
    EXPORT Func &fuse(Var inner, Var outer, Var fused);
    EXPORT Func &parallel(Var var);
    EXPORT Func &vectorize(Var var);
    EXPORT Func &unroll(Var var);
    EXPORT Func &vectorize(Var var, int factor);
    EXPORT Func &unroll(Var var, int factor);
    EXPORT Func &bound(Var var, Expr min, Expr extent);
    EXPORT Func &tile(Var x, Var y, Var xo, Var yo, Var xi, Var yi, Expr xfactor, Expr yfactor);
    EXPORT Func &tile(Var x, Var y, Var xi, Var yi, Expr xfactor, Expr yfactor);
    EXPORT Func &reorder(const std::vector<Var> &vars);
    EXPORT Func &reorder(Var x, Var y);
    EXPORT Func &reorder(Var x, Var y, Var z);
    EXPORT Func &reorder(Var x, Var y, Var z, Var w);
    EXPORT Func &reorder(Var x, Var y, Var z, Var w, Var t);
    EXPORT Func &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2);
    EXPORT Func &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2, Var t3);
    EXPORT Func &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2, Var t3, Var t4);
    EXPORT Func &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2, Var t3, Var t4, Var t5);
    EXPORT Func &reorder(Var x, Var y, Var z, Var w, Var t1, Var t2, Var t3, Var t4, Var t5, Var t6);
    EXPORT Func &rename(Var old_name, Var new_name);
    EXPORT Func &cuda_threads(Var thread_x);
    EXPORT Func &cuda_threads(Var thread_x, Var thread_y);
    EXPORT Func &cuda_threads(Var thread_x, Var thread_y, Var thread_z);
    EXPORT Func &cuda_blocks(Var block_x);
    EXPORT Func &cuda_blocks(Var block_x, Var block_y);
    EXPORT Func &cuda_blocks(Var block_x, Var block_y, Var block_z);
    EXPORT Func &cuda(Var block_x, Var thread_x);
    EXPORT Func &cuda(Var block_x, Var block_y,
                      Var thread_x, Var thread_y);
    EXPORT Func &cuda(Var block_x, Var block_y, Var block_z,
                      Var thread_x, Var thread_y, Var thread_z);
    EXPORT Func &cuda_tile(Var x, int x_size);
    EXPORT Func &cuda_tile(Var x, Var y,
                           int x_size, int y_size);
    EXPORT Func &cuda_tile(Var x, Var y, Var z,
                           int x_size, int y_size, int z_size);
    // @}

    /** Scheduling calls that control how the storage for the function
     * is laid out. Right now you can only reorder the dimensions. */
    // @{
    EXPORT Func &reorder_storage(Var x, Var y);
    EXPORT Func &reorder_storage(Var x, Var y, Var z);
    EXPORT Func &reorder_storage(Var x, Var y, Var z, Var w);
    EXPORT Func &reorder_storage(Var x, Var y, Var z, Var w, Var t);
    // @}

    /** Compute this function as needed for each unique value of the
     * given var for the given calling function f.
     *
     * For example, consider the simple pipeline:
     \code
     Func f, g;
     Var x, y;
     g(x, y) = x*y;
     f(x, y) = g(x, y) + g(x, y+1) + g(x+1, y) + g(x+1, y+1);
     \endcode
     *
     * If we schedule f like so:
     *
     \code
     g.compute_at(f, x);
     \endcode
     *
     * Then the C code equivalent to this pipeline will look like this
     *
     \code

     int f[height][width];
     for (int y = 0; y < height; y++) {
         for (int x = 0; x < width; x++) {
             int g[2][2];
             g[0][0] = x*y;
             g[0][1] = (x+1)*y;
             g[1][0] = x*(y+1);
             g[1][1] = (x+1)*(y+1);
             f[y][x] = g[0][0] + g[1][0] + g[0][1] + g[1][1];
         }
     }

     \endcode
     *
     * The allocation and computation of g is within f's loop over x,
     * and enough of g is computed to satisfy all that f will need for
     * that iteration. This has excellent locality - values of g are
     * used as soon as they are computed, but it does redundant
     * work. Each value of g ends up getting computed four times. If
     * we instead schedule f like so:
     *
     \code
     g.compute_at(f, y);
     \endcode
     *
     * The equivalent C code is:
     *
     \code
     int f[height][width];
     for (int y = 0; y < height; y++) {
         int g[2][width+1];
         for (int x = 0; x < width; x++) {
             g[0][x] = x*y;
             g[1][x] = x*(y+1);
         }
         for (int x = 0; x < width; x++) {
             f[y][x] = g[0][x] + g[1][x] + g[0][x+1] + g[1][x+1];
         }
     }
     \endcode
     *
     * The allocation and computation of g is within f's loop over y,
     * and enough of g is computed to satisfy all that f will need for
     * that iteration. This does less redundant work (each point in g
     * ends up being evaluated twice), but the locality is not quite
     * as good, and we have to allocate more temporary memory to store
     * g.
     */
    EXPORT Func &compute_at(Func f, Var var);

    /** Schedule a function to be computed within the iteration over
     * some dimension of a reduction domain. Produces equivalent code
     * to the version of compute_at that takes a Var. */
    EXPORT Func &compute_at(Func f, RVar var);

    /** Compute all of this function once ahead of time. Reusing
     * the example in \ref Func::compute_at :
     *
     \code
     Func f, g;
     Var x, y;
     g(x, y) = x*y;
     f(x, y) = g(x, y) + g(x, y+1) + g(x+1, y) + g(x+1, y+1);

     g.compute_root();
     \endcode
     *
     * is equivalent to
     *
     \code
     int f[height][width];
     int g[height+1][width+1];
     for (int y = 0; y < height+1; y++) {
         for (int x = 0; x < width+1; x++) {
             g[y][x] = x*y;
         }
     }
     for (int y = 0; y < height; y++) {
         for (int x = 0; x < width; x++) {
             f[y][x] = g[y][x] + g[y+1][x] + g[y][x+1] + g[y+1][x+1];
         }
     }
     \endcode
     *
     * g is computed once ahead of time, and enough is computed to
     * satisfy all uses of it. This does no redundant work (each point
     * in g is evaluated once), but has poor locality (values of g are
     * probably not still in cache when they are used by f), and
     * allocates lots of temporary memory to store g.
     */
    EXPORT Func &compute_root();

    /** Allocate storage for this function within f's loop over
     * var. Scheduling storage is optional, and can be used to
     * separate the loop level at which storage occurs from the loop
     * level at which computation occurs to trade off between locality
     * and redundant work. This can open the door for two types of
     * optimization.
     *
     * Consider again the pipeline from \ref Func::compute_at :
     \code
     Func f, g;
     Var x, y;
     g(x, y) = x*y;
     f(x, y) = g(x, y) + g(x+1, y) + g(x, y+1) + g(x+1, y+1);
     \endcode
     *
     * If we schedule it like so:
     *
     \code
     g.compute_at(f, x).store_at(f, y);
     \endcode
     *
     * Then the computation of g takes place within the loop over x,
     * but the storage takes place within the loop over y:
     *
     \code
     int f[height][width];
     for (int y = 0; y < height; y++) {
         int g[2][width+1];
         for (int x = 0; x < width; x++) {
             g[0][x] = x*y;
             g[0][x+1] = (x+1)*y;
             g[1][x] = x*(y+1);
             g[1][x+1] = (x+1)*(y+1);
             f[y][x] = g[0][x] + g[1][x] + g[0][x+1] + g[1][x+1];
         }
     }
     \endcode
     *
     * Provided the for loop over x is serial, halide then
     * automatically performs the following sliding window
     * optimization:
     *
     \code
     int f[height][width];
     for (int y = 0; y < height; y++) {
         int g[2][width+1];
         for (int x = 0; x < width; x++) {
             if (x == 0) {
                 g[0][x] = x*y;
                 g[1][x] = x*(y+1);
             }
             g[0][x+1] = (x+1)*y;
             g[1][x+1] = (x+1)*(y+1);
             f[y][x] = g[0][x] + g[1][x] + g[0][x+1] + g[1][x+1];
         }
     }
     \endcode
     *
     * Two of the assignments to g only need to be done when x is
     * zero. The rest of the time, those sites have already been
     * filled in by a previous iteration. This version has the
     * locality of compute_at(f, x), but allocates more memory and
     * does much less redundant work.
     *
     * Halide then further optimizes this pipeline like so:
     *
     \code
     int f[height][width];
     for (int y = 0; y < height; y++) {
         int g[2][2];
         for (int x = 0; x < width; x++) {
             if (x == 0) {
                 g[0][0] = x*y;
                 g[1][0] = x*(y+1);
             }
             g[0][(x+1)%2] = (x+1)*y;
             g[1][(x+1)%2] = (x+1)*(y+1);
             f[y][x] = g[0][x%2] + g[1][x%2] + g[0][(x+1)%2] + g[1][(x+1)%2];
         }
     }
     \endcode
     *
     * Halide has detected that it's possible to use a circular buffer
     * to represent g, and has reduced all accesses to g modulo 2 in
     * the x dimension. This optimization only triggers if the for
     * loop over x is serial, and if halide can statically determine
     * some power of two large enough to cover the range needed. For
     * powers of two, the modulo operator compiles to more efficient
     * bit-masking. This optimization reduces memory usage, and also
     * improves locality by reusing recently-accessed memory instead
     * of pulling new memory into cache.
     *
     */
    EXPORT Func &store_at(Func f, Var var);

    /** Equivalent to the version of store_at that takes a Var, but
     * schedules storage within the loop over a dimension of a
     * reduction domain */
    EXPORT Func &store_at(Func f, RVar var);

    /** Equivalent to \ref Func::store_at, but schedules storage
     * outside the outermost loop. */
    EXPORT Func &store_root();

    /** Aggressively inline all uses of this function. This is the
     * default schedule, so you're unlikely to need to call this. For
     * a reduction, that means it gets computed as close to the
     * innermost loop as possible.
     *
     * Consider once more the pipeline from \ref Func::compute_at :
     *
     \code
     Func f, g;
     Var x, y;
     g(x, y) = x*y;
     f(x, y) = g(x, y) + g(x+1, y) + g(x, y+1) + g(x+1, y+1);
     \endcode
     *
     * Leaving g as inline, this compiles to code equivalent to the following C:
     *
     \code
     int f[height][width];
     for (int y = 0; y < height; y++) {
         for (int x = 0; x < width; x++) {
             f[y][x] = x*y + x*(y+1) + (x+1)*y + (x+1)*(y+1);
         }
     }
     \endcode
     */
    EXPORT Func &compute_inline();

    /** Get a handle on the update step of a reduction for the
     * purposes of scheduling it. Only the pure dimensions of the
     * update step can be meaningfully manipulated (see \ref RDom) */
    EXPORT ScheduleHandle update();

    /** Trace all loads from this Func by emitting calls to
     * halide_trace_load. If the Func is inlined, this has no
     * effect. */
    EXPORT Func &trace_loads();

    /** Trace all stores to the buffer backing this Func by emitting
     * calls to halide_trace_store. If the Func is inlined, this call
     * has no effect. */
    EXPORT Func &trace_stores();

    /** Trace all realizations of this Func by emitting calls to
     * halide_trace_produce, halide_trace_update,
     * halide_trace_consume, and halide_trace_dispose. */
    EXPORT Func &trace_realizations();

    /** Get a handle on the internal halide function that this Func
     * represents. Useful if you want to do introspection on Halide
     * functions */
    Internal::Function function() const {
        return func;
    }

    /** Get a handle on the output buffer for this Func. Only relevant
     * if this is the output Func in a pipeline. Useful for making
     * static promises about strides, mins, and extents. */
    // @{
    EXPORT OutputImageParam output_buffer() const;
    EXPORT std::vector<OutputImageParam> output_buffers() const;
    // @}

    /** Casting a function to an expression is equivalent to calling
     * the function with zero arguments. Implicit variables will be
     * injected according to the function's dimensionality
     * (see \ref Var::implicit).
     *
     * This lets you write things like:
     *
     \code
     Func f, g;
     Var x;
     g(x) = ...
     f(_) = g * 2;
     \endcode
    */
    operator Expr() const {
        return (*this)(_);
    }

    /** Use a Func as an argument to an external stage. */
    operator ExternFuncArgument() const {
        return ExternFuncArgument(func);
    }

};

/** JIT-Compile and run enough code to evaluate a Halide
 * expression. This can be thought of as a scalar version of
 * \ref Func::realize */
template<typename T>
T evaluate(Expr e) {
    assert(e.type() == type_of<T>());
    Func f;
    f(_) = e;
    Image<T> im = f.realize();
    return im(0);
}

/** JIT-compile and run enough code to evaluate a Halide Tuple. */
// @{
template<typename A, typename B>
void evaluate(Tuple t, A *a, B *b) {
    assert(t[0].type() == type_of<A>());
    assert(t[1].type() == type_of<B>());
    Func f;
    f(_) = t;
    Realization r = f.realize();
    *a = Image<A>(r[0])(0);
    *b = Image<B>(r[1])(0);
}

template<typename A, typename B, typename C>
void evaluate(Tuple t, A *a, B *b, C *c) {
    assert(t[0].type() == type_of<A>());
    assert(t[1].type() == type_of<B>());
    assert(t[2].type() == type_of<C>());
    Func f;
    f(_) = t;
    Realization r = f.realize();
    *a = Image<A>(r[0])(0);
    *b = Image<B>(r[1])(0);
    *c = Image<C>(r[2])(0);
}

template<typename A, typename B, typename C, typename D>
void evaluate(Tuple t, A *a, B *b, C *c, D *d) {
    assert(t[0].type() == type_of<A>());
    assert(t[1].type() == type_of<B>());
    assert(t[2].type() == type_of<C>());
    assert(t[3].type() == type_of<D>());
    Func f;
    f(_) = t;
    Realization r = f.realize();
    *a = Image<A>(r[0])(0);
    *b = Image<B>(r[1])(0);
    *c = Image<C>(r[2])(0);
    *d = Image<D>(r[3])(0);
}
// @}

}


#endif

namespace Halide { 
namespace Internal {

/** A code generator that emits GPU code from a given Halide stmt. */
struct CodeGen_GPU_Dev {
    virtual ~CodeGen_GPU_Dev();

    /** Compile a GPU kernel into the module. This may be called many times 
     * with different kernels, which will all be accumulated into a single 
     * source module shared by a given Halide pipeline. */
    virtual void compile(Stmt stmt, std::string name, const std::vector<Argument> &args) = 0;

    /** (Re)initialize the GPU kernel module. This is separate from compile,
     * since a GPU device module will often have many kernels compiled into it
     * for a single pipeline. */
    virtual void init_module() = 0;

    virtual std::string compile_to_src() = 0;

    virtual std::string get_current_kernel_name() = 0;

    virtual void dump() = 0;

    static bool is_gpu_var(const std::string &name);
};

}}

#endif

namespace Halide {
namespace Internal {

/** A code generator that emits GPU code from a given Halide stmt. */
class CodeGen_GPU_Host : public CodeGen_X86 {
public:

    /** Create a GPU code generator. GPU target is selected via
     * CodeGen_GPU_Options. Processor features can be enabled using the
     * appropriate flags from CodeGen_X86_Options */
    CodeGen_GPU_Host(Target);

    virtual ~CodeGen_GPU_Host();

    /** Compile to an internally-held llvm module. Takes a halide
     * statement, the name of the function produced, and the arguments
     * to the function produced. After calling this, call
     * CodeGen::compile_to_file or
     * CodeGen::compile_to_function_pointer to get at the x86 machine
     * code. */
    void compile(Stmt stmt, std::string name, const std::vector<Argument> &args);

protected:
    using CodeGen_X86::visit;

    class Closure;

    /** Nodes for which we need to override default behavior for the GPU runtime */
    // @{
    void visit(const For *);
    void visit(const Allocate *);
    void visit(const Free *);
    void visit(const Pipeline *);
    void visit(const Call *);
    // @}

    // We track buffer_t's for each allocation in order to manage dirty bits
    bool track_buffers() {return true;}

    //** Runtime function handles */
    // @{
    llvm::Function *dev_malloc_fn;
    llvm::Function *dev_free_fn;
    llvm::Function *copy_to_dev_fn;
    llvm::Function *copy_to_host_fn;
    llvm::Function *dev_run_fn;
    llvm::Function *dev_sync_fn;
    // @}

    /** Finds and links in the CUDA runtime symbols prior to jitting */
    void jit_init(llvm::ExecutionEngine *ee, llvm::Module *mod);

    /** Reaches inside the module at sets it to use a single shared
     * cuda context */
    void jit_finalize(llvm::ExecutionEngine *ee, llvm::Module *mod, std::vector<void (*)()> *cleanup_routines);

    static bool lib_cuda_linked;

    static CodeGen_GPU_Dev* make_dev(Target);

private:
    /** Child code generator for device kernels. */
    CodeGen_GPU_Dev *cgdev;
};

}}

#endif
#ifndef HALIDE_CODEGEN_PTX_DEV_H
#define HALIDE_CODEGEN_PTX_DEV_H

/** \file
 * Defines the code-generator for producing CUDA host code
 */


namespace llvm {
class BasicBlock;
}

namespace Halide { 
namespace Internal {

/** A code generator that emits GPU code from a given Halide stmt. */
class CodeGen_PTX_Dev : public CodeGen, public CodeGen_GPU_Dev {
public:
    friend class CodeGen_GPU_Host;

    /** Create a PTX device code generator. */
    CodeGen_PTX_Dev();
        
    void compile(Stmt stmt, std::string name, const std::vector<Argument> &args);

    /** (Re)initialize the PTX module. This is separate from compile, since 
     * a PTX device module will often have many kernels compiled into it for
     * a single pipeline. */
    void init_module();

    static void test();

    std::string compile_to_src();
    std::string get_current_kernel_name();

    void dump();

protected:
    using CodeGen::visit;

    /** We hold onto the basic block at the start of the device
     * function in order to inject allocas */
    llvm::BasicBlock *entry_block;

    /** Nodes for which we need to override default behavior for the GPU runtime */
    // @{
    void visit(const For *);
    void visit(const Allocate *);
    void visit(const Free *);
    void visit(const Pipeline *);
    // @}

    std::string march() const;
    std::string mcpu() const;
    std::string mattrs() const;
    bool use_soft_float_abi() const;

    /** Map from simt variable names (e.g. foo.blockidx) to the llvm
     * ptx intrinsic functions to call to get them. */
    std::string simt_intrinsic(const std::string &name);
};

}}

#endif
#ifndef HALIDE_CODEGEN_OPENCL_DEV_H
#define HALIDE_CODEGEN_OPENCL_DEV_H

/** \file
 * Defines the code-generator for producing OpenCL C kernel code
 */


namespace Halide { 
namespace Internal {

class CodeGen_OpenCL_Dev : public CodeGen_GPU_Dev {
public:
    CodeGen_OpenCL_Dev();

    /** Compile a GPU kernel into the module. This may be called many times 
     * with different kernels, which will all be accumulated into a single 
     * source module shared by a given Halide pipeline. */
    void compile(Stmt stmt, std::string name, const std::vector<Argument> &args);

    /** (Re)initialize the GPU kernel module. This is separate from compile,
     * since a GPU device module will often have many kernels compiled into it
     * for a single pipeline. */
    void init_module();

    std::string compile_to_src();

    std::string get_current_kernel_name();

    void dump();

protected:

    class CodeGen_OpenCL_C : public CodeGen_C {
    public:
        CodeGen_OpenCL_C(std::ostream &s) : CodeGen_C(s) {}
        void compile(Stmt stmt, std::string name, const std::vector<Argument> &args);
        
    protected:
        using CodeGen_C::visit;
        std::string print_type(Type type);
        
        void visit(const For *);
    };
    
    CodeGen_OpenCL_C *clc;
    
    std::ostringstream src_stream;
    
    std::string cur_kernel_name;
};

}}

#endif
#ifndef DEINTERLEAVE_H
#define DEINTERLEAVE_H

/** \file 
 * 
 * Defines methods for splitting up a vector into the even lanes and
 * the odd lanes. Useful for optimizing expressions such as select(x %
 * 2, f(x/2), g(x/2))
 */

#include <utility>

namespace Halide {
namespace Internal {

/** Extract the odd-numbered lanes in a vector */
Expr extract_odd_lanes(Expr a);

/** Extract the even-numbered lanes in a vector */
Expr extract_even_lanes(Expr a);

/** Extract the nth lane of a vector */
Expr extract_lane(Expr vec, int lane);

/** Look through a statement for expressions of the form select(ramp %
 * 2 == 0, a, b) and replace them with calls to an interleave
 * intrinsic */
Stmt rewrite_interleavings(Stmt s);

void deinterleave_vector_test();

}
}

#endif
#ifndef HALIDE_DERIVATIVE_H
#define HALIDE_DERIVATIVE_H

/** \file
 *
 * Methods for taking derivatives of halide expressions. Not currently used anywhere
 */

#include <string>

namespace Halide {
namespace Internal {

/** Compute the analytic derivative of the expression with respect to
 * the variable. May returned an undefined Expr if it's
 * non-differentiable. */
//Expr derivative(Expr expr, const string &var);

/**
 * Compute the finite difference version of the derivative:
 * expr(var+1) - expr(var). The reason to do this as a derivative,
 * instead of just explicitly constructing expr(var+1) -
 * expr(var), is so that we don't have to do so much
 * simplification later. For example, the finite-difference
 * derivative of 2*x is trivially 2, whereas 2*(x+1) - 2*x may or
 * may not simplify down to 2, depending on the quality of our
 * simplification routine.
 *
 * Most rules for the finite difference and the true derivative
 * are the same. The quotient and product rules are not.
 *
 */
Expr finite_difference(Expr expr, const std::string &var);

/**
 * Detect whether an expression is monotonic increasing in a variable,
 * decreasing, or unknown. Returns -1, 0, or 1 for decreasing,
 * unknown, and increasing.
 */
enum MonotonicResult {Constant, MonotonicIncreasing, MonotonicDecreasing, Unknown};
MonotonicResult is_monotonic(Expr e, const std::string &var);

}
}

#endif
#ifndef HALIDE_ONE_TO_ONE_H
#define HALIDE_ONE_TO_ONE_H

/** \file
 * 
 * Methods for determining if an Expr represents a one-to-one function
 * in its Variables.
 */


namespace Halide { 
namespace Internal {
    
/** Conservatively determine whether an integer expression is
 * one-to-one in its variables. For now this means it contains a
 * single variable and its derivative is provably strictly positive or
 * strictly negative. */
bool is_one_to_one(Expr expr);

void is_one_to_one_test();

}
}

#endif
#ifndef HALIDE_EXTERN_H
#define HALIDE_EXTERN_H

/** \file
 *
 * Convenience macros that lift functions that take C types into
 * functions that take and return exprs, and call the original
 * function at runtime under the hood. See test/c_function.cpp for
 * example usage.
 */

#define HalideExtern_1(rt, name, t1)                                    \
    Halide::Expr name(Halide::Expr a1) {                                \
        assert(a1.type() == Halide::type_of<t1>() && "Type mismatch for argument 1 of " #name); \
        return Halide::Internal::Call::make(Halide::type_of<rt>(), #name, vec(a1), Halide::Internal::Call::Extern); \
    }

#define HalideExtern_2(rt, name, t1, t2)                                \
    Halide::Expr name(Halide::Expr a1, Halide::Expr a2) {               \
        assert(a1.type() == Halide::type_of<t1>() && "Type mismatch for argument 1 of " #name); \
        assert(a2.type() == Halide::type_of<t2>() && "Type mismatch for argument 2 of " #name); \
        return Halide::Internal::Call::make(Halide::type_of<rt>(), #name, vec(a1, a2), Halide::Internal::Call::Extern); \
    }

#define HalideExtern_3(rt, name, t1, t2, t3)                            \
    Halide::Expr name(Halide::Expr a1, Halide::Expr a2, Halide::Expr a3) { \
        assert(a1.type() == Halide::type_of<t1>() && "Type mismatch for argument 1 of " #name); \
        assert(a2.type() == Halide::type_of<t2>() && "Type mismatch for argument 2 of " #name); \
        assert(a3.type() == Halide::type_of<t3>() && "Type mismatch for argument 3 of " #name); \
        return Halide::Internal::Call::make(Halide::type_of<rt>(), #name, vec(a1, a2, a3), Halide::Internal::Call::Extern); \
    }

#define HalideExtern_4(rt, name, t1, t2, t3, t4)                        \
    Halide::Expr name(Halide::Expr a1, Halide::Expr a2, Halide::Expr a3, Halide::Expr a4) { \
        assert(a1.type() == Halide::type_of<t1>() && "Type mismatch for argument 1 of " #name); \
        assert(a2.type() == Halide::type_of<t2>() && "Type mismatch for argument 2 of " #name); \
        assert(a3.type() == Halide::type_of<t3>() && "Type mismatch for argument 3 of " #name); \
        assert(a4.type() == Halide::type_of<t4>() && "Type mismatch for argument 4 of " #name); \
        return Halide::Internal::Call::make(Halide::type_of<rt>(), #name, vec(a1, a2, a3, a4), Halide::Internal::Call::Extern); \
  }

#define HalideExtern_5(rt, name, t1, t2, t3, t4, t5)                       \
    Halide::Expr name(Halide::Expr a1, Halide::Expr a2, Halide::Expr a3, Halide::Expr a4, Halide::Expr a5) { \
        assert(a1.type() == Halide::type_of<t1>() && "Type mismatch for argument 1 of " #name); \
        assert(a2.type() == Halide::type_of<t2>() && "Type mismatch for argument 2 of " #name); \
        assert(a3.type() == Halide::type_of<t3>() && "Type mismatch for argument 3 of " #name); \
        assert(a4.type() == Halide::type_of<t4>() && "Type mismatch for argument 4 of " #name); \
        assert(a5.type() == Halide::type_of<t5>() && "Type mismatch for argument 5 of " #name); \
        return Halide::Internal::Call::make(Halide::type_of<rt>(), #name, vec(a1, a2, a3, a4, a5), Halide::Internal::Call::Extern); \
  }

#endif
#ifndef HALIDE_INLINE_REDUCTIONS_H
#define HALIDE_INLINE_REDUCTIONS_H


/** \file
 * Defines some inline reductions: sum, product, minimum, maximum.
 */
namespace Halide {

/** An inline reduction. This is suitable for convolution-type
 * operations - the reduction will be computed in the innermost loop
 * that it is used in. The argument may contain free or implicit
 * variables, and must refer to some reduction domain. The free
 * variables are still free in the return value, but the reduction
 * domain is captured - the result expression does not refer to a
 * reduction domain and can be used in a pure function definition.
 *
 * An example:
 *
 \code
 Func f, g;
 Var x;
 RDom r(0, 10);
 f(x) = x*x;
 g(x) = sum(f(x + r));
 \endcode
 *
 * Here g computes some blur of x, but g is still a pure function. The
 * sum is being computed by an anonymous reduction function that is
 * scheduled innermost within g.
 */
//@{
EXPORT Expr sum(Expr);
EXPORT Expr product(Expr);
EXPORT Expr maximum(Expr);
EXPORT Expr minimum(Expr);
EXPORT Expr sum(Expr, const std::string &);
EXPORT Expr product(Expr, const std::string &);
EXPORT Expr maximum(Expr, const std::string &);
EXPORT Expr minimum(Expr, const std::string &);
//@}

/** Returns an Expr or Tuple representing the coordinates of the point
 * in the RDom which minimizes or maximizes the expression. The
 * expression must refer to some RDom. Also returns the extreme value
 * of the expression as the last element of the tuple. */
// @{
EXPORT Tuple argmax(Expr);
EXPORT Tuple argmin(Expr);
EXPORT Tuple argmax(Expr, const std::string &);
EXPORT Tuple argmin(Expr, const std::string &);
// @}

}

#endif
/** \file 
 * Tables telling us how to do integer division
 * via fixed-point multiplication for various small
 * constants. This file is automatically generated
 * by find_inverse.c
 */
namespace Halide {
namespace Internal {
namespace IntegerDivision {

extern int64_t table_u8[254][3];
extern int64_t table_s8[254][3];
extern int64_t table_u16[254][3];
extern int64_t table_s16[254][3];
extern int64_t table_u32[254][3];
extern int64_t table_s32[254][3];

}
}
}
#ifndef HALIDE_IR_EQUALITY_H
#define HALIDE_IR_EQUALITY_H

/** \file
 * Methods to test Exprs and Stmts for equality of value
 */


namespace Halide { 
namespace Internal {

/** Compare IR nodes for equality of value. Traverses entire IR
 * tree. For equality of reference, use Expr::same_as */
// @{
EXPORT bool equal(Expr a, Expr b);
EXPORT bool equal(Stmt a, Stmt b);
// @}

/** Computes a lexical ordering on IR nodes. Returns -1 if the first
 * expression is before the second, 0 if they're equal, and 1 if the
 * first expression is after the second. */
// @{
EXPORT int deep_compare(Expr a, Expr b);
EXPORT int deep_compare(Stmt a, Stmt b);
// @}

/** A compare struct suitable for use in std::map and std::set that
 * uses the ordering defined by deep_compare. */
struct ExprDeepCompare {
    bool operator()(const Expr &a, const Expr &b) {
        return deep_compare(a, b) < 0;
    }
};

/** A compare struct suitable for use in std::map and std::set that
 * uses the ordering defined by deep_compare. */
struct StmtDeepCompare {
    bool operator()(const Stmt &a, const Stmt &b) {
        return deep_compare(a, b) < 0;
    }
};

}
}

#endif
#ifndef HALIDE_IR_MATCH_H
#define HALIDE_IR_MATCH_H

/** \file
 * Defines a method to match a fragment of IR against a pattern containing wildcards 
 */

#include <vector>

namespace Halide { 
namespace Internal {

/** Does the first expression have the same structure as the second?
 * Variables in the first expression with the name * are interpreted
 * as wildcards, and their matching equivalent in the second
 * expression is placed in the vector give as the third argument.
 *
 * For example:
 \code
 Expr x = new Variable(Int(32), "*");
 match(x + x, 3 + (2*k), result) 
 \endcode
 * should return true, and set result[0] to 3 and
 * result[1] to 2*k.
 */

bool expr_match(Expr pattern, Expr expr, std::vector<Expr> &result);
void expr_match_test();

}
}

#endif
#ifndef HALIDE_IR_MUTATOR_H
#define HALIDE_IR_MUTATOR_H

/** \file
 * Defines a base class for passes over the IR that modify it
 */


#include <vector>
#include <utility>

namespace Halide {
namespace Internal {

/** A base class for passes over the IR which modify it
 * (e.g. replacing a variable with a value (Substitute.h), or
 * constant-folding).
 *
 * Your mutate should override the visit methods you can about. Return
 * the new expression by assigning to expr or stmt. The default ones
 * recursively mutate their children. To mutate sub-expressions and
 * sub-statements you should the mutate method, which will dispatch to
 * the appropriate visit method and then return the value of expr or
 * stmt after the call to visit.
 */
class IRMutator : public IRVisitor {
public:

    /** This is the main interface for using a mutator. Also call
     * these in your subclass to mutate sub-expressions and
     * sub-statements.
     */
    virtual Expr mutate(Expr expr);
    virtual Stmt mutate(Stmt stmt);

protected:

    /** visit methods that take Exprs assign to this to return their
     * new value */
    Expr expr;

    /** visit methods that take Stmts assign to this to return their
     * new value */
    Stmt stmt;

    virtual void visit(const IntImm *);
    virtual void visit(const FloatImm *);
    virtual void visit(const StringImm *);
    virtual void visit(const Cast *);
    virtual void visit(const Variable *);
    virtual void visit(const Add *);
    virtual void visit(const Sub *);
    virtual void visit(const Mul *);
    virtual void visit(const Div *);
    virtual void visit(const Mod *);
    virtual void visit(const Min *);
    virtual void visit(const Max *);
    virtual void visit(const EQ *);
    virtual void visit(const NE *);
    virtual void visit(const LT *);
    virtual void visit(const LE *);
    virtual void visit(const GT *);
    virtual void visit(const GE *);
    virtual void visit(const And *);
    virtual void visit(const Or *);
    virtual void visit(const Not *);
    virtual void visit(const Select *);
    virtual void visit(const Load *);
    virtual void visit(const Ramp *);
    virtual void visit(const Broadcast *);
    virtual void visit(const Call *);
    virtual void visit(const Let *);
    virtual void visit(const LetStmt *);
    virtual void visit(const AssertStmt *);
    virtual void visit(const Pipeline *);
    virtual void visit(const For *);
    virtual void visit(const Store *);
    virtual void visit(const Provide *);
    virtual void visit(const Allocate *);
    virtual void visit(const Free *);
    virtual void visit(const Realize *);
    virtual void visit(const Block *);
    virtual void visit(const IfThenElse *);
    virtual void visit(const Evaluate *);
};

}
}

#endif
#ifndef HALIDE_LAMBDA_H
#define HALIDE_LAMBDA_H


/** \file
 * Convenience functions for creating small anonymous Halide
 * functions. See test/lambda.cpp for example usage. */

namespace Halide {

/** Create a zero-dimensional halide function that returns the given
 * expression. The function may have more dimensions if the expression
 * contains implicit arguments. */
inline Func lambda(Expr e) {
    Func f("lambda" + Internal::unique_name('_'));
    f(_) = e;
    return f;
}

/** Create a 1-D halide function in the first argument that returns
 * the second argument. The function may have more dimensions if the
 * expression contains implicit arguments and the list of Var
 * arguments contains a placeholder ("_"). */
inline Func lambda(Var x, Expr e) {
    Func f("lambda" + Internal::unique_name('_'));
    f(x) = e;
    return f;
}

/** Create a 2-D halide function in the first two arguments that
 * returns the last argument. The function may have more dimensions if
 * the expression contains implicit arguments and the list of Var
 * arguments contains a placeholder ("_"). */
inline Func lambda(Var x, Var y, Expr e) {
    Func f("lambda" + Internal::unique_name('_'));
    f(x, y) = e;
    return f;
}

/** Create a 3-D halide function in the first three arguments that
 * returns the last argument.  The function may have more dimensions
 * if the expression contains implicit arguments and the list of Var
 * arguments contains a placeholder ("_"). */
inline Func lambda(Var x, Var y, Var z, Expr e) {
    Func f("lambda" + Internal::unique_name('_'));
    f(x, y, z) = e;
    return f;
}

/** Create a 4-D halide function in the first four arguments that
 * returns the last argument. The function may have more dimensions if
 * the expression contains implicit arguments and the list of Var
 * arguments contains a placeholder ("_"). */
inline Func lambda(Var x, Var y, Var z, Var w, Expr e) {
    Func f("lambda" + Internal::unique_name('_'));
    f(x, y, z, w) = e;
    return f;
}

/** Create a 5-D halide function in the first five arguments that
 * returns the last argument. The function may have more dimensions if
 * the expression contains implicit arguments and the list of Var
 * arguments contains a placeholder ("_"). */
inline Func lambda(Var x, Var y, Var z, Var w, Var v, Expr e) {
    Func f("lambda" + Internal::unique_name('_'));
    f(x, y, z, w, v) = e;
    return f;
}

}

#endif //HALIDE_LAMBDA_H
#ifndef HALIDE_INTERNAL_LOWER_H
#define HALIDE_INTERNAL_LOWER_H

/** \file
 *
 * Defines the function that generates a statement that computes a
 * Halide function using its schedule.
 */


namespace Halide {
namespace Internal {

/** Given a halide function with a schedule, create a statement that
 * evaluates it. Automatically pulls in all the functions f depends
 * on */
Stmt lower(Function f);

void lower_test();

}
}

#endif
/** \file
 * This file only exists to contain the front-page of the documentation 
 */

/** \mainpage Halide
 *
 * Introductory documentation and tutorials are coming shortly. For now
 * look in the test folder for many small examples that use halide's
 * jit-compilation functionality, and look in the apps folder for
 * larger examples that statically compile halide pipelines. 
 *
 * Below are links to the documentation for the important classes in Halide.
 *
 * For defining, scheduling, and evaluating basic pipelines:
 *
 * Halide::Func, Halide::Var
 * 
 * Our image data type:
 *
 * Halide::Image
 * 
 * For passing around and reusing halide expressions:
 * 
 * Halide::Expr
 * 
 * For representing scalar and image parameters to pipelines:
 *
 * Halide::Param, Halide::ImageParam
 *
 * For writing functions that reduce or scatter over some domain:
 *
 * Halide::RDom
 * 
 */
#ifndef HALIDE_REMOVE_TRIVIAL_FOR_LOOPS_H
#define HALIDE_REMOVE_TRIVIAL_FOR_LOOPS_H

/** \file
 * Defines the lowering pass removes for loops of size 1
 */


namespace Halide {
namespace Internal {

/** Convert for loops of size 1 into LetStmt nodes, which allows for
 * further simplification. Done during a late stage of lowering. */
Stmt remove_trivial_for_loops(Stmt s);

}
}

#endif
#ifndef HALIDE_SIMPLIFY_H
#define HALIDE_SIMPLIFY_H

/** \file
 * Methods for simplifying halide statements and expressions 
 */

#include <cmath>

namespace Halide { 
namespace Internal {

/** Perform a a wide range of simplifications to expressions and
 * statements, including constant folding, substituting in trivial
 * values, arithmetic rearranging, etc.
 */
// @{
Stmt simplify(Stmt);
EXPORT Expr simplify(Expr);
// @}     
   
/** Implementations of division and mod that are specific to Halide.
 * Use these implementations; do not use native C division or mod to simplify
 * Halide expressions. */
template<typename T>
inline T mod_imp(T a, T b) {
    T rem = a % b;
    Type t = type_of<T>();
    if (t.is_int()) {
        rem = rem + (rem != 0 && (rem ^ b) < 0 ? b : 0);
    }
    return rem;
}
// Special cases for float, double.
template<> inline float mod_imp<float>(float a, float b) { 
    float f = a - b * (floorf(a / b));
    // The remainder has the same sign as b.
    return f; 
}
template<> inline double mod_imp<double>(double a, double b) {
    double f = a - b * (std::floor(a / b));
    return f; 
}

// Division that rounds the quotient down for integers.
template<typename T>
inline T div_imp(T a, T b) {
    Type t = type_of<T>();
    T quotient;
    if (t.is_int()) {
        T axorb = a ^ b;
        T post = a != 0 ? ((axorb) >> (t.bits-1)) : 0;
        T pre = a < 0 ? -post : post;
        T num = a + pre;
        T q = num / b;
        quotient = q + post;
    } else {
        quotient = a / b;
    }
    return quotient; 
}

void simplify_test();

}
}

#endif
#ifndef HALIDE_SLIDING_WINDOW_H
#define HALIDE_SLIDING_WINDOW_H

/** \file
 *
 * Defines the sliding_window lowering optimization pass, which avoids
 * computing provably-already-computed values.
 */

#include <map>

namespace Halide {
namespace Internal {

/** Perform sliding window optimizations on a halide
 * statement. I.e. don't bother computing points in a function that
 * have provably already been computed by a previous iteration.
 */
Stmt sliding_window(Stmt s, const std::map<std::string, Function> &env);

}
}

#endif
#ifndef HALIDE_STMT_COMPILER_H
#define HALIDE_STMT_COMPILER_H

/** \file
 * Defines a compiler that produces native code from halide statements
 */


#include <string>
#include <vector>

namespace Halide {

namespace Internal {


/** A handle to a generic statement compiler. Can take Halide
 * statements and turn them into assembly, bitcode, machine code, or a
 * jit-compiled module. */
class CodeGen;
class StmtCompiler {
    IntrusivePtr<CodeGen> contents;
public:

    /** Build a code generator for the given target. */
    StmtCompiler(Target target);

    /** Compile a statement to an llvm module of the given name with
     * the given toplevel arguments. The module is stored internally
     * until one of the later functions is called: */
    void compile(Stmt stmt, std::string name, const std::vector<Argument> &args);

    /** Write the module to an llvm bitcode file */
    void compile_to_bitcode(const std::string &filename);

    /** Compile and write the module to either a binary object file,
     * or as assembly */
    void compile_to_native(const std::string &filename, bool assembly = false);

    /** Return a function pointer with type given by the vector of
     * Arguments passed to compile. Also returns a wrapped version of
     * the function, which is a single-argument function that takes an
     * array of void * (i.e. a void **). Each entry in this array
     * either points to a buffer_t, or to a scalar of the type
     * specified by the argument list.
     *
     * Also returns various other useful functions within the module,
     * such as a hook for setting the function to call when an assert
     * fails.
     */
    JITCompiledModule compile_to_function_pointers();
};

}
}



#endif
#ifndef HALIDE_STORAGE_FLATTENING_H
#define HALIDE_STORAGE_FLATTENING_H

/** \file
 * Defines the lowering pass that flattens multi-dimensional storage
 * into single-dimensional array access
 */

#include <map>

namespace Halide {
namespace Internal {

/** Take a statement with multi-dimensional Realize, Provide, and Call
 * nodes, and turn it into a statement with single-dimensional
 * Allocate, Store, and Load nodes respectively. */
Stmt storage_flattening(Stmt s, const std::map<std::string, Function> &env);

}
}

#endif
#ifndef HALIDE_STORAGE_FOLDING_H
#define HALIDE_STORAGE_FOLDING_H

/** \file
 * Defines the lowering optimization pass that reduces large buffers
 * down to smaller circular buffers when possible
 */


namespace Halide {
namespace Internal {

/** Fold storage of functions if possible. This means reducing one of
 * the dimensions module something for the purpose of storage, if we
 * can prove that this is safe to do. E.g consider:
 *
 \code
 f(x) = ...
 g(x) = f(x-1) + f(x)
 f.store_root().compute_at(g, x);
 \endcode
 *
 * We can store f as a circular buffer of size two, instead of
 * allocating space for all of it.
 */
Stmt storage_folding(Stmt s);

}
}

#endif
#ifndef HALIDE_SUBSTITUTE_H
#define HALIDE_SUBSTITUTE_H

/** \file
 *
 * Defines methods for substituting out variables in expressions and
 * statements. */

#include <map>

namespace Halide {
namespace Internal {

/** Substitute variables with the given name with the replacement
 * expression within expr. This is a dangerous thing to do if variable
 * names have not been uniquified. While it won't traverse inside let
 * statements with the same name as the first argument, moving a piece
 * of syntax around can change its meaning, because it can cross lets
 * that redefine variable names that it includes references to. */
Expr substitute(std::string name, Expr replacement, Expr expr);

/** Substitute variables with the given name with the replacement
 * expression within stmt. */
Stmt substitute(std::string name, Expr replacement, Stmt stmt);

/** Substitute variables with names in the map. */
// @{
Expr substitute(const std::map<std::string, Expr> &replacements, Expr expr);
Stmt substitute(const std::map<std::string, Expr> &replacements, Stmt stmt);
// @}

}
}

#endif
#ifndef HALIDE_PROFILING_H
#define HALIDE_PROFILING_H

/** \file
 * Defines the lowering pass that injects print statements when profiling is turned on
 */


namespace Halide {
namespace Internal {

/** Take a statement representing a halide pipeline, and (depending on
 * the environment variable HL_PROFILE), insert high-resolution timing
 * into the generated code; summaries of execution times and counts will
 * be logged at the end. Should be done before storage flattening, but
 * after all bounds inference. Use util/HalideProf to analyze the output.
 *
 * NOTE: this makes no effort to provide accurate or useful information
 * when parallelization is scheduled; more work would need to be done
 * to safely record data from multiple threads.
 *
 * NOTE: this makes no effort to account for overhead from the profiling
 * instructions inserted; profile-enabled runtimes will be slower,
 * and inner loops will be more profoundly affected.
 */
Stmt inject_profiling(Stmt, std::string);

/** Gets the current profiling level (by reading HL_PROFILE) */
int profiling_level();

}
}

#endif
#ifndef HALIDE_TRACING_H
#define HALIDE_TRACING_H

/** \file
 * Defines the lowering pass that injects print statements when tracing is turned on
 */

#include <map>

namespace Halide {
namespace Internal {

/** Take a statement representing a halide pipeline, inject calls to
 * tracing functions at interesting points, such as
 * allocations. Should be done before storage flattening, but after
 * all bounds inference. */
Stmt inject_tracing(Stmt, const std::map<std::string, Function> &env, Function output);

}
}

#endif
#ifndef HALIDE_UNROLL_LOOPS_H
#define HALIDE_UNROLL_LOOPS_H

/** \file
 * Defines the lowering pass that unrolls loops marked as such
 */


namespace Halide {
namespace Internal {

/** Take a statement with for loops marked for unrolling, and convert
 * each into several copies of the innermost statement. I.e. unroll
 * the loop. */
Stmt unroll_loops(Stmt);

}
}

#endif
#ifndef HALIDE_VECTORIZE_LOOPS_H
#define HALIDE_VECTORIZE_LOOPS_H

/** \file
 * Defines the lowering pass that vectorizes loops marked as such
 */


namespace Halide {
namespace Internal {

/** Take a statement with for loops marked for vectorization, and turn
 * them into single statements that operate on vectors. The loops in
 * question must have constant extent.
 */
Stmt vectorize_loops(Stmt);

}
}

#endif
#ifndef HALIDE_CODEGEN_ARM_H
#define HALIDE_CODEGEN_ARM_H

/** \file
 * Defines the code-generator for producing ARM machine code
 */


namespace Halide {
namespace Internal {

/** A code generator that emits ARM code from a given Halide stmt. */
class CodeGen_ARM : public CodeGen_Posix {
public:
    /** Create an ARM code generator for the given arm target. */
    CodeGen_ARM(Target);

    /** Compile to an internally-held llvm module. Takes a halide
     * statement, the name of the function produced, and the arguments
     * to the function produced. After calling this, call
     * CodeGen::compile_to_file or
     * CodeGen::compile_to_function_pointer to get at the ARM machine
     * code. */
    void compile(Stmt stmt, std::string name, const std::vector<Argument> &args);

    static void test();

protected:

    /** Which arm target are we compiling for */
    Target target;

    /** Generate a call to a neon intrinsic */
    // @{
    llvm::Value *call_intrin(Type t, const std::string &name, std::vector<Expr>);
    llvm::Value *call_intrin(llvm::Type *t, const std::string &name, std::vector<llvm::Value *>);
    llvm::Instruction *call_void_intrin(const std::string &name, std::vector<Expr>);
    llvm::Instruction *call_void_intrin(const std::string &name, std::vector<llvm::Value *>);
    // @}

    using CodeGen_Posix::visit;

    /** Nodes for which we want to emit specific neon intrinsics */
    // @{
    void visit(const Cast *);
    void visit(const Add *);
    void visit(const Sub *);
    void visit(const Div *);
    void visit(const Mul *);
    void visit(const Min *);
    void visit(const Max *);
    void visit(const LT *);
    void visit(const LE *);
    void visit(const Select *);
    void visit(const Store *);
    void visit(const Load *);
    void visit(const Call *);
    // @}

    /** Various patterns to peephole match against */
    struct Pattern {
        std::string intrin;
        Expr pattern;
        enum PatternType {Simple = 0, LeftShift, RightShift};
        PatternType type;
        Pattern() {}
        Pattern(std::string i, Expr p, PatternType t = Simple) : intrin(i), pattern(p), type(t) {}
    };
    std::vector<Pattern> casts, left_shifts, averagings, negations;


    std::string mcpu() const;
    std::string mattrs() const;
    bool use_soft_float_abi() const;
};

}}

#endif
#ifndef HALIDE_DEBUG_TO_FILE_H
#define HALIDE_DEBUG_TO_FILE_H

/** \file
 * Defines the lowering pass that injects code at the end of
 * every realization to dump functions to a file for debugging.  */

#include <map>

namespace Halide {
namespace Internal {

/** Takes a statement with Realize nodes still unlowered. If the
 * corresponding functions have a debug_file set, then inject code
 * that will dump the contents of those functions to a file after the
 * realization. */
Stmt debug_to_file(Stmt s, std::string output, const std::map<std::string, Function> &env);

}
}

#endif
#ifndef HALIDE_EARLY_FREE_H
#define HALIDE_EARLY_FREE_H

/** \file 
 * Defines the lowering pass that injects markers just after
 * the last use of each buffer so that they can potentially be freed
 * earlier.
 */


namespace Halide {
namespace Internal {

/** Take a statement with allocations and inject markers (of the form
 * of calls to "mark buffer dead") after the last use of each
 * allocation. Targets may use this to free buffers earlier than the
 * close of their Allocate node. */
Stmt inject_early_frees(Stmt s);

}
}

#endif
#ifndef UNIQUIFY_VARIABLE_NAMES
#define UNIQUIFY_VARIABLE_NAMES

/** \file
 * Defines the lowering pass that renames all variables to have unique names.
 */


namespace Halide {
namespace Internal {

/** Modify a statement so that every internally-defined variable name
 * is unique. This lets later passes assume syntactic equivalence is
 * semantic equivalence. */
Stmt uniquify_variable_names(Stmt s);

}
}


#endif
#ifndef HALIDE_INTERNAL_CSE_H
#define HALIDE_INTERNAL_CSE_H

/** \file
 * Defines a pass for introducing let expressions to wrap common sub-expressions. */


namespace Halide {
namespace Internal {

/** Replace each common sub-expression in the argument with a
 * variable, and wrap the resulting expr in a let statement giving a
 * value to that variable. 
 * 
* This is important to do within Halide (instead of punting to llvm),
 * because exprs that come in from the front-end are small when
 * considered as a graph, but combinatorially large when considered as
 * a tree. For an example of a such a case, see
 * test/code_explosion.cpp */

Expr common_subexpression_elimination(Expr);

/** Do common-subexpression-elimination on each expression in a
 * statement. Does not introduce let statements. */
Stmt common_subexpression_elimination(Stmt);

/** Remove all lets from a statement or expression by substituting
 * them in. All sub-expressions will exist once in memory, but may
 * have many pointers to them, so this doesn't cause a combinatorial
 * explosion. If you walk over this as if it were a tree, however,
 * you're going to have a bad time. */
// @{
Expr remove_lets(Expr);
Stmt remove_lets(Stmt);
// @}

}
}

#endif
#ifndef HALIDE_LERP_H
#define HALIDE_LERP_H


/** \file
 * Defines methods for converting a lerp intrinsic into Halide IR.
 */

namespace Halide {
namespace Internal {

/** Build Halide IR that computes a lerp. Use by codegen targets that
 * don't have a native lerp. */
Expr EXPORT lower_lerp(Expr zero_val, Expr one_val, Expr weight);

}
}

#endif
