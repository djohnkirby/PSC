; ModuleID = 'src/runtime/random.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

@halide_random_state_pool = weak global [256 x i32] zeroinitializer, align 4
@halide_random_state_pool_index = weak global i32 0, align 4
@halide_random_seed = weak global i32 0, align 4

define weak void @halide_set_random_seed(i32 %s) #0 {
entry:
  store i32 %s, i32* @halide_random_seed, align 4, !tbaa !1
  call void @llvm.memset.p0i8.i32(i8* bitcast ([256 x i32]* @halide_random_state_pool to i8*), i8 0, i32 1024, i32 4, i1 false)
  store i32 0, i32* @halide_random_state_pool_index, align 4, !tbaa !1
  ret void
}

define weak i32 @rand_u31(i8* %user_context, i32 %tag) #0 {
entry:
  %0 = atomicrmw add i32* @halide_random_state_pool_index, i32 1 seq_cst
  %and = and i32 %0, 255
  %arrayidx = getelementptr inbounds [256 x i32]* @halide_random_state_pool, i32 0, i32 %and
  %1 = load i32* %arrayidx, align 4, !tbaa !1
  %cmp = icmp eq i32 %1, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %add = add i32 %and, 115
  %add1 = add i32 %and, 123
  %mul = mul i32 %add, %add1
  %add2 = add i32 %and, 17
  %2 = load i32* @halide_random_seed, align 4, !tbaa !1
  %add3 = add i32 %add2, %2
  %mul4 = mul i32 %mul, %add3
  br label %if.end

if.else:                                          ; preds = %entry
  %and5 = and i32 %1, 2147483647
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %state.0 = phi i32 [ %mul4, %if.then ], [ %and5, %if.else ]
  %add6 = add nsw i32 %state.0, %tag
  %mul7 = mul nsw i32 %add6, 1103515245
  %add8 = add nsw i32 %mul7, 12345
  %and9 = and i32 %add8, 2147483647
  %or = or i32 %add8, -2147483648
  store i32 %or, i32* %arrayidx, align 4, !tbaa !1
  ret i32 %and9
}

define weak float @rand_f32(i8* %user_context, i32 %tag) #0 {
entry:
  %call = tail call i32 @rand_u31(i8* %user_context, i32 %tag)
  %shr = lshr i32 %call, 8
  %or = or i32 %shr, 1065353216
  %0 = bitcast i32 %or to float
  %sub = fadd float %0, -1.000000e+00
  ret float %sub
}

define weak i32 @rand_i32(i8* %user_context, i32 %tag) #0 {
entry:
  %call = tail call i32 @rand_u31(i8* %user_context, i32 %tag)
  %call1 = tail call i32 @rand_u31(i8* %user_context, i32 %tag)
  %shl = shl i32 %call, 1
  %shr = lshr i32 %call1, 15
  %xor = xor i32 %shr, %shl
  ret i32 %xor
}

; Function Attrs: nounwind
declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) #1

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"int", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
