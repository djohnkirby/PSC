; ModuleID = 'src/runtime/nacl_io.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.__va_list_tag = type { i32, i32, i8*, i8* }

; Function Attrs: uwtable
define weak i32 @halide_printf(i8* %user_context, i8* %fmt, ...) #0 {
entry:
  %buf = alloca [1024 x i8], align 16
  %args = alloca [1 x %struct.__va_list_tag], align 16
  %0 = getelementptr inbounds [1024 x i8]* %buf, i64 0, i64 0
  call void @llvm.lifetime.start(i64 1024, i8* %0) #1
  %arraydecay = getelementptr inbounds [1 x %struct.__va_list_tag]* %args, i64 0, i64 0
  %arraydecay1 = bitcast [1 x %struct.__va_list_tag]* %args to i8*
  call void @llvm.va_start(i8* %arraydecay1)
  %call = call i32 @vsnprintf(i8* %0, i64 1024, i8* %fmt, %struct.__va_list_tag* %arraydecay)
  call void @llvm.va_end(i8* %arraydecay1)
  br label %land.rhs

while.cond:                                       ; preds = %land.rhs
  %cmp = icmp ult i64 %inc, 1023
  br i1 %cmp, label %land.rhs, label %while.end

land.rhs:                                         ; preds = %entry, %while.cond
  %len.012 = phi i64 [ 0, %entry ], [ %inc, %while.cond ]
  %arrayidx = getelementptr inbounds [1024 x i8]* %buf, i64 0, i64 %len.012
  %1 = load i8* %arrayidx, align 1, !tbaa !1
  %cmp6 = icmp eq i8 %1, 0
  %inc = add i64 %len.012, 1
  br i1 %cmp6, label %while.end, label %while.cond

while.end:                                        ; preds = %land.rhs, %while.cond
  %len.0.lcssa = phi i64 [ %len.012, %land.rhs ], [ %inc, %while.cond ]
  %call8 = call i64 @write(i32 2, i8* %0, i64 %len.0.lcssa)
  call void @llvm.lifetime.end(i64 1024, i8* %0) #1
  ret i32 %call
}

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #1

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #1

; Function Attrs: nounwind
declare i32 @vsnprintf(i8* nocapture, i64, i8* nocapture readonly, %struct.__va_list_tag*) #2

; Function Attrs: nounwind
declare void @llvm.va_end(i8*) #1

declare i64 @write(i32, i8* nocapture readonly, i64) #3

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #1

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"omnipotent char", metadata !3, i64 0}
!3 = metadata !{metadata !"Simple C/C++ TBAA"}
