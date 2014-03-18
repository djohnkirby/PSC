; ModuleID = 'src/runtime/posix_math.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@llvm.used = appending global [25 x i8*] [i8* bitcast (i64 ()* @maxval_s64 to i8*), i8* bitcast (i16 ()* @maxval_s16 to i8*), i8* bitcast (float ()* @nan_f32 to i8*), i8* bitcast (i32 ()* @minval_s32 to i8*), i8* bitcast (i16 ()* @minval_u16 to i8*), i8* bitcast (float ()* @minval_f32 to i8*), i8* bitcast (i8 ()* @maxval_s8 to i8*), i8* bitcast (double (i64)* @double_from_bits to i8*), i8* bitcast (i8 ()* @maxval_u8 to i8*), i8* bitcast (float ()* @inf_f32 to i8*), i8* bitcast (float (i32)* @float_from_bits to i8*), i8* bitcast (float ()* @neg_inf_f32 to i8*), i8* bitcast (i8 ()* @minval_u8 to i8*), i8* bitcast (i16 ()* @minval_s16 to i8*), i8* bitcast (i32 ()* @minval_u32 to i8*), i8* bitcast (i32 ()* @maxval_s32 to i8*), i8* bitcast (i64 ()* @minval_u64 to i8*), i8* bitcast (float ()* @maxval_f32 to i8*), i8* bitcast (i32 ()* @maxval_u32 to i8*), i8* bitcast (i64 ()* @maxval_u64 to i8*), i8* bitcast (double ()* @maxval_f64 to i8*), i8* bitcast (i64 ()* @minval_s64 to i8*), i8* bitcast (double ()* @minval_f64 to i8*), i8* bitcast (i8 ()* @minval_s8 to i8*), i8* bitcast (i16 ()* @maxval_u16 to i8*)], section "llvm.metadata"

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak zeroext i8 @maxval_u8() #0 {
entry:
  ret i8 -1
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak zeroext i8 @minval_u8() #0 {
entry:
  ret i8 0
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak zeroext i16 @maxval_u16() #0 {
entry:
  ret i16 -1
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak zeroext i16 @minval_u16() #0 {
entry:
  ret i16 0
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak i32 @maxval_u32() #0 {
entry:
  ret i32 -1
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak i32 @minval_u32() #0 {
entry:
  ret i32 0
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak i64 @maxval_u64() #0 {
entry:
  ret i64 -1
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak i64 @minval_u64() #0 {
entry:
  ret i64 0
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak signext i8 @maxval_s8() #0 {
entry:
  ret i8 127
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak signext i8 @minval_s8() #0 {
entry:
  ret i8 -128
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak signext i16 @maxval_s16() #0 {
entry:
  ret i16 32767
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak signext i16 @minval_s16() #0 {
entry:
  ret i16 -32768
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak i32 @maxval_s32() #0 {
entry:
  ret i32 2147483647
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak i32 @minval_s32() #0 {
entry:
  ret i32 -2147483648
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak i64 @maxval_s64() #0 {
entry:
  ret i64 9223372036854775807
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak i64 @minval_s64() #0 {
entry:
  ret i64 -9223372036854775808
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak float @float_from_bits(i32 %bits) #0 {
entry:
  %0 = bitcast i32 %bits to float
  ret float %0
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak float @nan_f32() #0 {
entry:
  ret float 0x7FF8000000000000
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak float @neg_inf_f32() #0 {
entry:
  ret float 0xFFF0000000000000
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak float @inf_f32() #0 {
entry:
  ret float 0x7FF0000000000000
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak float @maxval_f32() #0 {
entry:
  ret float 0x47EFFFFFE0000000
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak float @minval_f32() #0 {
entry:
  ret float 0x3810000000000000
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak double @double_from_bits(i64 %bits) #0 {
entry:
  %0 = bitcast i64 %bits to double
  ret double %0
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak double @maxval_f64() #0 {
entry:
  ret double 0x7FEFFFFFFFFFFFFF
}

; Function Attrs: alwaysinline inlinehint nounwind readonly uwtable
define weak double @minval_f64() #0 {
entry:
  ret double 0x10000000000000
}

attributes #0 = { alwaysinline inlinehint nounwind readonly uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
