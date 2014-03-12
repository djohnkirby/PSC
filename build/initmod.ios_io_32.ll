; ModuleID = 'src/runtime/ios_io.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

@.str = private unnamed_addr constant [18 x i8] c"NSAutoreleasePool\00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"alloc\00", align 1
@.str2 = private unnamed_addr constant [5 x i8] c"init\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"NSString\00", align 1
@.str4 = private unnamed_addr constant [20 x i8] c"initWithUTF8String:\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"release\00", align 1
@.str6 = private unnamed_addr constant [6 x i8] c"drain\00", align 1

define weak i32 @halide_printf(i8* %user_context, i8* %fmt, ...) #0 {
entry:
  %args = alloca i8*, align 4
  %args1 = bitcast i8** %args to i8*
  call void @llvm.va_start(i8* %args1)
  %call = call i8* @objc_getClass(i8* getelementptr inbounds ([18 x i8]* @.str, i32 0, i32 0))
  %call2 = call i8* @sel_getUid(i8* getelementptr inbounds ([6 x i8]* @.str1, i32 0, i32 0))
  %call3 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call, i8* %call2)
  %call4 = call i8* @sel_getUid(i8* getelementptr inbounds ([5 x i8]* @.str2, i32 0, i32 0))
  %call5 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call3, i8* %call4)
  %call6 = call i8* @objc_getClass(i8* getelementptr inbounds ([9 x i8]* @.str3, i32 0, i32 0))
  %call7 = call i8* @sel_getUid(i8* getelementptr inbounds ([6 x i8]* @.str1, i32 0, i32 0))
  %call8 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call6, i8* %call7)
  %call9 = call i8* @sel_getUid(i8* getelementptr inbounds ([20 x i8]* @.str4, i32 0, i32 0))
  %call10 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call8, i8* %call9, i8* %fmt)
  %0 = load i8** %args, align 4, !tbaa !1
  call void @NSLogv(i8* %call10, i8* %0)
  %call11 = call i8* @sel_getUid(i8* getelementptr inbounds ([8 x i8]* @.str5, i32 0, i32 0))
  %call12 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call10, i8* %call11)
  %call13 = call i8* @sel_getUid(i8* getelementptr inbounds ([6 x i8]* @.str6, i32 0, i32 0))
  %call14 = call i8* (i8*, i8*, ...)* @objc_msgSend(i8* %call5, i8* %call13)
  call void @llvm.va_end(i8* %args1)
  ret i32 1
}

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #1

declare i8* @objc_msgSend(i8*, i8*, ...) #0

declare i8* @objc_getClass(i8*) #0

declare i8* @sel_getUid(i8*) #0

declare void @NSLogv(i8*, i8*) #0

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
