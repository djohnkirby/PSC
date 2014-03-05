; ModuleID = 'src/runtime/ios_io.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.__va_list_tag = type { i32, i32, i8*, i8* }

@.str = private unnamed_addr constant [18 x i8] c"NSAutoreleasePool\00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"alloc\00", align 1
@.str2 = private unnamed_addr constant [5 x i8] c"init\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"NSString\00", align 1
@.str4 = private unnamed_addr constant [20 x i8] c"initWithUTF8String:\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"release\00", align 1
@.str6 = private unnamed_addr constant [6 x i8] c"drain\00", align 1

; Function Attrs: uwtable
define weak i32 @halide_printf(i8* %user_context, i8* %fmt, ...) #0 {
entry:
  %args = alloca [1 x %struct.__va_list_tag], align 16
  %arraydecay = getelementptr inbounds [1 x %struct.__va_list_tag]* %args, i64 0, i64 0
  %arraydecay1 = bitcast [1 x %struct.__va_list_tag]* %args to i8*
  call void @llvm.va_start(i8* %arraydecay1)
  %call = call i8* @objc_getClass(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0))
  %call2 = call i8* @sel_getUid(i8* getelementptr inbounds ([6 x i8]* @.str1, i64 0, i64 0))
  %call3 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call, i8* %call2)
  %call4 = call i8* @sel_getUid(i8* getelementptr inbounds ([5 x i8]* @.str2, i64 0, i64 0))
  %call5 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call3, i8* %call4)
  %call6 = call i8* @objc_getClass(i8* getelementptr inbounds ([9 x i8]* @.str3, i64 0, i64 0))
  %call7 = call i8* @sel_getUid(i8* getelementptr inbounds ([6 x i8]* @.str1, i64 0, i64 0))
  %call8 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call6, i8* %call7)
  %call9 = call i8* @sel_getUid(i8* getelementptr inbounds ([20 x i8]* @.str4, i64 0, i64 0))
  %call10 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call8, i8* %call9, i8* %fmt)
  call void @NSLogv(i8* %call10, %struct.__va_list_tag* %arraydecay)
  %call12 = call i8* @sel_getUid(i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0))
  %call13 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call10, i8* %call12)
  %call14 = call i8* @sel_getUid(i8* getelementptr inbounds ([6 x i8]* @.str6, i64 0, i64 0))
  %call15 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call5, i8* %call14)
  call void @llvm.va_end(i8* %arraydecay1)
  ret i32 1
}

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #1

declare i8* @objc_msgSend(i8*, i8*, ...) #2

declare i8* @objc_getClass(i8*) #2

declare i8* @sel_getUid(i8*) #2

declare void @NSLogv(i8*, %struct.__va_list_tag*) #2

; Function Attrs: nounwind
declare void @llvm.va_end(i8*) #1

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
