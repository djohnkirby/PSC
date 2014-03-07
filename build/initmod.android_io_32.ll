; ModuleID = 'src/runtime/android_io.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"halide\00", align 1

define weak i32 @halide_printf(i8* %user_context, i8* %fmt, ...) #0 {
entry:
  %args = alloca i8*, align 4
  %args1 = bitcast i8** %args to i8*
  call void @llvm.va_start(i8* %args1)
  %0 = load i8** %args, align 4, !tbaa !1
  %call = call i32 @__android_log_vprint(i32 7, i8* getelementptr inbounds ([7 x i8]* @.str, i32 0, i32 0), i8* %fmt, i8* %0)
  call void @llvm.va_end(i8* %args1)
  ret i32 %call
}

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #1

declare i32 @__android_log_vprint(i32, i8*, i8*, i8*) #0

; Function Attrs: nounwind
declare void @llvm.va_end(i8*) #1

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
