; ModuleID = 'src/runtime/ssp.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-unknown-unknown"

@__stack_chk_guard = weak global i8* inttoptr (i64 3735928559 to i8*), align 8
@.str = private unnamed_addr constant [49 x i8] c"Memory error: stack smashing protector changed!\0A\00", align 1

; Function Attrs: uwtable
define weak void @__stack_chk_fail() #0 {
entry:
  tail call void @halide_error(i8* null, i8* getelementptr inbounds ([49 x i8]* @.str, i64 0, i64 0))
  ret void
}

declare void @halide_error(i8*, i8*) #1

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
