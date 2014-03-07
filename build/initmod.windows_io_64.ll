; ModuleID = 'src/runtime/windows_io.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.__va_list_tag = type { i32, i32, i8*, i8* }

; Function Attrs: uwtable
define weak i32 @halide_printf(i8* %user_context, i8* %fmt, ...) #0 {
entry:
  %args = alloca [1 x %struct.__va_list_tag], align 16
  %call = call i8* @__iob_func()
  %add.ptr = getelementptr inbounds i8* %call, i64 48
  %arraydecay = getelementptr inbounds [1 x %struct.__va_list_tag]* %args, i64 0, i64 0
  %arraydecay1 = bitcast [1 x %struct.__va_list_tag]* %args to i8*
  call void @llvm.va_start(i8* %arraydecay1)
  %call3 = call i32 @vfprintf(i8* %add.ptr, i8* %fmt, %struct.__va_list_tag* %arraydecay)
  call void @llvm.va_end(i8* %arraydecay1)
  ret i32 %call3
}

declare i8* @__iob_func() #1

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #2

; Function Attrs: nounwind
declare i32 @vfprintf(i8* nocapture, i8* nocapture readonly, %struct.__va_list_tag*) #3

; Function Attrs: nounwind
declare void @llvm.va_end(i8*) #2

; Function Attrs: uwtable
define weak i32 @snprintf(i8* %user_context, i8* %str, i64 %size, i8* %fmt, ...) #0 {
entry:
  %args = alloca [1 x %struct.__va_list_tag], align 16
  %arraydecay = getelementptr inbounds [1 x %struct.__va_list_tag]* %args, i64 0, i64 0
  %arraydecay1 = bitcast [1 x %struct.__va_list_tag]* %args to i8*
  call void @llvm.va_start(i8* %arraydecay1)
  %call = call i32 @_vsnprintf(i8* %str, i64 %size, i8* %fmt, %struct.__va_list_tag* %arraydecay)
  call void @llvm.va_end(i8* %arraydecay1)
  ret i32 %call
}

declare i32 @_vsnprintf(i8*, i64, i8*, %struct.__va_list_tag*) #1

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }
attributes #3 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
