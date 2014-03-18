; ModuleID = 'src/runtime/ssp.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

@__stack_chk_guard = weak global i8* inttoptr (i64 3735928559 to i8*), align 4
@.str = private unnamed_addr constant [49 x i8] c"Memory error: stack smashing protector changed!\0A\00", align 1

define weak void @__stack_chk_fail() #0 {
entry:
  tail call void @halide_error(i8* null, i8* getelementptr inbounds ([49 x i8]* @.str, i32 0, i32 0))
  ret void
}

declare void @halide_error(i8*, i8*) #0

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
