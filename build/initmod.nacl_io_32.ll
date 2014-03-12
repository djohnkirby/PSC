; ModuleID = 'src/runtime/nacl_io.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

define weak i32 @halide_printf(i8* %user_context, i8* %fmt, ...) #0 {
entry:
  %buf = alloca [1024 x i8], align 1
  %args = alloca i8*, align 4
  %0 = getelementptr inbounds [1024 x i8]* %buf, i32 0, i32 0
  call void @llvm.lifetime.start(i64 1024, i8* %0) #1
  %args1 = bitcast i8** %args to i8*
  call void @llvm.va_start(i8* %args1)
  %1 = load i8** %args, align 4, !tbaa !1
  %call = call i32 @vsnprintf(i8* %0, i32 1024, i8* %fmt, i8* %1)
  call void @llvm.va_end(i8* %args1)
  br label %land.rhs

while.cond:                                       ; preds = %land.rhs
  %cmp = icmp ult i32 %inc, 1023
  br i1 %cmp, label %land.rhs, label %while.end

land.rhs:                                         ; preds = %entry, %while.cond
  %len.09 = phi i32 [ 0, %entry ], [ %inc, %while.cond ]
  %arrayidx = getelementptr inbounds [1024 x i8]* %buf, i32 0, i32 %len.09
  %2 = load i8* %arrayidx, align 1, !tbaa !5
  %cmp3 = icmp eq i8 %2, 0
  %inc = add i32 %len.09, 1
  br i1 %cmp3, label %while.end, label %while.cond

while.end:                                        ; preds = %land.rhs, %while.cond
  %len.0.lcssa = phi i32 [ %len.09, %land.rhs ], [ %inc, %while.cond ]
  %call5 = call i32 @write(i32 2, i8* %0, i32 %len.0.lcssa)
  call void @llvm.lifetime.end(i64 1024, i8* %0) #1
  ret i32 %call
}

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #1

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #1

; Function Attrs: nounwind
declare i32 @vsnprintf(i8* nocapture, i32, i8* nocapture readonly, i8*) #2

; Function Attrs: nounwind
declare void @llvm.va_end(i8*) #1

declare i32 @write(i32, i8* nocapture readonly, i32) #0

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #1

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !3, metadata !3, i64 0}
