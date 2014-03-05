; ModuleID = 'src/runtime/posix_error_handler.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.__va_list_tag = type { i32, i32, i8*, i8* }

@halide_error_handler = weak global void (i8*, i8*)* null, align 8
@.str = private unnamed_addr constant [11 x i8] c"Error: %s\0A\00", align 1

; Function Attrs: uwtable
define weak void @halide_error(i8* %user_context, i8* %msg) #0 {
entry:
  %0 = load void (i8*, i8*)** @halide_error_handler, align 8, !tbaa !1
  %tobool = icmp eq void (i8*, i8*)* %0, null
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  tail call void %0(i8* %user_context, i8* %msg)
  br label %if.end

if.else:                                          ; preds = %entry
  %call = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([11 x i8]* @.str, i64 0, i64 0), i8* %msg)
  tail call void @exit(i32 1)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

declare i32 @halide_printf(i8*, i8*, ...) #1

declare void @exit(i32) #1

; Function Attrs: uwtable
define weak void @halide_error_varargs(i8* %user_context, i8* %msg, ...) #0 {
entry:
  %buf = alloca [4096 x i8], align 16
  %args = alloca [1 x %struct.__va_list_tag], align 16
  %0 = getelementptr inbounds [4096 x i8]* %buf, i64 0, i64 0
  call void @llvm.lifetime.start(i64 4096, i8* %0) #2
  %arraydecay = getelementptr inbounds [1 x %struct.__va_list_tag]* %args, i64 0, i64 0
  %arraydecay1 = bitcast [1 x %struct.__va_list_tag]* %args to i8*
  call void @llvm.va_start(i8* %arraydecay1)
  %call = call i32 @vsnprintf(i8* %0, i64 4096, i8* %msg, %struct.__va_list_tag* %arraydecay)
  call void @llvm.va_end(i8* %arraydecay1)
  call void @halide_error(i8* %user_context, i8* %0)
  call void @llvm.lifetime.end(i64 4096, i8* %0) #2
  ret void
}

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #2

; Function Attrs: nounwind
declare i32 @vsnprintf(i8* nocapture, i64, i8* nocapture readonly, %struct.__va_list_tag*) #3

; Function Attrs: nounwind
declare void @llvm.va_end(i8*) #2

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #2

; Function Attrs: uwtable
define weak void @halide_set_error_handler(void (i8*, i8*)* %handler) #0 {
entry:
  store void (i8*, i8*)* %handler, void (i8*, i8*)** @halide_error_handler, align 8, !tbaa !1
  ret void
}

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }
attributes #3 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
