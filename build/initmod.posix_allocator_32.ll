; ModuleID = 'src/runtime/posix_allocator.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

@halide_custom_malloc = weak global i8* (i8*, i32)* null, align 4
@halide_custom_free = weak global void (i8*, i8*)* null, align 4

define weak void @halide_set_custom_allocator(i8* (i8*, i32)* %cust_malloc, void (i8*, i8*)* %cust_free) #0 {
entry:
  store i8* (i8*, i32)* %cust_malloc, i8* (i8*, i32)** @halide_custom_malloc, align 4, !tbaa !1
  store void (i8*, i8*)* %cust_free, void (i8*, i8*)** @halide_custom_free, align 4, !tbaa !1
  ret void
}

define weak i8* @halide_malloc(i8* %user_context, i32 %x) #0 {
entry:
  %0 = load i8* (i8*, i32)** @halide_custom_malloc, align 4, !tbaa !1
  %tobool = icmp eq i8* (i8*, i32)* %0, null
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call i8* %0(i8* %user_context, i32 %x)
  br label %return

if.else:                                          ; preds = %entry
  %add = add i32 %x, 40
  %call1 = tail call i8* @malloc(i32 %add)
  %cmp = icmp eq i8* %call1, null
  br i1 %cmp, label %return, label %if.end

if.end:                                           ; preds = %if.else
  %1 = ptrtoint i8* %call1 to i32
  %add3 = add i32 %1, 32
  %shr = and i32 %add3, -32
  %2 = inttoptr i32 %shr to i8*
  %3 = inttoptr i32 %shr to i8**
  %arrayidx = getelementptr inbounds i8** %3, i32 -1
  store i8* %call1, i8** %arrayidx, align 4, !tbaa !1
  br label %return

return:                                           ; preds = %if.else, %if.end, %if.then
  %retval.0 = phi i8* [ %call, %if.then ], [ %2, %if.end ], [ null, %if.else ]
  ret i8* %retval.0
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i32) #1

define weak void @halide_free(i8* %user_context, i8* %ptr) #0 {
entry:
  %0 = load void (i8*, i8*)** @halide_custom_free, align 4, !tbaa !1
  %tobool = icmp eq void (i8*, i8*)* %0, null
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  tail call void %0(i8* %user_context, i8* %ptr)
  br label %if.end

if.else:                                          ; preds = %entry
  %arrayidx = getelementptr inbounds i8* %ptr, i32 -4
  %1 = bitcast i8* %arrayidx to i8**
  %2 = load i8** %1, align 4, !tbaa !1
  tail call void @free(i8* %2)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

; Function Attrs: nounwind
declare void @free(i8* nocapture) #1

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
