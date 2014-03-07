; ModuleID = 'src/runtime/posix_thread_pool.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.anon = type { %struct.pthread_mutex_t, %struct.work*, %struct.pthread_cond_t, [64 x i64], i8 }
%struct.pthread_mutex_t = type { [40 x i8] }
%struct.work = type { %struct.work*, i32 (i8*, i32, i8*)*, i8*, i32, i32, i8*, i32, i32 }
%struct.pthread_cond_t = type { [48 x i8] }
%struct.pthread_attr_t = type { i32, i8*, i64, i64, i32, i32 }

@halide_work_queue = weak global %struct.anon zeroinitializer, align 8
@halide_threads = weak global i32 0, align 4
@halide_thread_pool_initialized = weak global i8 0, align 1
@halide_custom_do_task = weak global i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* null, align 8
@halide_custom_do_par_for = weak global i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* null, align 8
@.str = private unnamed_addr constant [14 x i8] c"HL_NUMTHREADS\00", align 1

; Function Attrs: uwtable
define weak void @halide_shutdown_thread_pool() #0 {
entry:
  %retval = alloca i8*, align 8
  %uninitialized_mutex.sroa.0 = alloca [40 x i8], align 1
  %0 = load i8* @halide_thread_pool_initialized, align 1, !tbaa !1, !range !5
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %return, label %if.end

if.end:                                           ; preds = %entry
  %call = call i32 @pthread_mutex_lock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  store i8 1, i8* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 4), align 8, !tbaa !6
  %call1 = call i32 @pthread_cond_broadcast(%struct.pthread_cond_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 2))
  %call2 = call i32 @pthread_mutex_unlock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  %1 = load i32* @halide_threads, align 4, !tbaa !11
  %sub16 = add nsw i32 %1, -1
  %cmp17 = icmp sgt i32 %sub16, 0
  br i1 %cmp17, label %for.body, label %for.end

for.body:                                         ; preds = %if.end, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %if.end ]
  %arrayidx = getelementptr inbounds %struct.anon* @halide_work_queue, i64 0, i32 3, i64 %indvars.iv
  %2 = load i64* %arrayidx, align 8, !tbaa !13
  %call3 = call i32 @pthread_join(i64 %2, i8** %retval)
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %3 = load i32* @halide_threads, align 4, !tbaa !11
  %sub = add nsw i32 %3, -1
  %4 = trunc i64 %indvars.iv.next to i32
  %cmp = icmp slt i32 %4, %sub
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %if.end
  %call4 = call i32 @pthread_mutex_destroy(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  %uninitialized_mutex.sroa.0.0.idx9 = getelementptr inbounds [40 x i8]* %uninitialized_mutex.sroa.0, i64 0, i64 0
  call void @llvm.lifetime.start(i64 40, i8* %uninitialized_mutex.sroa.0.0.idx9)
  call void @llvm.memset.p0i8.i64(i8* %uninitialized_mutex.sroa.0.0.idx9, i8 0, i64 40, i32 1, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0, i32 0, i64 0), i8* %uninitialized_mutex.sroa.0.0.idx9, i64 40, i32 1, i1 false)
  %call5 = call i32 @pthread_cond_destroy(%struct.pthread_cond_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 2))
  store i8 0, i8* @halide_thread_pool_initialized, align 1, !tbaa !1
  call void @llvm.lifetime.end(i64 40, i8* %uninitialized_mutex.sroa.0.0.idx9)
  br label %return

return:                                           ; preds = %entry, %for.end
  ret void
}

declare i32 @pthread_mutex_lock(%struct.pthread_mutex_t*) #1

declare i32 @pthread_cond_broadcast(%struct.pthread_cond_t*) #1

declare i32 @pthread_mutex_unlock(%struct.pthread_mutex_t*) #1

declare i32 @pthread_join(i64, i8**) #1

declare i32 @pthread_mutex_destroy(%struct.pthread_mutex_t*) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) #2

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #2

declare i32 @pthread_cond_destroy(%struct.pthread_cond_t*) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #2

; Function Attrs: uwtable
define weak void @halide_set_custom_do_task(i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* %f) #0 {
entry:
  store i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* %f, i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)** @halide_custom_do_task, align 8, !tbaa !15
  ret void
}

; Function Attrs: uwtable
define weak void @halide_set_custom_do_par_for(i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* %f) #0 {
entry:
  store i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* %f, i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)** @halide_custom_do_par_for, align 8, !tbaa !15
  ret void
}

; Function Attrs: uwtable
define weak i32 @halide_do_task(i8* %user_context, i32 (i8*, i32, i8*)* %f, i32 %idx, i8* %closure) #0 {
entry:
  %0 = load i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)** @halide_custom_do_task, align 8, !tbaa !15
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

; Function Attrs: uwtable
define weak i8* @halide_worker_thread(i8* %void_arg) #0 {
entry:
  %0 = bitcast i8* %void_arg to %struct.work*
  %call = tail call i32 @pthread_mutex_lock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  %active_workers.i = getelementptr inbounds i8* %void_arg, i64 40
  %1 = bitcast i8* %active_workers.i to i32*
  %cmp = icmp eq i8* %void_arg, null
  %next.i = getelementptr inbounds i8* %void_arg, i64 24
  %2 = bitcast i8* %next.i to i32*
  %max.i = getelementptr inbounds i8* %void_arg, i64 28
  %3 = bitcast i8* %max.i to i32*
  br i1 %cmp, label %cond.false.us, label %cond.true

cond.false.us:                                    ; preds = %if.end14.us, %_ZN4work7runningEv.exit58.us, %if.then18.us, %if.then.us, %entry
  %4 = load i8* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 4), align 8, !tbaa !6, !range !5
  %lnot.i.us = icmp eq i8 %4, 0
  br i1 %lnot.i.us, label %while.body.us, label %while.end

while.body.us:                                    ; preds = %cond.false.us
  %5 = load %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 1), align 8, !tbaa !16
  %cmp3.us = icmp eq %struct.work* %5, null
  br i1 %cmp3.us, label %if.then.us, label %if.else.us

if.else.us:                                       ; preds = %while.body.us
  %myjob.sroa.3.0.idx25.us = getelementptr inbounds %struct.work* %5, i64 0, i32 1
  %myjob.sroa.3.0.copyload.us = load i32 (i8*, i32, i8*)** %myjob.sroa.3.0.idx25.us, align 8
  %myjob.sroa.4.0.idx27.us = getelementptr inbounds %struct.work* %5, i64 0, i32 2
  %myjob.sroa.4.0.copyload.us = load i8** %myjob.sroa.4.0.idx27.us, align 8
  %myjob.sroa.5.0.idx29.us = getelementptr inbounds %struct.work* %5, i64 0, i32 3
  %6 = bitcast i32* %myjob.sroa.5.0.idx29.us to i64*
  %myjob.sroa.5.0.copyload.us = load i64* %6, align 8
  %7 = trunc i64 %myjob.sroa.5.0.copyload.us to i32
  %myjob.sroa.633.0.idx34.us = getelementptr inbounds %struct.work* %5, i64 0, i32 5
  %myjob.sroa.633.0.copyload.us = load i8** %myjob.sroa.633.0.idx34.us, align 8
  %inc.us = add nsw i32 %7, 1
  store i32 %inc.us, i32* %myjob.sroa.5.0.idx29.us, align 4, !tbaa !17
  %max.us = getelementptr inbounds %struct.work* %5, i64 0, i32 4
  %8 = lshr i64 %myjob.sroa.5.0.copyload.us, 32
  %9 = trunc i64 %8 to i32
  %cmp6.us = icmp eq i32 %inc.us, %9
  br i1 %cmp6.us, label %if.then7.us, label %if.end.us

if.then7.us:                                      ; preds = %if.else.us
  %next_job.us = getelementptr inbounds %struct.work* %5, i64 0, i32 0
  %10 = load %struct.work** %next_job.us, align 8, !tbaa !19
  store %struct.work* %10, %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 1), align 8, !tbaa !16
  br label %if.end.us

if.end.us:                                        ; preds = %if.then7.us, %if.else.us
  %active_workers.us = getelementptr inbounds %struct.work* %5, i64 0, i32 6
  %11 = load i32* %active_workers.us, align 4, !tbaa !20
  %inc8.us = add nsw i32 %11, 1
  store i32 %inc8.us, i32* %active_workers.us, align 4, !tbaa !20
  %call9.us = tail call i32 @pthread_mutex_unlock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  %call11.us = tail call i32 @halide_do_task(i8* %myjob.sroa.4.0.copyload.us, i32 (i8*, i32, i8*)* %myjob.sroa.3.0.copyload.us, i32 %7, i8* %myjob.sroa.633.0.copyload.us)
  %call12.us = tail call i32 @pthread_mutex_lock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  %tobool.us = icmp eq i32 %call11.us, 0
  br i1 %tobool.us, label %if.end14.us, label %if.then13.us

if.then13.us:                                     ; preds = %if.end.us
  %exit_status.us = getelementptr inbounds %struct.work* %5, i64 0, i32 7
  store i32 %call11.us, i32* %exit_status.us, align 4, !tbaa !21
  br label %if.end14.us

if.end14.us:                                      ; preds = %if.then13.us, %if.end.us
  %12 = load i32* %active_workers.us, align 4, !tbaa !20
  %dec.us = add nsw i32 %12, -1
  store i32 %dec.us, i32* %active_workers.us, align 4, !tbaa !20
  %13 = load i32* %myjob.sroa.5.0.idx29.us, align 4, !tbaa !17
  %14 = load i32* %max.us, align 4, !tbaa !22
  %cmp.i54.us = icmp slt i32 %13, %14
  br i1 %cmp.i54.us, label %cond.false.us, label %_ZN4work7runningEv.exit58.us

_ZN4work7runningEv.exit58.us:                     ; preds = %if.end14.us
  %cmp2.i56.us = icmp sgt i32 %dec.us, 0
  %cmp17.us = icmp eq %struct.work* %5, %0
  %or.cond.us = or i1 %cmp2.i56.us, %cmp17.us
  br i1 %or.cond.us, label %cond.false.us, label %if.then18.us

if.then18.us:                                     ; preds = %_ZN4work7runningEv.exit58.us
  %call19.us = tail call i32 @pthread_cond_broadcast(%struct.pthread_cond_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 2))
  br label %cond.false.us

if.then.us:                                       ; preds = %while.body.us
  %call4.us = tail call i32 @pthread_cond_wait(%struct.pthread_cond_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 2), %struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  br label %cond.false.us

cond.true:                                        ; preds = %if.end14, %_ZN4work7runningEv.exit58, %if.then18, %if.then, %entry
  %15 = load i32* %2, align 4, !tbaa !17
  %16 = load i32* %3, align 4, !tbaa !22
  %cmp.i = icmp slt i32 %15, %16
  br i1 %cmp.i, label %while.body, label %cond.end

cond.end:                                         ; preds = %cond.true
  %17 = load i32* %1, align 4, !tbaa !20
  %cmp2.i = icmp sgt i32 %17, 0
  br i1 %cmp2.i, label %while.body, label %while.end

while.body:                                       ; preds = %cond.true, %cond.end
  %18 = load %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 1), align 8, !tbaa !16
  %cmp3 = icmp eq %struct.work* %18, null
  br i1 %cmp3, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %call4 = tail call i32 @pthread_cond_wait(%struct.pthread_cond_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 2), %struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  br label %cond.true

if.else:                                          ; preds = %while.body
  %myjob.sroa.3.0.idx25 = getelementptr inbounds %struct.work* %18, i64 0, i32 1
  %myjob.sroa.3.0.copyload = load i32 (i8*, i32, i8*)** %myjob.sroa.3.0.idx25, align 8
  %myjob.sroa.4.0.idx27 = getelementptr inbounds %struct.work* %18, i64 0, i32 2
  %myjob.sroa.4.0.copyload = load i8** %myjob.sroa.4.0.idx27, align 8
  %myjob.sroa.5.0.idx29 = getelementptr inbounds %struct.work* %18, i64 0, i32 3
  %19 = bitcast i32* %myjob.sroa.5.0.idx29 to i64*
  %myjob.sroa.5.0.copyload = load i64* %19, align 8
  %20 = trunc i64 %myjob.sroa.5.0.copyload to i32
  %myjob.sroa.633.0.idx34 = getelementptr inbounds %struct.work* %18, i64 0, i32 5
  %myjob.sroa.633.0.copyload = load i8** %myjob.sroa.633.0.idx34, align 8
  %inc = add nsw i32 %20, 1
  store i32 %inc, i32* %myjob.sroa.5.0.idx29, align 4, !tbaa !17
  %max = getelementptr inbounds %struct.work* %18, i64 0, i32 4
  %21 = lshr i64 %myjob.sroa.5.0.copyload, 32
  %22 = trunc i64 %21 to i32
  %cmp6 = icmp eq i32 %inc, %22
  br i1 %cmp6, label %if.then7, label %if.end

if.then7:                                         ; preds = %if.else
  %next_job = getelementptr inbounds %struct.work* %18, i64 0, i32 0
  %23 = load %struct.work** %next_job, align 8, !tbaa !19
  store %struct.work* %23, %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 1), align 8, !tbaa !16
  br label %if.end

if.end:                                           ; preds = %if.then7, %if.else
  %active_workers = getelementptr inbounds %struct.work* %18, i64 0, i32 6
  %24 = load i32* %active_workers, align 4, !tbaa !20
  %inc8 = add nsw i32 %24, 1
  store i32 %inc8, i32* %active_workers, align 4, !tbaa !20
  %call9 = tail call i32 @pthread_mutex_unlock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  %call11 = tail call i32 @halide_do_task(i8* %myjob.sroa.4.0.copyload, i32 (i8*, i32, i8*)* %myjob.sroa.3.0.copyload, i32 %20, i8* %myjob.sroa.633.0.copyload)
  %call12 = tail call i32 @pthread_mutex_lock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  %tobool = icmp eq i32 %call11, 0
  br i1 %tobool, label %if.end14, label %if.then13

if.then13:                                        ; preds = %if.end
  %exit_status = getelementptr inbounds %struct.work* %18, i64 0, i32 7
  store i32 %call11, i32* %exit_status, align 4, !tbaa !21
  br label %if.end14

if.end14:                                         ; preds = %if.end, %if.then13
  %25 = load i32* %active_workers, align 4, !tbaa !20
  %dec = add nsw i32 %25, -1
  store i32 %dec, i32* %active_workers, align 4, !tbaa !20
  %26 = load i32* %myjob.sroa.5.0.idx29, align 4, !tbaa !17
  %27 = load i32* %max, align 4, !tbaa !22
  %cmp.i54 = icmp slt i32 %26, %27
  br i1 %cmp.i54, label %cond.true, label %_ZN4work7runningEv.exit58

_ZN4work7runningEv.exit58:                        ; preds = %if.end14
  %cmp2.i56 = icmp sgt i32 %dec, 0
  %cmp17 = icmp eq %struct.work* %18, %0
  %or.cond = or i1 %cmp2.i56, %cmp17
  br i1 %or.cond, label %cond.true, label %if.then18

if.then18:                                        ; preds = %_ZN4work7runningEv.exit58
  %call19 = tail call i32 @pthread_cond_broadcast(%struct.pthread_cond_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 2))
  br label %cond.true

while.end:                                        ; preds = %cond.end, %cond.false.us
  %call22 = tail call i32 @pthread_mutex_unlock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  ret i8* null
}

declare i32 @pthread_cond_wait(%struct.pthread_cond_t*, %struct.pthread_mutex_t*) #1

; Function Attrs: uwtable
define weak i32 @halide_do_par_for(i8* %user_context, i32 (i8*, i32, i8*)* %f, i32 %min, i32 %size, i8* %closure) #0 {
entry:
  %job = alloca %struct.work, align 8
  %0 = load i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)** @halide_custom_do_par_for, align 8, !tbaa !15
  %tobool = icmp eq i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* %0, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %call = call i32 %0(i8* %user_context, i32 (i8*, i32, i8*)* %f, i32 %min, i32 %size, i8* %closure)
  br label %return

if.end:                                           ; preds = %entry
  %call1 = call i32 @pthread_mutex_lock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  %1 = load i8* @halide_thread_pool_initialized, align 1, !tbaa !1, !range !5
  %tobool2 = icmp eq i8 %1, 0
  br i1 %tobool2, label %if.then3, label %if.end19

if.then3:                                         ; preds = %if.end
  store i8 0, i8* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 4), align 8, !tbaa !6
  %call4 = call i32 @pthread_cond_init(%struct.pthread_cond_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 2), i64* null)
  store %struct.work* null, %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 1), align 8, !tbaa !16
  %call5 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str, i64 0, i64 0))
  %tobool6 = icmp eq i8* %call5, null
  br i1 %tobool6, label %if.else, label %if.then7

if.then7:                                         ; preds = %if.then3
  %call8 = call i32 @atoi(i8* %call5)
  br label %if.end10

if.else:                                          ; preds = %if.then3
  %call9 = call i32 @halide_host_cpu_count()
  br label %if.end10

if.end10:                                         ; preds = %if.else, %if.then7
  %storemerge = phi i32 [ %call9, %if.else ], [ %call8, %if.then7 ]
  store i32 %storemerge, i32* @halide_threads, align 4, !tbaa !11
  %cmp = icmp sgt i32 %storemerge, 64
  br i1 %cmp, label %for.cond.preheader.thread, label %if.else12

for.cond.preheader.thread:                        ; preds = %if.end10
  store i32 64, i32* @halide_threads, align 4, !tbaa !11
  br label %for.body

if.else12:                                        ; preds = %if.end10
  %cmp13 = icmp slt i32 %storemerge, 1
  br i1 %cmp13, label %for.cond.preheader.thread41, label %for.cond.preheader

for.cond.preheader.thread41:                      ; preds = %if.else12
  store i32 1, i32* @halide_threads, align 4, !tbaa !11
  br label %for.end

for.cond.preheader:                               ; preds = %if.else12
  %sub36 = add nsw i32 %storemerge, -1
  %cmp1737 = icmp sgt i32 %sub36, 0
  br i1 %cmp1737, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond.preheader, %for.cond.preheader.thread, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.cond.preheader.thread ], [ 0, %for.cond.preheader ]
  %add.ptr = getelementptr inbounds %struct.anon* @halide_work_queue, i64 0, i32 3, i64 %indvars.iv
  %call18 = call i32 @pthread_create(i64* %add.ptr, %struct.pthread_attr_t* null, i8* (i8*)* @halide_worker_thread, i8* null)
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %2 = load i32* @halide_threads, align 4, !tbaa !11
  %sub = add nsw i32 %2, -1
  %3 = trunc i64 %indvars.iv.next to i32
  %cmp17 = icmp slt i32 %3, %sub
  br i1 %cmp17, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %for.cond.preheader.thread41, %for.cond.preheader
  store i8 1, i8* @halide_thread_pool_initialized, align 1, !tbaa !1
  br label %if.end19

if.end19:                                         ; preds = %if.end, %for.end
  %4 = bitcast %struct.work* %job to i8*
  call void @llvm.lifetime.start(i64 48, i8* %4) #2
  %f20 = getelementptr inbounds %struct.work* %job, i64 0, i32 1
  store i32 (i8*, i32, i8*)* %f, i32 (i8*, i32, i8*)** %f20, align 8, !tbaa !23
  %user_context21 = getelementptr inbounds %struct.work* %job, i64 0, i32 2
  store i8* %user_context, i8** %user_context21, align 8, !tbaa !24
  %next = getelementptr inbounds %struct.work* %job, i64 0, i32 3
  store i32 %min, i32* %next, align 8, !tbaa !17
  %add = add nsw i32 %size, %min
  %max = getelementptr inbounds %struct.work* %job, i64 0, i32 4
  store i32 %add, i32* %max, align 4, !tbaa !22
  %closure22 = getelementptr inbounds %struct.work* %job, i64 0, i32 5
  store i8* %closure, i8** %closure22, align 8, !tbaa !25
  %exit_status = getelementptr inbounds %struct.work* %job, i64 0, i32 7
  store i32 0, i32* %exit_status, align 4, !tbaa !21
  %active_workers = getelementptr inbounds %struct.work* %job, i64 0, i32 6
  store i32 0, i32* %active_workers, align 8, !tbaa !20
  %5 = load %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 1), align 8, !tbaa !16
  %next_job = getelementptr inbounds %struct.work* %job, i64 0, i32 0
  store %struct.work* %5, %struct.work** %next_job, align 8, !tbaa !19
  store %struct.work* %job, %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 1), align 8, !tbaa !16
  %call23 = call i32 @pthread_mutex_unlock(%struct.pthread_mutex_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 0))
  %call24 = call i32 @pthread_cond_broadcast(%struct.pthread_cond_t* getelementptr inbounds (%struct.anon* @halide_work_queue, i64 0, i32 2))
  %call25 = call i8* @halide_worker_thread(i8* %4)
  %6 = load i32* %exit_status, align 4, !tbaa !21
  call void @llvm.lifetime.end(i64 48, i8* %4) #2
  br label %return

return:                                           ; preds = %if.end19, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ %6, %if.end19 ]
  ret i32 %retval.0
}

declare i32 @pthread_cond_init(%struct.pthread_cond_t*, i64*) #1

; Function Attrs: nounwind readonly
declare i8* @getenv(i8* nocapture) #3

; Function Attrs: nounwind readonly
declare i32 @atoi(i8* nocapture) #3

declare i32 @halide_host_cpu_count() #1

declare i32 @pthread_create(i64*, %struct.pthread_attr_t*, i8* (i8*)*, i8*) #1

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }
attributes #3 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"bool", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{i8 0, i8 2}
!6 = metadata !{metadata !7, metadata !2, i64 608}
!7 = metadata !{metadata !"_ZTS3$_0", metadata !8, i64 0, metadata !9, i64 40, metadata !10, i64 48, metadata !3, i64 96, metadata !2, i64 608}
!8 = metadata !{metadata !"_ZTS15pthread_mutex_t", metadata !3, i64 0}
!9 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!10 = metadata !{metadata !"_ZTS14pthread_cond_t", metadata !3, i64 0}
!11 = metadata !{metadata !12, metadata !12, i64 0}
!12 = metadata !{metadata !"int", metadata !3, i64 0}
!13 = metadata !{metadata !14, metadata !14, i64 0}
!14 = metadata !{metadata !"long", metadata !3, i64 0}
!15 = metadata !{metadata !9, metadata !9, i64 0}
!16 = metadata !{metadata !7, metadata !9, i64 40}
!17 = metadata !{metadata !18, metadata !12, i64 24}
!18 = metadata !{metadata !"_ZTS4work", metadata !9, i64 0, metadata !9, i64 8, metadata !9, i64 16, metadata !12, i64 24, metadata !12, i64 28, metadata !9, i64 32, metadata !12, i64 40, metadata !12, i64 44}
!19 = metadata !{metadata !18, metadata !9, i64 0}
!20 = metadata !{metadata !18, metadata !12, i64 40}
!21 = metadata !{metadata !18, metadata !12, i64 44}
!22 = metadata !{metadata !18, metadata !12, i64 28}
!23 = metadata !{metadata !18, metadata !9, i64 8}
!24 = metadata !{metadata !18, metadata !9, i64 16}
!25 = metadata !{metadata !18, metadata !9, i64 32}
