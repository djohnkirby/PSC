; ModuleID = 'src/runtime/windows_thread_pool.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%struct.anon = type { i64, %struct.CriticalSection, %struct.work*, i64, [64 x i64], i8 }
%struct.CriticalSection = type { [40 x i8] }
%struct.work = type { %struct.work*, i32 (i8*, i32, i8*)*, i8*, i32, i32, i8*, i32, i32 }

@halide_work_queue = weak global %struct.anon zeroinitializer, align 4
@halide_threads = weak global i32 0, align 4
@halide_thread_pool_initialized = weak global i8 0, align 1
@halide_custom_do_task = weak global i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* null, align 4
@halide_custom_do_par_for = weak global i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* null, align 4
@.str = private unnamed_addr constant [14 x i8] c"HL_NUMTHREADS\00", align 1
@.str1 = private unnamed_addr constant [21 x i8] c"NUMBER_OF_PROCESSORS\00", align 1

define weak x86_stdcallcc zeroext i1 @InitOnceCallback(i64*, i8*, i8**) #0 {
entry:
  tail call x86_stdcallcc void @InitializeCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  ret i1 true
}

declare x86_stdcallcc void @InitializeCriticalSection(%struct.CriticalSection*) #0

define weak void @halide_shutdown_thread_pool() #0 {
entry:
  %0 = load i8* @halide_thread_pool_initialized, align 1, !tbaa !1, !range !5
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %return, label %if.end

if.end:                                           ; preds = %entry
  tail call x86_stdcallcc void @EnterCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  store i8 1, i8* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 5), align 4, !tbaa !6
  tail call x86_stdcallcc void @WakeAllConditionVariable(i64* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 3))
  tail call x86_stdcallcc void @LeaveCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  %1 = load i32* @halide_threads, align 4, !tbaa !11
  %sub3 = add nsw i32 %1, -1
  %cmp4 = icmp sgt i32 %sub3, 0
  br i1 %cmp4, label %for.body, label %for.end

for.body:                                         ; preds = %if.end, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ 0, %if.end ]
  %arrayidx = getelementptr inbounds %struct.anon* @halide_work_queue, i32 0, i32 4, i32 %i.05
  %2 = load i64* %arrayidx, align 4, !tbaa !13
  %call = tail call x86_stdcallcc i32 @WaitForSingleObject(i64 %2, i32 -1)
  %inc = add nsw i32 %i.05, 1
  %3 = load i32* @halide_threads, align 4, !tbaa !11
  %sub = add nsw i32 %3, -1
  %cmp = icmp slt i32 %inc, %sub
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %if.end
  tail call x86_stdcallcc void @DeleteCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  store i64 0, i64* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 0), align 4, !tbaa !14
  store i8 0, i8* @halide_thread_pool_initialized, align 1, !tbaa !1
  br label %return

return:                                           ; preds = %entry, %for.end
  ret void
}

declare x86_stdcallcc void @EnterCriticalSection(%struct.CriticalSection*) #0

declare x86_stdcallcc void @WakeAllConditionVariable(i64*) #0

declare x86_stdcallcc void @LeaveCriticalSection(%struct.CriticalSection*) #0

declare x86_stdcallcc i32 @WaitForSingleObject(i64, i32) #0

declare x86_stdcallcc void @DeleteCriticalSection(%struct.CriticalSection*) #0

define weak void @halide_set_custom_do_task(i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* %f) #0 {
entry:
  store i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)* %f, i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)** @halide_custom_do_task, align 4, !tbaa !15
  ret void
}

define weak void @halide_set_custom_do_par_for(i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* %f) #0 {
entry:
  store i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* %f, i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)** @halide_custom_do_par_for, align 4, !tbaa !15
  ret void
}

define weak i32 @halide_do_task(i8* %user_context, i32 (i8*, i32, i8*)* %f, i32 %idx, i8* %closure) #0 {
entry:
  %0 = load i32 (i8*, i32 (i8*, i32, i8*)*, i32, i8*)** @halide_custom_do_task, align 4, !tbaa !15
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

define weak i8* @halide_worker_thread(i8* %void_arg) #0 {
entry:
  %0 = bitcast i8* %void_arg to %struct.work*
  tail call x86_stdcallcc void @EnterCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  %active_workers.i = getelementptr inbounds i8* %void_arg, i32 24
  %1 = bitcast i8* %active_workers.i to i32*
  %cmp = icmp eq i8* %void_arg, null
  %next.i = getelementptr inbounds i8* %void_arg, i32 12
  %2 = bitcast i8* %next.i to i32*
  %max.i = getelementptr inbounds i8* %void_arg, i32 16
  %3 = bitcast i8* %max.i to i32*
  br i1 %cmp, label %cond.false.us, label %cond.true

cond.false.us:                                    ; preds = %if.end10.us, %_ZN4work7runningEv.exit42.us, %if.then14.us, %if.then.us, %entry
  %4 = load i8* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 5), align 4, !tbaa !6, !range !5
  %lnot.i.us = icmp eq i8 %4, 0
  br i1 %lnot.i.us, label %while.body.us, label %while.end

while.body.us:                                    ; preds = %cond.false.us
  %5 = load %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 2), align 4, !tbaa !16
  %cmp2.us = icmp eq %struct.work* %5, null
  br i1 %cmp2.us, label %if.then.us, label %if.else.us

if.else.us:                                       ; preds = %while.body.us
  %myjob.sroa.1.0.idx18.us = getelementptr inbounds %struct.work* %5, i32 0, i32 1
  %myjob.sroa.1.0.copyload.us = load i32 (i8*, i32, i8*)** %myjob.sroa.1.0.idx18.us, align 4
  %myjob.sroa.2.0.idx19.us = getelementptr inbounds %struct.work* %5, i32 0, i32 2
  %myjob.sroa.2.0.copyload.us = load i8** %myjob.sroa.2.0.idx19.us, align 4
  %myjob.sroa.3.0.idx20.us = getelementptr inbounds %struct.work* %5, i32 0, i32 3
  %myjob.sroa.3.0.copyload.us = load i32* %myjob.sroa.3.0.idx20.us, align 4
  %myjob.sroa.4.0.idx21.us = getelementptr inbounds %struct.work* %5, i32 0, i32 4
  %myjob.sroa.422.0.idx23.us = getelementptr inbounds %struct.work* %5, i32 0, i32 5
  %myjob.sroa.422.0.copyload.us = load i8** %myjob.sroa.422.0.idx23.us, align 4
  %myjob.sroa.5.0.idx.us = getelementptr inbounds %struct.work* %5, i32 0, i32 6
  %inc.us = add nsw i32 %myjob.sroa.3.0.copyload.us, 1
  store i32 %inc.us, i32* %myjob.sroa.3.0.idx20.us, align 4, !tbaa !17
  %6 = load i32* %myjob.sroa.4.0.idx21.us, align 4, !tbaa !19
  %cmp4.us = icmp eq i32 %inc.us, %6
  br i1 %cmp4.us, label %if.then5.us, label %if.end.us

if.then5.us:                                      ; preds = %if.else.us
  %myjob.sroa.0.0.idx.us = getelementptr inbounds %struct.work* %5, i32 0, i32 0
  %7 = load %struct.work** %myjob.sroa.0.0.idx.us, align 4, !tbaa !20
  store %struct.work* %7, %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 2), align 4, !tbaa !16
  br label %if.end.us

if.end.us:                                        ; preds = %if.then5.us, %if.else.us
  %8 = load i32* %myjob.sroa.5.0.idx.us, align 4, !tbaa !21
  %inc6.us = add nsw i32 %8, 1
  store i32 %inc6.us, i32* %myjob.sroa.5.0.idx.us, align 4, !tbaa !21
  tail call x86_stdcallcc void @LeaveCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  %call8.us = tail call i32 @halide_do_task(i8* %myjob.sroa.2.0.copyload.us, i32 (i8*, i32, i8*)* %myjob.sroa.1.0.copyload.us, i32 %myjob.sroa.3.0.copyload.us, i8* %myjob.sroa.422.0.copyload.us)
  tail call x86_stdcallcc void @EnterCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  %tobool.us = icmp eq i32 %call8.us, 0
  br i1 %tobool.us, label %if.end10.us, label %if.then9.us

if.then9.us:                                      ; preds = %if.end.us
  %exit_status.us = getelementptr inbounds %struct.work* %5, i32 0, i32 7
  store i32 %call8.us, i32* %exit_status.us, align 4, !tbaa !22
  br label %if.end10.us

if.end10.us:                                      ; preds = %if.then9.us, %if.end.us
  %9 = load i32* %myjob.sroa.5.0.idx.us, align 4, !tbaa !21
  %dec.us = add nsw i32 %9, -1
  store i32 %dec.us, i32* %myjob.sroa.5.0.idx.us, align 4, !tbaa !21
  %10 = load i32* %myjob.sroa.3.0.idx20.us, align 4, !tbaa !17
  %11 = load i32* %myjob.sroa.4.0.idx21.us, align 4, !tbaa !19
  %cmp.i38.us = icmp slt i32 %10, %11
  br i1 %cmp.i38.us, label %cond.false.us, label %_ZN4work7runningEv.exit42.us

_ZN4work7runningEv.exit42.us:                     ; preds = %if.end10.us
  %cmp2.i40.us = icmp sgt i32 %dec.us, 0
  %cmp13.us = icmp eq %struct.work* %5, %0
  %or.cond.us = or i1 %cmp2.i40.us, %cmp13.us
  br i1 %or.cond.us, label %cond.false.us, label %if.then14.us

if.then14.us:                                     ; preds = %_ZN4work7runningEv.exit42.us
  tail call x86_stdcallcc void @WakeAllConditionVariable(i64* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 3))
  br label %cond.false.us

if.then.us:                                       ; preds = %while.body.us
  tail call x86_stdcallcc void @SleepConditionVariableCS(i64* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 3), %struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1), i32 -1)
  br label %cond.false.us

cond.true:                                        ; preds = %if.end10, %if.then, %if.then14, %_ZN4work7runningEv.exit42, %entry
  %12 = load i32* %2, align 4, !tbaa !17
  %13 = load i32* %3, align 4, !tbaa !19
  %cmp.i = icmp slt i32 %12, %13
  br i1 %cmp.i, label %while.body, label %cond.end

cond.end:                                         ; preds = %cond.true
  %14 = load i32* %1, align 4, !tbaa !21
  %cmp2.i = icmp sgt i32 %14, 0
  br i1 %cmp2.i, label %while.body, label %while.end

while.body:                                       ; preds = %cond.true, %cond.end
  %15 = load %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 2), align 4, !tbaa !16
  %cmp2 = icmp eq %struct.work* %15, null
  br i1 %cmp2, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  tail call x86_stdcallcc void @SleepConditionVariableCS(i64* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 3), %struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1), i32 -1)
  br label %cond.true

if.else:                                          ; preds = %while.body
  %myjob.sroa.1.0.idx18 = getelementptr inbounds %struct.work* %15, i32 0, i32 1
  %myjob.sroa.1.0.copyload = load i32 (i8*, i32, i8*)** %myjob.sroa.1.0.idx18, align 4
  %myjob.sroa.2.0.idx19 = getelementptr inbounds %struct.work* %15, i32 0, i32 2
  %myjob.sroa.2.0.copyload = load i8** %myjob.sroa.2.0.idx19, align 4
  %myjob.sroa.3.0.idx20 = getelementptr inbounds %struct.work* %15, i32 0, i32 3
  %myjob.sroa.3.0.copyload = load i32* %myjob.sroa.3.0.idx20, align 4
  %myjob.sroa.4.0.idx21 = getelementptr inbounds %struct.work* %15, i32 0, i32 4
  %myjob.sroa.422.0.idx23 = getelementptr inbounds %struct.work* %15, i32 0, i32 5
  %myjob.sroa.422.0.copyload = load i8** %myjob.sroa.422.0.idx23, align 4
  %myjob.sroa.5.0.idx = getelementptr inbounds %struct.work* %15, i32 0, i32 6
  %inc = add nsw i32 %myjob.sroa.3.0.copyload, 1
  store i32 %inc, i32* %myjob.sroa.3.0.idx20, align 4, !tbaa !17
  %16 = load i32* %myjob.sroa.4.0.idx21, align 4, !tbaa !19
  %cmp4 = icmp eq i32 %inc, %16
  br i1 %cmp4, label %if.then5, label %if.end

if.then5:                                         ; preds = %if.else
  %myjob.sroa.0.0.idx = getelementptr inbounds %struct.work* %15, i32 0, i32 0
  %17 = load %struct.work** %myjob.sroa.0.0.idx, align 4, !tbaa !20
  store %struct.work* %17, %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 2), align 4, !tbaa !16
  br label %if.end

if.end:                                           ; preds = %if.then5, %if.else
  %18 = load i32* %myjob.sroa.5.0.idx, align 4, !tbaa !21
  %inc6 = add nsw i32 %18, 1
  store i32 %inc6, i32* %myjob.sroa.5.0.idx, align 4, !tbaa !21
  tail call x86_stdcallcc void @LeaveCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  %call8 = tail call i32 @halide_do_task(i8* %myjob.sroa.2.0.copyload, i32 (i8*, i32, i8*)* %myjob.sroa.1.0.copyload, i32 %myjob.sroa.3.0.copyload, i8* %myjob.sroa.422.0.copyload)
  tail call x86_stdcallcc void @EnterCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  %tobool = icmp eq i32 %call8, 0
  br i1 %tobool, label %if.end10, label %if.then9

if.then9:                                         ; preds = %if.end
  %exit_status = getelementptr inbounds %struct.work* %15, i32 0, i32 7
  store i32 %call8, i32* %exit_status, align 4, !tbaa !22
  br label %if.end10

if.end10:                                         ; preds = %if.end, %if.then9
  %19 = load i32* %myjob.sroa.5.0.idx, align 4, !tbaa !21
  %dec = add nsw i32 %19, -1
  store i32 %dec, i32* %myjob.sroa.5.0.idx, align 4, !tbaa !21
  %20 = load i32* %myjob.sroa.3.0.idx20, align 4, !tbaa !17
  %21 = load i32* %myjob.sroa.4.0.idx21, align 4, !tbaa !19
  %cmp.i38 = icmp slt i32 %20, %21
  br i1 %cmp.i38, label %cond.true, label %_ZN4work7runningEv.exit42

_ZN4work7runningEv.exit42:                        ; preds = %if.end10
  %cmp2.i40 = icmp sgt i32 %dec, 0
  %cmp13 = icmp eq %struct.work* %15, %0
  %or.cond = or i1 %cmp2.i40, %cmp13
  br i1 %or.cond, label %cond.true, label %if.then14

if.then14:                                        ; preds = %_ZN4work7runningEv.exit42
  tail call x86_stdcallcc void @WakeAllConditionVariable(i64* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 3))
  br label %cond.true

while.end:                                        ; preds = %cond.end, %cond.false.us
  tail call x86_stdcallcc void @LeaveCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  ret i8* null
}

declare x86_stdcallcc void @SleepConditionVariableCS(i64*, %struct.CriticalSection*, i32) #0

define weak i32 @halide_do_par_for(i8* %user_context, i32 (i8*, i32, i8*)* %f, i32 %min, i32 %size, i8* %closure) #0 {
entry:
  %job = alloca %struct.work, align 4
  %0 = load i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)** @halide_custom_do_par_for, align 4, !tbaa !15
  %tobool = icmp eq i32 (i8*, i32 (i8*, i32, i8*)*, i32, i32, i8*)* %0, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %call = call i32 %0(i8* %user_context, i32 (i8*, i32, i8*)* %f, i32 %min, i32 %size, i8* %closure)
  br label %return

if.end:                                           ; preds = %entry
  %call1 = call x86_stdcallcc zeroext i1 @InitOnceExecuteOnce(i64* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 0), i1 (i64*, i8*, i8**)* @InitOnceCallback, i8* null, i8** null)
  call x86_stdcallcc void @EnterCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  %1 = load i8* @halide_thread_pool_initialized, align 1, !tbaa !1, !range !5
  %tobool2 = icmp eq i8 %1, 0
  br i1 %tobool2, label %if.then3, label %if.end21

if.then3:                                         ; preds = %if.end
  store i8 0, i8* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 5), align 4, !tbaa !6
  call x86_stdcallcc void @InitializeConditionVariable(i64* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 3))
  store %struct.work* null, %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 2), align 4, !tbaa !16
  %call4 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str, i32 0, i32 0))
  %tobool5 = icmp eq i8* %call4, null
  br i1 %tobool5, label %if.end8, label %if.end12

if.end8:                                          ; preds = %if.then3
  %call7 = call i8* @getenv(i8* getelementptr inbounds ([21 x i8]* @.str1, i32 0, i32 0))
  %tobool9 = icmp eq i8* %call7, null
  br i1 %tobool9, label %if.else14.thread, label %if.end12

if.else14.thread:                                 ; preds = %if.end8
  store i32 8, i32* @halide_threads, align 4, !tbaa !11
  br label %for.body

if.end12:                                         ; preds = %if.then3, %if.end8
  %threadStr.038 = phi i8* [ %call7, %if.end8 ], [ %call4, %if.then3 ]
  %call11 = call i32 @atoi(i8* %threadStr.038)
  store i32 %call11, i32* @halide_threads, align 4, !tbaa !11
  %cmp = icmp sgt i32 %call11, 64
  br i1 %cmp, label %if.then13, label %if.else14

if.then13:                                        ; preds = %if.end12
  store i32 64, i32* @halide_threads, align 4, !tbaa !11
  br label %for.body

if.else14:                                        ; preds = %if.end12
  %cmp15 = icmp slt i32 %call11, 1
  br i1 %cmp15, label %for.cond.preheader.thread47, label %for.cond.preheader

for.cond.preheader.thread47:                      ; preds = %if.else14
  store i32 1, i32* @halide_threads, align 4, !tbaa !11
  br label %for.end

for.cond.preheader:                               ; preds = %if.else14
  %sub42 = add nsw i32 %call11, -1
  %cmp1943 = icmp sgt i32 %sub42, 0
  br i1 %cmp1943, label %for.body, label %for.end

for.body:                                         ; preds = %if.else14.thread, %if.then13, %for.cond.preheader, %for.body
  %i.044 = phi i32 [ %inc, %for.body ], [ 0, %for.cond.preheader ], [ 0, %if.then13 ], [ 0, %if.else14.thread ]
  %call20 = call x86_stdcallcc i64 @CreateThread(i8* null, i32 0, i8* (i8*)* @halide_worker_thread, i8* null, i32 0, i32* null)
  %arrayidx = getelementptr inbounds %struct.anon* @halide_work_queue, i32 0, i32 4, i32 %i.044
  store i64 %call20, i64* %arrayidx, align 4, !tbaa !13
  %inc = add nsw i32 %i.044, 1
  %2 = load i32* @halide_threads, align 4, !tbaa !11
  %sub = add nsw i32 %2, -1
  %cmp19 = icmp slt i32 %inc, %sub
  br i1 %cmp19, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %for.cond.preheader.thread47, %for.cond.preheader
  store i8 1, i8* @halide_thread_pool_initialized, align 1, !tbaa !1
  br label %if.end21

if.end21:                                         ; preds = %if.end, %for.end
  %f22 = getelementptr inbounds %struct.work* %job, i32 0, i32 1
  store i32 (i8*, i32, i8*)* %f, i32 (i8*, i32, i8*)** %f22, align 4, !tbaa !23
  %user_context23 = getelementptr inbounds %struct.work* %job, i32 0, i32 2
  store i8* %user_context, i8** %user_context23, align 4, !tbaa !24
  %next = getelementptr inbounds %struct.work* %job, i32 0, i32 3
  store i32 %min, i32* %next, align 4, !tbaa !17
  %add = add nsw i32 %size, %min
  %max = getelementptr inbounds %struct.work* %job, i32 0, i32 4
  store i32 %add, i32* %max, align 4, !tbaa !19
  %closure24 = getelementptr inbounds %struct.work* %job, i32 0, i32 5
  store i8* %closure, i8** %closure24, align 4, !tbaa !25
  %exit_status = getelementptr inbounds %struct.work* %job, i32 0, i32 7
  store i32 0, i32* %exit_status, align 4, !tbaa !22
  %active_workers = getelementptr inbounds %struct.work* %job, i32 0, i32 6
  store i32 0, i32* %active_workers, align 4, !tbaa !21
  %3 = load %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 2), align 4, !tbaa !16
  %next_job = getelementptr inbounds %struct.work* %job, i32 0, i32 0
  store %struct.work* %3, %struct.work** %next_job, align 4, !tbaa !20
  store %struct.work* %job, %struct.work** getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 2), align 4, !tbaa !16
  call x86_stdcallcc void @LeaveCriticalSection(%struct.CriticalSection* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 1))
  call x86_stdcallcc void @WakeAllConditionVariable(i64* getelementptr inbounds (%struct.anon* @halide_work_queue, i32 0, i32 3))
  %4 = bitcast %struct.work* %job to i8*
  %call25 = call i8* @halide_worker_thread(i8* %4)
  %5 = load i32* %exit_status, align 4, !tbaa !22
  br label %return

return:                                           ; preds = %if.end21, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ %5, %if.end21 ]
  ret i32 %retval.0
}

declare x86_stdcallcc zeroext i1 @InitOnceExecuteOnce(i64*, i1 (i64*, i8*, i8**)*, i8*, i8**) #0

declare x86_stdcallcc void @InitializeConditionVariable(i64*) #0

; Function Attrs: nounwind readonly
declare i8* @getenv(i8* nocapture) #1

; Function Attrs: nounwind readonly
declare i32 @atoi(i8* nocapture) #1

declare x86_stdcallcc i64 @CreateThread(i8*, i32, i8* (i8*)*, i8*, i32, i32*) #0

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"bool", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{i8 0, i8 2}
!6 = metadata !{metadata !7, metadata !2, i64 572}
!7 = metadata !{metadata !"_ZTS3$_0", metadata !8, i64 0, metadata !9, i64 8, metadata !10, i64 48, metadata !8, i64 52, metadata !3, i64 60, metadata !2, i64 572}
!8 = metadata !{metadata !"long long", metadata !3, i64 0}
!9 = metadata !{metadata !"_ZTS15CriticalSection", metadata !3, i64 0}
!10 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!11 = metadata !{metadata !12, metadata !12, i64 0}
!12 = metadata !{metadata !"int", metadata !3, i64 0}
!13 = metadata !{metadata !8, metadata !8, i64 0}
!14 = metadata !{metadata !7, metadata !8, i64 0}
!15 = metadata !{metadata !10, metadata !10, i64 0}
!16 = metadata !{metadata !7, metadata !10, i64 48}
!17 = metadata !{metadata !18, metadata !12, i64 12}
!18 = metadata !{metadata !"_ZTS4work", metadata !10, i64 0, metadata !10, i64 4, metadata !10, i64 8, metadata !12, i64 12, metadata !12, i64 16, metadata !10, i64 20, metadata !12, i64 24, metadata !12, i64 28}
!19 = metadata !{metadata !18, metadata !12, i64 16}
!20 = metadata !{metadata !18, metadata !10, i64 0}
!21 = metadata !{metadata !18, metadata !12, i64 24}
!22 = metadata !{metadata !18, metadata !12, i64 28}
!23 = metadata !{metadata !18, metadata !10, i64 4}
!24 = metadata !{metadata !18, metadata !10, i64 8}
!25 = metadata !{metadata !18, metadata !10, i64 20}
