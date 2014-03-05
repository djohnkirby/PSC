; ModuleID = 'src/runtime/gcd_thread_pool.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%struct.halide_gcd_job = type { i32 (i8*, i32, i8*)*, i8*, i8*, i32, i32 }
%struct.dispatch_queue_s = type opaque

@halide_custom_do_task = weak global i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* null, align 4
@halide_custom_do_par_for = weak global i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* null, align 4

define weak void @halide_shutdown_thread_pool() #0 {
entry:
  ret void
}

define weak void @halide_set_custom_do_task(i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* %f) #0 {
entry:
  store i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* %f, i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)** @halide_custom_do_task, align 4, !tbaa !1
  ret void
}

define weak void @halide_set_custom_do_par_for(i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* %f) #0 {
entry:
  store i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* %f, i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)** @halide_custom_do_par_for, align 4, !tbaa !1
  ret void
}

define weak i32 @halide_do_task(i8* %user_context, i32 (i8*, i32, i8*)* %f, i32 %idx, i8* %closure) #0 {
entry:
  %0 = load i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)** @halide_custom_do_task, align 4, !tbaa !1
  %tobool = icmp eq i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* %0, null
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call i32 %0(i8* %user_context, i32 (i8*, i32, i8*)* %f, i32 %idx, i8* %closure)
  br label %return

if.else:                                          ; preds = %entry
  %call1 = tail call i32 %f(i8* %user_context, i32 %idx, i8* %closure)
  br label %return

return:                                           ; preds = %if.else, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ %call1, %if.else ]
  ret i32 %retval.0
}

define weak void @halide_do_gcd_task(i8* %job, i32 %idx) #0 {
entry:
  %user_context = getelementptr inbounds i8* %job, i32 4
  %0 = bitcast i8* %user_context to i8**
  %1 = load i8** %0, align 4, !tbaa !5
  %f = bitcast i8* %job to i32 (i8*, i32, i8*)**
  %2 = load i32 (i8*, i32, i8*)** %f, align 4, !tbaa !8
  %min = getelementptr inbounds i8* %job, i32 12
  %3 = bitcast i8* %min to i32*
  %4 = load i32* %3, align 4, !tbaa !9
  %add = add nsw i32 %4, %idx
  %closure = getelementptr inbounds i8* %job, i32 8
  %5 = bitcast i8* %closure to i8**
  %6 = load i8** %5, align 4, !tbaa !10
  %call = tail call i32 @halide_do_task(i8* %1, i32 (i8*, i32, i8*)* %2, i32 %add, i8* %6)
  %exit_status = getelementptr inbounds i8* %job, i32 16
  %7 = bitcast i8* %exit_status to i32*
  store i32 %call, i32* %7, align 4, !tbaa !11
  ret void
}

define weak i32 @halide_do_par_for(i8* %user_context, i32 (i8*, i32, i8*)* %f, i32 %min, i32 %size, i8* %closure) #0 {
entry:
  %job = alloca %struct.halide_gcd_job, align 4
  %f1 = getelementptr inbounds %struct.halide_gcd_job* %job, i32 0, i32 0
  store i32 (i8*, i32, i8*)* %f, i32 (i8*, i32, i8*)** %f1, align 4, !tbaa !8
  %user_context2 = getelementptr inbounds %struct.halide_gcd_job* %job, i32 0, i32 1
  store i8* %user_context, i8** %user_context2, align 4, !tbaa !5
  %closure3 = getelementptr inbounds %struct.halide_gcd_job* %job, i32 0, i32 2
  store i8* %closure, i8** %closure3, align 4, !tbaa !10
  %min4 = getelementptr inbounds %struct.halide_gcd_job* %job, i32 0, i32 3
  store i32 %min, i32* %min4, align 4, !tbaa !9
  %exit_status = getelementptr inbounds %struct.halide_gcd_job* %job, i32 0, i32 4
  store i32 0, i32* %exit_status, align 4, !tbaa !11
  %call = call %struct.dispatch_queue_s* @dispatch_get_global_queue(i32 0, i32 0)
  %0 = bitcast %struct.halide_gcd_job* %job to i8*
  call void @dispatch_apply_f(i32 %size, %struct.dispatch_queue_s* %call, i8* %0, void (i8*, i32)* @halide_do_gcd_task)
  %1 = load i32* %exit_status, align 4, !tbaa !11
  ret i32 %1
}

declare void @dispatch_apply_f(i32, %struct.dispatch_queue_s*, i8*, void (i8*, i32)*) #0

declare %struct.dispatch_queue_s* @dispatch_get_global_queue(i32, i32) #0

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !2, i64 4}
!6 = metadata !{metadata !"_ZTS14halide_gcd_job", metadata !2, i64 0, metadata !2, i64 4, metadata !2, i64 8, metadata !7, i64 12, metadata !7, i64 16}
!7 = metadata !{metadata !"int", metadata !3, i64 0}
!8 = metadata !{metadata !6, metadata !2, i64 0}
!9 = metadata !{metadata !6, metadata !7, i64 12}
!10 = metadata !{metadata !6, metadata !2, i64 8}
!11 = metadata !{metadata !6, metadata !7, i64 16}
