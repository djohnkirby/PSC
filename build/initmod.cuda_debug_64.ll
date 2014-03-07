; ModuleID = 'src/runtime/cuda_debug.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.CUctx_st = type opaque
%struct._module_state_ = type { %struct.CUmod_st*, %struct._module_state_* }
%struct.CUmod_st = type opaque
%struct.CUevent_st = type opaque
%struct.buffer_t = type { i64, i8*, [4 x i32], [4 x i32], [4 x i32], i32, i8, i8 }
%struct.CUstream_st = type opaque
%struct.CUfunc_st = type opaque

@weak_cuda_ctx = weak global %struct.CUctx_st* null, align 8
@cuda_ctx_ptr = weak global %struct.CUctx_st** null, align 8
@state_list = weak global %struct._module_state_* null, align 8
@.str = private unnamed_addr constant [58 x i8] c"Bad device pointer %p: cuPointerGetAttribute returned %d\0A\00", align 1
@.str1 = private unnamed_addr constant [31 x i8] c"In dev_free of %p - dev: 0x%p\0A\00", align 1
@.str2 = private unnamed_addr constant [47 x i8] c"halide_validate_dev_pointer(user_context, buf)\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"Do %s\0A\00", align 1
@.str4 = private unnamed_addr constant [10 x i8] c"cuMemFree\00", align 1
@.str5 = private unnamed_addr constant [35 x i8] c"CUDA: %s returned non-success: %d\0A\00", align 1
@.str6 = private unnamed_addr constant [23 x i8] c"status == CUDA_SUCCESS\00", align 1
@.str7 = private unnamed_addr constant [7 x i8] c"cuInit\00", align 1
@.str8 = private unnamed_addr constant [17 x i8] c"cuDeviceGetCount\00", align 1
@.str9 = private unnamed_addr constant [16 x i8] c"deviceCount > 0\00", align 1
@.str10 = private unnamed_addr constant [14 x i8] c"HL_GPU_DEVICE\00", align 1
@.str11 = private unnamed_addr constant [51 x i8] c"status == CUDA_SUCCESS && \22Failed to get device\5Cn\22\00", align 1
@.str12 = private unnamed_addr constant [49 x i8] c"Got device %d, about to create context (t=%lld)\0A\00", align 1
@.str13 = private unnamed_addr constant [12 x i8] c"cuCtxCreate\00", align 1
@.str14 = private unnamed_addr constant [17 x i8] c"cuModuleLoadData\00", align 1
@.str15 = private unnamed_addr constant [36 x i8] c"-------\0ACompiling PTX:\0A%s\0A--------\0A\00", align 1
@_Z7__start = internal global %struct.CUevent_st* null, align 8
@_Z5__end = internal global %struct.CUevent_st* null, align 8
@.str16 = private unnamed_addr constant [25 x i8] c"cuCtxSynchronize on exit\00", align 1
@.str17 = private unnamed_addr constant [61 x i8] c"status == CUDA_SUCCESS || status == CUDA_ERROR_DEINITIALIZED\00", align 1
@.str18 = private unnamed_addr constant [15 x i8] c"cuModuleUnload\00", align 1
@.str19 = private unnamed_addr constant [21 x i8] c"cuCtxDestroy on exit\00", align 1
@.str20 = private unnamed_addr constant [117 x i8] c"dev_malloc allocating buffer of %zd bytes, extents: %zdx%zdx%zdx%zd strides: %zdx%zdx%zdx%zd (%d bytes per element)\0A\00", align 1
@.str21 = private unnamed_addr constant [11 x i8] c"dev_malloc\00", align 1
@.str22 = private unnamed_addr constant [24 x i8] c"   (took %fms, t=%lld)\0A\00", align 1
@.str23 = private unnamed_addr constant [9 x i8] c"buf->dev\00", align 1
@.str24 = private unnamed_addr constant [22 x i8] c"buf->host && buf->dev\00", align 1
@.str25 = private unnamed_addr constant [42 x i8] c"copy_to_dev (%zu bytes) %p -> %p (t=%lld)\00", align 1
@.str26 = private unnamed_addr constant [10 x i8] c"buf->host\00", align 1
@.str27 = private unnamed_addr constant [34 x i8] c"copy_to_host (%zu bytes) %p -> %p\00", align 1
@.str28 = private unnamed_addr constant [10 x i8] c"state_ptr\00", align 1
@.str29 = private unnamed_addr constant [4 x i8] c"mod\00", align 1
@.str30 = private unnamed_addr constant [71 x i8] c"dev_run %s with (%dx%dx%d) blks, (%dx%dx%d) threads, %d shmem (t=%lld)\00", align 1
@.str31 = private unnamed_addr constant [23 x i8] c"get_kernel %s (t=%lld)\00", align 1
@.str32 = private unnamed_addr constant [5 x i8] c"size\00", align 1

; Function Attrs: uwtable
define weak void @halide_set_cuda_context(%struct.CUctx_st** %ctx_ptr) #0 {
entry:
  store %struct.CUctx_st** %ctx_ptr, %struct.CUctx_st*** @cuda_ctx_ptr, align 8, !tbaa !1
  ret void
}

; Function Attrs: uwtable
define weak zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %ctx = alloca %struct.CUctx_st*, align 8
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %0 = load i64* %dev, align 8, !tbaa !5
  %cmp = icmp eq i64 %0, 0
  br i1 %cmp, label %return, label %if.end

if.end:                                           ; preds = %entry
  %1 = bitcast %struct.CUctx_st** %ctx to i8*
  %call = call i32 @cuPointerGetAttribute(i8* %1, i32 1, i64 %0)
  %tobool = icmp eq i32 %call, 0
  br i1 %tobool, label %return, label %if.then2

if.then2:                                         ; preds = %if.end
  %2 = load i64* %dev, align 8, !tbaa !5
  %3 = inttoptr i64 %2 to i8*
  %call4 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([58 x i8]* @.str, i64 0, i64 0), i8* %3, i32 %call)
  br label %return

return:                                           ; preds = %if.end, %entry, %if.then2
  %retval.0 = phi i1 [ false, %if.then2 ], [ true, %entry ], [ true, %if.end ]
  ret i1 %retval.0
}

declare i32 @cuPointerGetAttribute(i8*, i32, i64) #1

declare i32 @halide_printf(i8*, i8*, ...) #1

; Function Attrs: uwtable
define weak void @halide_dev_free(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %0 = load i64* %dev, align 8, !tbaa !5
  %cmp = icmp eq i64 %0, 0
  br i1 %cmp, label %return, label %if.end

if.end:                                           ; preds = %entry
  %1 = inttoptr i64 %0 to i8*
  %call = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([31 x i8]* @.str1, i64 0, i64 0), %struct.buffer_t* %buf, i8* %1)
  %call2 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf)
  br i1 %call2, label %do.body, label %if.then3

if.then3:                                         ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i64 0, i64 0))
  br label %do.body

do.body:                                          ; preds = %if.end, %if.then3
  %call5 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* getelementptr inbounds ([10 x i8]* @.str4, i64 0, i64 0))
  %2 = load i64* %dev, align 8, !tbaa !5
  %call7 = tail call i32 @cuMemFree_v2(i64 %2)
  %cond = icmp eq i32 %call7, 0
  br i1 %cond, label %do.end, label %if.then9

if.then9:                                         ; preds = %do.body
  %call10 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([10 x i8]* @.str4, i64 0, i64 0), i32 %call7)
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %do.body, %if.then9
  store i64 0, i64* %dev, align 8, !tbaa !5
  br label %return

return:                                           ; preds = %entry, %do.end
  ret void
}

declare void @halide_error(i8*, i8*) #1

declare i32 @cuMemFree_v2(i64) #1

; Function Attrs: uwtable
define weak i8* @halide_init_kernels(i8* %user_context, i8* %state_ptr, i8* %ptx_src, i32 %size) #0 {
entry:
  %deviceCount = alloca i32, align 4
  %dev = alloca i32, align 4
  %0 = load %struct.CUctx_st*** @cuda_ctx_ptr, align 8, !tbaa !1
  %cmp = icmp eq %struct.CUctx_st** %0, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store %struct.CUctx_st** @weak_cuda_ctx, %struct.CUctx_st*** @cuda_ctx_ptr, align 8, !tbaa !1
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %1 = phi %struct.CUctx_st** [ @weak_cuda_ctx, %if.then ], [ %0, %entry ]
  %2 = load %struct.CUctx_st** %1, align 8, !tbaa !1
  %cmp1 = icmp eq %struct.CUctx_st* %2, null
  br i1 %cmp1, label %do.body, label %if.end58

do.body:                                          ; preds = %if.end
  %call = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8]* @.str7, i64 0, i64 0))
  %call3 = call i32 @cuInit(i32 0)
  %cond = icmp eq i32 %call3, 0
  br i1 %cond, label %do.end, label %if.then5

if.then5:                                         ; preds = %do.body
  %call6 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8]* @.str7, i64 0, i64 0), i32 %call3)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %do.body, %if.then5
  store i32 0, i32* %deviceCount, align 4, !tbaa !10
  %call12 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* getelementptr inbounds ([17 x i8]* @.str8, i64 0, i64 0))
  %call14 = call i32 @cuDeviceGetCount(i32* %deviceCount)
  %cond121 = icmp eq i32 %call14, 0
  br i1 %cond121, label %do.end22, label %if.then16

if.then16:                                        ; preds = %do.end
  %call17 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([17 x i8]* @.str8, i64 0, i64 0), i32 %call14)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %do.end22

do.end22:                                         ; preds = %do.end, %if.then16
  %3 = load i32* %deviceCount, align 4, !tbaa !10
  %cmp23 = icmp sgt i32 %3, 0
  br i1 %cmp23, label %if.end25, label %if.then24

if.then24:                                        ; preds = %do.end22
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([16 x i8]* @.str9, i64 0, i64 0))
  br label %if.end25

if.end25:                                         ; preds = %if.then24, %do.end22
  %call26 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str10, i64 0, i64 0))
  %tobool = icmp eq i8* %call26, null
  br i1 %tobool, label %if.else, label %if.end39

if.else:                                          ; preds = %if.end25
  %4 = load i32* %deviceCount, align 4, !tbaa !10
  %cmp31 = icmp sgt i32 %4, 2
  br i1 %cmp31, label %if.then32, label %for.cond

if.then32:                                        ; preds = %if.else
  store i32 2, i32* %deviceCount, align 4, !tbaa !10
  br label %for.cond

for.cond:                                         ; preds = %if.else, %if.then32, %for.body
  %id.0.in = phi i32 [ %id.0, %for.body ], [ %4, %if.else ], [ 2, %if.then32 ]
  %id.0 = add nsw i32 %id.0.in, -1
  %cmp34 = icmp sgt i32 %id.0.in, 0
  br i1 %cmp34, label %for.body, label %if.then41

for.body:                                         ; preds = %for.cond
  %call35 = call i32 @cuDeviceGet(i32* %dev, i32 %id.0)
  %cmp36 = icmp eq i32 %call35, 0
  br i1 %cmp36, label %if.end42, label %for.cond

if.end39:                                         ; preds = %if.end25
  %call29 = call i32 @atoi(i8* %call26)
  %call30 = call i32 @cuDeviceGet(i32* %dev, i32 %call29)
  %cmp40 = icmp eq i32 %call30, 0
  br i1 %cmp40, label %if.end42, label %if.then41

if.then41:                                        ; preds = %for.cond, %if.end39
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([51 x i8]* @.str11, i64 0, i64 0))
  br label %if.end42

if.end42:                                         ; preds = %for.body, %if.then41, %if.end39
  %5 = load i32* %dev, align 4, !tbaa !10
  %call43 = call i64 @halide_current_time_ns(i8* %user_context)
  %call44 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([49 x i8]* @.str12, i64 0, i64 0), i32 %5, i64 %call43)
  %call46 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* getelementptr inbounds ([12 x i8]* @.str13, i64 0, i64 0))
  %6 = load %struct.CUctx_st*** @cuda_ctx_ptr, align 8, !tbaa !1
  %7 = load i32* %dev, align 4, !tbaa !10
  %call48 = call i32 @cuCtxCreate_v2(%struct.CUctx_st** %6, i32 0, i32 %7)
  %cond122 = icmp eq i32 %call48, 0
  br i1 %cond122, label %if.end58, label %if.then50

if.then50:                                        ; preds = %if.end42
  %call51 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([12 x i8]* @.str13, i64 0, i64 0), i32 %call48)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %if.end58

if.end58:                                         ; preds = %if.end42, %if.end, %if.then50
  %8 = bitcast i8* %state_ptr to %struct._module_state_*
  %tobool59 = icmp eq i8* %state_ptr, null
  br i1 %tobool59, label %if.then60, label %if.end62

if.then60:                                        ; preds = %if.end58
  %call61 = call i8* @malloc(i64 16)
  %9 = bitcast i8* %call61 to %struct._module_state_*
  %module = bitcast i8* %call61 to %struct.CUmod_st**
  store %struct.CUmod_st* null, %struct.CUmod_st** %module, align 8, !tbaa !11
  %10 = load %struct._module_state_** @state_list, align 8, !tbaa !1
  %next = getelementptr inbounds i8* %call61, i64 8
  %11 = bitcast i8* %next to %struct._module_state_**
  store %struct._module_state_* %10, %struct._module_state_** %11, align 8, !tbaa !13
  store %struct._module_state_* %9, %struct._module_state_** @state_list, align 8, !tbaa !1
  br label %if.end62

if.end62:                                         ; preds = %if.end58, %if.then60
  %state.0 = phi %struct._module_state_* [ %8, %if.end58 ], [ %9, %if.then60 ]
  %module63 = getelementptr inbounds %struct._module_state_* %state.0, i64 0, i32 0
  %12 = load %struct.CUmod_st** %module63, align 8, !tbaa !11
  %tobool64 = icmp eq %struct.CUmod_st* %12, null
  br i1 %tobool64, label %do.body66, label %if.end80

do.body66:                                        ; preds = %if.end62
  %call67 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* getelementptr inbounds ([17 x i8]* @.str14, i64 0, i64 0))
  %call70 = call i32 @cuModuleLoadData(%struct.CUmod_st** %module63, i8* %ptx_src)
  %cond123 = icmp eq i32 %call70, 0
  br i1 %cond123, label %do.end78, label %if.then72

if.then72:                                        ; preds = %do.body66
  %call73 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([17 x i8]* @.str14, i64 0, i64 0), i32 %call70)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %do.end78

do.end78:                                         ; preds = %do.body66, %if.then72
  %call79 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([36 x i8]* @.str15, i64 0, i64 0), i8* %ptx_src)
  br label %if.end80

if.end80:                                         ; preds = %if.end62, %do.end78
  %13 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %tobool81 = icmp eq %struct.CUevent_st* %13, null
  br i1 %tobool81, label %if.then82, label %if.end85

if.then82:                                        ; preds = %if.end80
  %call83 = call i32 @cuEventCreate(%struct.CUevent_st** @_Z7__start, i32 0)
  %call84 = call i32 @cuEventCreate(%struct.CUevent_st** @_Z5__end, i32 0)
  br label %if.end85

if.end85:                                         ; preds = %if.end80, %if.then82
  %14 = bitcast %struct._module_state_* %state.0 to i8*
  ret i8* %14
}

declare i32 @cuInit(i32) #1

declare i32 @cuDeviceGetCount(i32*) #1

; Function Attrs: nounwind readonly
declare i8* @getenv(i8* nocapture) #2

declare i32 @cuDeviceGet(i32*, i32) #1

; Function Attrs: nounwind readonly
declare i32 @atoi(i8* nocapture) #2

declare i64 @halide_current_time_ns(i8*) #1

declare i32 @cuCtxCreate_v2(%struct.CUctx_st**, i32, i32) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #3

declare i32 @cuModuleLoadData(%struct.CUmod_st**, i8*) #1

declare i32 @cuEventCreate(%struct.CUevent_st**, i32) #1

; Function Attrs: uwtable
define weak void @halide_release(i8* %user_context) #0 {
entry:
  %0 = load %struct.CUctx_st*** @cuda_ctx_ptr, align 8, !tbaa !1
  %cmp = icmp eq %struct.CUctx_st** %0, null
  br i1 %cmp, label %if.end55, label %do.body

do.body:                                          ; preds = %entry
  %call = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* getelementptr inbounds ([25 x i8]* @.str16, i64 0, i64 0))
  %call1 = tail call i32 @cuCtxSynchronize()
  switch i32 %call1, label %if.then4 [
    i32 4, label %if.end
    i32 0, label %if.end
  ]

if.then4:                                         ; preds = %do.body
  %call5 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([25 x i8]* @.str16, i64 0, i64 0), i32 %call1)
  br label %if.end

if.end:                                           ; preds = %do.body, %do.body, %if.then4
  %1 = and i32 %call1, -5
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %do.end, label %if.then8

if.then8:                                         ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([61 x i8]* @.str17, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %if.end, %if.then8
  %3 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %tobool = icmp eq %struct.CUevent_st* %3, null
  br i1 %tobool, label %while.cond.preheader, label %if.then10

if.then10:                                        ; preds = %do.end
  %call11 = tail call i32 @cuEventDestroy_v2(%struct.CUevent_st* %3)
  %4 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call12 = tail call i32 @cuEventDestroy_v2(%struct.CUevent_st* %4)
  store %struct.CUevent_st* null, %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  store %struct.CUevent_st* null, %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  br label %while.cond.preheader

while.cond.preheader:                             ; preds = %do.end, %if.then10
  %state.085 = load %struct._module_state_** @state_list, align 8
  %tobool1486 = icmp eq %struct._module_state_* %state.085, null
  br i1 %tobool1486, label %while.end, label %while.body

while.body:                                       ; preds = %while.cond.preheader, %if.end35
  %state.087 = phi %struct._module_state_* [ %state.0, %if.end35 ], [ %state.085, %while.cond.preheader ]
  %module = getelementptr inbounds %struct._module_state_* %state.087, i64 0, i32 0
  %5 = load %struct.CUmod_st** %module, align 8, !tbaa !11
  %tobool15 = icmp eq %struct.CUmod_st* %5, null
  br i1 %tobool15, label %if.end35, label %do.body17

do.body17:                                        ; preds = %while.body
  %call18 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* getelementptr inbounds ([15 x i8]* @.str18, i64 0, i64 0))
  %6 = load %struct.CUmod_st** %module, align 8, !tbaa !11
  %call21 = tail call i32 @cuModuleUnload(%struct.CUmod_st* %6)
  switch i32 %call21, label %if.then25 [
    i32 4, label %if.end27
    i32 0, label %if.end27
  ]

if.then25:                                        ; preds = %do.body17
  %call26 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([15 x i8]* @.str18, i64 0, i64 0), i32 %call21)
  br label %if.end27

if.end27:                                         ; preds = %do.body17, %do.body17, %if.then25
  %7 = and i32 %call21, -5
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %do.end33, label %if.then31

if.then31:                                        ; preds = %if.end27
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([61 x i8]* @.str17, i64 0, i64 0))
  br label %do.end33

do.end33:                                         ; preds = %if.end27, %if.then31
  store %struct.CUmod_st* null, %struct.CUmod_st** %module, align 8, !tbaa !11
  br label %if.end35

if.end35:                                         ; preds = %while.body, %do.end33
  %next = getelementptr inbounds %struct._module_state_* %state.087, i64 0, i32 1
  %state.0 = load %struct._module_state_** %next, align 8
  %tobool14 = icmp eq %struct._module_state_* %state.0, null
  br i1 %tobool14, label %while.end, label %while.body

while.end:                                        ; preds = %if.end35, %while.cond.preheader
  %9 = load %struct.CUctx_st** @weak_cuda_ctx, align 8, !tbaa !1
  %tobool36 = icmp eq %struct.CUctx_st* %9, null
  br i1 %tobool36, label %if.end54, label %do.body38

do.body38:                                        ; preds = %while.end
  %call39 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* getelementptr inbounds ([21 x i8]* @.str19, i64 0, i64 0))
  %10 = load %struct.CUctx_st** @weak_cuda_ctx, align 8, !tbaa !1
  %call41 = tail call i32 @cuCtxDestroy_v2(%struct.CUctx_st* %10)
  switch i32 %call41, label %if.then45 [
    i32 4, label %if.end47
    i32 0, label %if.end47
  ]

if.then45:                                        ; preds = %do.body38
  %call46 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([21 x i8]* @.str19, i64 0, i64 0), i32 %call41)
  br label %if.end47

if.end47:                                         ; preds = %do.body38, %do.body38, %if.then45
  %11 = and i32 %call41, -5
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %do.end53, label %if.then51

if.then51:                                        ; preds = %if.end47
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([61 x i8]* @.str17, i64 0, i64 0))
  br label %do.end53

do.end53:                                         ; preds = %if.end47, %if.then51
  store %struct.CUctx_st* null, %struct.CUctx_st** @weak_cuda_ctx, align 8, !tbaa !1
  br label %if.end54

if.end54:                                         ; preds = %while.end, %do.end53
  store %struct.CUctx_st** null, %struct.CUctx_st*** @cuda_ctx_ptr, align 8, !tbaa !1
  br label %if.end55

if.end55:                                         ; preds = %entry, %if.end54
  ret void
}

declare i32 @cuCtxSynchronize() #1

declare i32 @cuEventDestroy_v2(%struct.CUevent_st*) #1

declare i32 @cuModuleUnload(%struct.CUmod_st*) #1

declare i32 @cuCtxDestroy_v2(%struct.CUctx_st*) #1

; Function Attrs: uwtable
define weak void @halide_dev_malloc(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %p = alloca i64, align 8
  %msec = alloca float, align 4
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %0 = load i64* %dev, align 8, !tbaa !5
  %tobool = icmp eq i64 %0, 0
  br i1 %tobool, label %if.end, label %if.end38

if.end:                                           ; preds = %entry
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 5
  %1 = load i32* %elem_size.i, align 4, !tbaa !14
  %arrayidx.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 0
  %2 = load i32* %arrayidx.i, align 4, !tbaa !10
  %mul.i = mul nsw i32 %2, %1
  %arrayidx2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 0
  %3 = load i32* %arrayidx2.i, align 4, !tbaa !10
  %mul3.i = mul nsw i32 %mul.i, %3
  %conv4.i = sext i32 %mul3.i to i64
  %arrayidx.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 1
  %4 = load i32* %arrayidx.1.i, align 4, !tbaa !10
  %mul.1.i = mul nsw i32 %4, %1
  %arrayidx2.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 1
  %5 = load i32* %arrayidx2.1.i, align 4, !tbaa !10
  %mul3.1.i = mul nsw i32 %mul.1.i, %5
  %conv4.1.i = sext i32 %mul3.1.i to i64
  %cmp5.1.i = icmp ugt i64 %conv4.1.i, %conv4.i
  %conv4.size.0.1.i = select i1 %cmp5.1.i, i64 %conv4.1.i, i64 %conv4.i
  %arrayidx.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 2
  %6 = load i32* %arrayidx.2.i, align 4, !tbaa !10
  %mul.2.i = mul nsw i32 %6, %1
  %arrayidx2.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 2
  %7 = load i32* %arrayidx2.2.i, align 4, !tbaa !10
  %mul3.2.i = mul nsw i32 %mul.2.i, %7
  %conv4.2.i = sext i32 %mul3.2.i to i64
  %cmp5.2.i = icmp ugt i64 %conv4.2.i, %conv4.size.0.1.i
  %conv4.size.0.2.i = select i1 %cmp5.2.i, i64 %conv4.2.i, i64 %conv4.size.0.1.i
  %arrayidx.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 3
  %8 = load i32* %arrayidx.3.i, align 4, !tbaa !10
  %mul.3.i = mul nsw i32 %8, %1
  %arrayidx2.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 3
  %9 = load i32* %arrayidx2.3.i, align 4, !tbaa !10
  %mul3.3.i = mul nsw i32 %mul.3.i, %9
  %conv4.3.i = sext i32 %mul3.3.i to i64
  %cmp5.3.i = icmp ugt i64 %conv4.3.i, %conv4.size.0.2.i
  %conv4.size.0.3.i = select i1 %cmp5.3.i, i64 %conv4.3.i, i64 %conv4.size.0.2.i
  %tobool.i = icmp eq i64 %conv4.size.0.3.i, 0
  br i1 %tobool.i, label %if.then6.i, label %_Z10__buf_sizePvP8buffer_t.exit

if.then6.i:                                       ; preds = %if.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str32, i64 0, i64 0))
  %.pre = load i32* %arrayidx.i, align 4, !tbaa !10
  %.pre64 = load i32* %arrayidx.1.i, align 4, !tbaa !10
  %.pre65 = load i32* %arrayidx.2.i, align 4, !tbaa !10
  %.pre66 = load i32* %arrayidx.3.i, align 4, !tbaa !10
  %.pre67 = load i32* %arrayidx2.i, align 4, !tbaa !10
  %.pre68 = load i32* %arrayidx2.1.i, align 4, !tbaa !10
  %.pre69 = load i32* %arrayidx2.2.i, align 4, !tbaa !10
  %.pre70 = load i32* %arrayidx2.3.i, align 4, !tbaa !10
  %.pre71 = load i32* %elem_size.i, align 4, !tbaa !14
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then6.i
  %10 = phi i32 [ %1, %if.end ], [ %.pre71, %if.then6.i ]
  %11 = phi i32 [ %9, %if.end ], [ %.pre70, %if.then6.i ]
  %12 = phi i32 [ %7, %if.end ], [ %.pre69, %if.then6.i ]
  %13 = phi i32 [ %5, %if.end ], [ %.pre68, %if.then6.i ]
  %14 = phi i32 [ %3, %if.end ], [ %.pre67, %if.then6.i ]
  %15 = phi i32 [ %8, %if.end ], [ %.pre66, %if.then6.i ]
  %16 = phi i32 [ %6, %if.end ], [ %.pre65, %if.then6.i ]
  %17 = phi i32 [ %4, %if.end ], [ %.pre64, %if.then6.i ]
  %18 = phi i32 [ %2, %if.end ], [ %.pre, %if.then6.i ]
  %call14 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([117 x i8]* @.str20, i64 0, i64 0), i64 %conv4.size.0.3.i, i32 %18, i32 %17, i32 %16, i32 %15, i32 %14, i32 %13, i32 %12, i32 %11, i32 %10)
  %19 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %call15 = call i32 @cuEventRecord(%struct.CUevent_st* %19, %struct.CUstream_st* null)
  %call17 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* getelementptr inbounds ([11 x i8]* @.str21, i64 0, i64 0))
  %call18 = call i32 @cuMemAlloc_v2(i64* %p, i64 %conv4.size.0.3.i)
  %cond = icmp eq i32 %call18, 0
  br i1 %cond, label %do.end, label %if.then19

if.then19:                                        ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  %call20 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([11 x i8]* @.str21, i64 0, i64 0), i32 %call18)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %_Z10__buf_sizePvP8buffer_t.exit, %if.then19
  %20 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call25 = call i32 @cuEventRecord(%struct.CUevent_st* %20, %struct.CUstream_st* null)
  %21 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call26 = call i32 @cuEventSynchronize(%struct.CUevent_st* %21)
  %22 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %23 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call27 = call i32 @cuEventElapsedTime(float* %msec, %struct.CUevent_st* %22, %struct.CUevent_st* %23)
  %24 = load float* %msec, align 4, !tbaa !15
  %conv = fpext float %24 to double
  %call28 = call i64 @halide_current_time_ns(i8* %user_context)
  %call29 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([24 x i8]* @.str22, i64 0, i64 0), double %conv, i64 %call28)
  %25 = load i64* %p, align 8, !tbaa !17
  store i64 %25, i64* %dev, align 8, !tbaa !5
  %tobool33 = icmp eq i64 %25, 0
  br i1 %tobool33, label %if.then34, label %if.end35

if.then34:                                        ; preds = %do.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str23, i64 0, i64 0))
  br label %if.end35

if.end35:                                         ; preds = %do.end, %if.then34
  %call36 = call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf)
  br i1 %call36, label %if.end38, label %if.then37

if.then37:                                        ; preds = %if.end35
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i64 0, i64 0))
  br label %if.end38

if.end38:                                         ; preds = %entry, %if.then37, %if.end35
  ret void
}

declare i32 @cuEventRecord(%struct.CUevent_st*, %struct.CUstream_st*) #1

declare i32 @cuMemAlloc_v2(i64*, i64) #1

declare i32 @cuEventSynchronize(%struct.CUevent_st*) #1

declare i32 @cuEventElapsedTime(float*, %struct.CUevent_st*, %struct.CUevent_st*) #1

; Function Attrs: uwtable
define weak void @halide_copy_to_dev(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %msg = alloca [256 x i8], align 16
  %msec = alloca float, align 4
  %host_dirty = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 6
  %0 = load i8* %host_dirty, align 1, !tbaa !18, !range !19
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end32, label %if.then

if.then:                                          ; preds = %entry
  %host = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 1
  %1 = load i8** %host, align 8, !tbaa !20
  %tobool1 = icmp eq i8* %1, null
  br i1 %tobool1, label %if.then3, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.then
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %2 = load i64* %dev, align 8, !tbaa !5
  %tobool2 = icmp eq i64 %2, 0
  br i1 %tobool2, label %if.then3, label %if.end

if.then3:                                         ; preds = %land.lhs.true, %if.then
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str24, i64 0, i64 0))
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then3
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 5
  %3 = load i32* %elem_size.i, align 4, !tbaa !14
  %arrayidx.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 0
  %4 = load i32* %arrayidx.i, align 4, !tbaa !10
  %mul.i = mul nsw i32 %4, %3
  %arrayidx2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 0
  %5 = load i32* %arrayidx2.i, align 4, !tbaa !10
  %mul3.i = mul nsw i32 %mul.i, %5
  %conv4.i = sext i32 %mul3.i to i64
  %arrayidx.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 1
  %6 = load i32* %arrayidx.1.i, align 4, !tbaa !10
  %mul.1.i = mul nsw i32 %6, %3
  %arrayidx2.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 1
  %7 = load i32* %arrayidx2.1.i, align 4, !tbaa !10
  %mul3.1.i = mul nsw i32 %mul.1.i, %7
  %conv4.1.i = sext i32 %mul3.1.i to i64
  %cmp5.1.i = icmp ugt i64 %conv4.1.i, %conv4.i
  %conv4.size.0.1.i = select i1 %cmp5.1.i, i64 %conv4.1.i, i64 %conv4.i
  %arrayidx.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 2
  %8 = load i32* %arrayidx.2.i, align 4, !tbaa !10
  %mul.2.i = mul nsw i32 %8, %3
  %arrayidx2.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 2
  %9 = load i32* %arrayidx2.2.i, align 4, !tbaa !10
  %mul3.2.i = mul nsw i32 %mul.2.i, %9
  %conv4.2.i = sext i32 %mul3.2.i to i64
  %cmp5.2.i = icmp ugt i64 %conv4.2.i, %conv4.size.0.1.i
  %conv4.size.0.2.i = select i1 %cmp5.2.i, i64 %conv4.2.i, i64 %conv4.size.0.1.i
  %arrayidx.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 3
  %10 = load i32* %arrayidx.3.i, align 4, !tbaa !10
  %mul.3.i = mul nsw i32 %10, %3
  %arrayidx2.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 3
  %11 = load i32* %arrayidx2.3.i, align 4, !tbaa !10
  %mul3.3.i = mul nsw i32 %mul.3.i, %11
  %conv4.3.i = sext i32 %mul3.3.i to i64
  %cmp5.3.i = icmp ugt i64 %conv4.3.i, %conv4.size.0.2.i
  %conv4.size.0.3.i = select i1 %cmp5.3.i, i64 %conv4.3.i, i64 %conv4.size.0.2.i
  %tobool.i = icmp eq i64 %conv4.size.0.3.i, 0
  br i1 %tobool.i, label %if.then6.i, label %_Z10__buf_sizePvP8buffer_t.exit

if.then6.i:                                       ; preds = %if.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str32, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then6.i
  %12 = getelementptr inbounds [256 x i8]* %msg, i64 0, i64 0
  call void @llvm.lifetime.start(i64 256, i8* %12) #4
  %13 = load i8** %host, align 8, !tbaa !20
  %dev5 = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %14 = load i64* %dev5, align 8, !tbaa !5
  %15 = inttoptr i64 %14 to i8*
  %call6 = call i64 @halide_current_time_ns(i8* %user_context)
  %call7 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %12, i64 256, i8* getelementptr inbounds ([42 x i8]* @.str25, i64 0, i64 0), i64 %conv4.size.0.3.i, i8* %13, i8* %15, i64 %call6)
  %call8 = call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf)
  br i1 %call8, label %do.body, label %if.then9

if.then9:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i64 0, i64 0))
  br label %do.body

do.body:                                          ; preds = %_Z10__buf_sizePvP8buffer_t.exit, %if.then9
  %16 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %call11 = call i32 @cuEventRecord(%struct.CUevent_st* %16, %struct.CUstream_st* null)
  %call14 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* %12)
  %17 = load i64* %dev5, align 8, !tbaa !5
  %18 = load i8** %host, align 8, !tbaa !20
  %call17 = call i32 @cuMemcpyHtoD_v2(i64 %17, i8* %18, i64 %conv4.size.0.3.i)
  %cond = icmp eq i32 %call17, 0
  br i1 %cond, label %do.end, label %if.then18

if.then18:                                        ; preds = %do.body
  %call20 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* %12, i32 %call17)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %do.body, %if.then18
  %19 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call25 = call i32 @cuEventRecord(%struct.CUevent_st* %19, %struct.CUstream_st* null)
  %20 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call26 = call i32 @cuEventSynchronize(%struct.CUevent_st* %20)
  %21 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %22 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call27 = call i32 @cuEventElapsedTime(float* %msec, %struct.CUevent_st* %21, %struct.CUevent_st* %22)
  %23 = load float* %msec, align 4, !tbaa !15
  %conv = fpext float %23 to double
  %call28 = call i64 @halide_current_time_ns(i8* %user_context)
  %call29 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([24 x i8]* @.str22, i64 0, i64 0), double %conv, i64 %call28)
  call void @llvm.lifetime.end(i64 256, i8* %12) #4
  br label %if.end32

if.end32:                                         ; preds = %entry, %do.end
  store i8 0, i8* %host_dirty, align 1, !tbaa !18
  ret void
}

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #4

; Function Attrs: nounwind
declare i32 @snprintf(i8* nocapture, i64, i8* nocapture readonly, ...) #3

declare i32 @cuMemcpyHtoD_v2(i64, i8*, i64) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #4

; Function Attrs: uwtable
define weak void @halide_copy_to_host(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %msg = alloca [256 x i8], align 16
  %msec = alloca float, align 4
  %dev_dirty = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 7
  %0 = load i8* %dev_dirty, align 1, !tbaa !21, !range !19
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end33, label %if.then

if.then:                                          ; preds = %entry
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %1 = load i64* %dev, align 8, !tbaa !5
  %tobool1 = icmp eq i64 %1, 0
  br i1 %tobool1, label %if.then2, label %if.end

if.then2:                                         ; preds = %if.then
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str23, i64 0, i64 0))
  br label %if.end

if.end:                                           ; preds = %if.then, %if.then2
  %host = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 1
  %2 = load i8** %host, align 8, !tbaa !20
  %tobool3 = icmp eq i8* %2, null
  br i1 %tobool3, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([10 x i8]* @.str26, i64 0, i64 0))
  br label %if.end5

if.end5:                                          ; preds = %if.end, %if.then4
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 5
  %3 = load i32* %elem_size.i, align 4, !tbaa !14
  %arrayidx.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 0
  %4 = load i32* %arrayidx.i, align 4, !tbaa !10
  %mul.i = mul nsw i32 %4, %3
  %arrayidx2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 0
  %5 = load i32* %arrayidx2.i, align 4, !tbaa !10
  %mul3.i = mul nsw i32 %mul.i, %5
  %conv4.i = sext i32 %mul3.i to i64
  %arrayidx.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 1
  %6 = load i32* %arrayidx.1.i, align 4, !tbaa !10
  %mul.1.i = mul nsw i32 %6, %3
  %arrayidx2.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 1
  %7 = load i32* %arrayidx2.1.i, align 4, !tbaa !10
  %mul3.1.i = mul nsw i32 %mul.1.i, %7
  %conv4.1.i = sext i32 %mul3.1.i to i64
  %cmp5.1.i = icmp ugt i64 %conv4.1.i, %conv4.i
  %conv4.size.0.1.i = select i1 %cmp5.1.i, i64 %conv4.1.i, i64 %conv4.i
  %arrayidx.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 2
  %8 = load i32* %arrayidx.2.i, align 4, !tbaa !10
  %mul.2.i = mul nsw i32 %8, %3
  %arrayidx2.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 2
  %9 = load i32* %arrayidx2.2.i, align 4, !tbaa !10
  %mul3.2.i = mul nsw i32 %mul.2.i, %9
  %conv4.2.i = sext i32 %mul3.2.i to i64
  %cmp5.2.i = icmp ugt i64 %conv4.2.i, %conv4.size.0.1.i
  %conv4.size.0.2.i = select i1 %cmp5.2.i, i64 %conv4.2.i, i64 %conv4.size.0.1.i
  %arrayidx.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 3
  %10 = load i32* %arrayidx.3.i, align 4, !tbaa !10
  %mul.3.i = mul nsw i32 %10, %3
  %arrayidx2.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 3
  %11 = load i32* %arrayidx2.3.i, align 4, !tbaa !10
  %mul3.3.i = mul nsw i32 %mul.3.i, %11
  %conv4.3.i = sext i32 %mul3.3.i to i64
  %cmp5.3.i = icmp ugt i64 %conv4.3.i, %conv4.size.0.2.i
  %conv4.size.0.3.i = select i1 %cmp5.3.i, i64 %conv4.3.i, i64 %conv4.size.0.2.i
  %tobool.i = icmp eq i64 %conv4.size.0.3.i, 0
  br i1 %tobool.i, label %if.then6.i, label %_Z10__buf_sizePvP8buffer_t.exit

if.then6.i:                                       ; preds = %if.end5
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str32, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end5, %if.then6.i
  %12 = getelementptr inbounds [256 x i8]* %msg, i64 0, i64 0
  call void @llvm.lifetime.start(i64 256, i8* %12) #4
  %13 = load i64* %dev, align 8, !tbaa !5
  %14 = inttoptr i64 %13 to i8*
  %15 = load i8** %host, align 8, !tbaa !20
  %call8 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %12, i64 256, i8* getelementptr inbounds ([34 x i8]* @.str27, i64 0, i64 0), i64 %conv4.size.0.3.i, i8* %14, i8* %15)
  %call9 = call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf)
  br i1 %call9, label %do.body, label %if.then10

if.then10:                                        ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i64 0, i64 0))
  br label %do.body

do.body:                                          ; preds = %_Z10__buf_sizePvP8buffer_t.exit, %if.then10
  %16 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %call12 = call i32 @cuEventRecord(%struct.CUevent_st* %16, %struct.CUstream_st* null)
  %call15 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* %12)
  %17 = load i8** %host, align 8, !tbaa !20
  %18 = load i64* %dev, align 8, !tbaa !5
  %call18 = call i32 @cuMemcpyDtoH_v2(i8* %17, i64 %18, i64 %conv4.size.0.3.i)
  %cond = icmp eq i32 %call18, 0
  br i1 %cond, label %do.end, label %if.then19

if.then19:                                        ; preds = %do.body
  %call21 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* %12, i32 %call18)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %do.body, %if.then19
  %19 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call26 = call i32 @cuEventRecord(%struct.CUevent_st* %19, %struct.CUstream_st* null)
  %20 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call27 = call i32 @cuEventSynchronize(%struct.CUevent_st* %20)
  %21 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %22 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call28 = call i32 @cuEventElapsedTime(float* %msec, %struct.CUevent_st* %21, %struct.CUevent_st* %22)
  %23 = load float* %msec, align 4, !tbaa !15
  %conv = fpext float %23 to double
  %call29 = call i64 @halide_current_time_ns(i8* %user_context)
  %call30 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([24 x i8]* @.str22, i64 0, i64 0), double %conv, i64 %call29)
  call void @llvm.lifetime.end(i64 256, i8* %12) #4
  br label %if.end33

if.end33:                                         ; preds = %entry, %do.end
  store i8 0, i8* %dev_dirty, align 1, !tbaa !21
  ret void
}

declare i32 @cuMemcpyDtoH_v2(i8*, i64, i64) #1

; Function Attrs: uwtable
define weak void @halide_dev_sync(i8* %user_context) #0 {
entry:
  %call = tail call i32 @cuCtxSynchronize()
  ret void
}

; Function Attrs: uwtable
define weak void @halide_dev_run(i8* %user_context, i8* %state_ptr, i8* %entry_name, i32 %blocksX, i32 %blocksY, i32 %blocksZ, i32 %threadsX, i32 %threadsY, i32 %threadsZ, i32 %shared_mem_bytes, i64* %arg_sizes, i8** %args) #0 {
entry:
  %f.i = alloca %struct.CUfunc_st*, align 8
  %msg.i = alloca [256 x i8], align 16
  %msec.i = alloca float, align 4
  %msg = alloca [256 x i8], align 16
  %msec = alloca float, align 4
  %tobool = icmp eq i8* %state_ptr, null
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([10 x i8]* @.str28, i64 0, i64 0))
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %module = bitcast i8* %state_ptr to %struct.CUmod_st**
  %0 = load %struct.CUmod_st** %module, align 8, !tbaa !11
  %tobool1 = icmp eq %struct.CUmod_st* %0, null
  br i1 %tobool1, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([4 x i8]* @.str29, i64 0, i64 0))
  br label %if.end3

if.end3:                                          ; preds = %if.end, %if.then2
  %1 = bitcast %struct.CUfunc_st** %f.i to i8*
  call void @llvm.lifetime.start(i64 8, i8* %1)
  %2 = bitcast float* %msec.i to i8*
  call void @llvm.lifetime.start(i64 4, i8* %2)
  %3 = getelementptr inbounds [256 x i8]* %msg.i, i64 0, i64 0
  call void @llvm.lifetime.start(i64 256, i8* %3) #4
  %call.i = call i64 @halide_current_time_ns(i8* %user_context)
  %call1.i = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %3, i64 256, i8* getelementptr inbounds ([23 x i8]* @.str31, i64 0, i64 0), i8* %entry_name, i64 %call.i)
  %4 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %call2.i = call i32 @cuEventRecord(%struct.CUevent_st* %4, %struct.CUstream_st* null)
  %call5.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* %3)
  %call6.i = call i32 @cuModuleGetFunction(%struct.CUfunc_st** %f.i, %struct.CUmod_st* %0, i8* %entry_name)
  %cond.i = icmp eq i32 %call6.i, 0
  br i1 %cond.i, label %_Z12__get_kernelPvP8CUmod_stPKc.exit, label %if.then.i

if.then.i:                                        ; preds = %if.end3
  %call8.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* %3, i32 %call6.i)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %_Z12__get_kernelPvP8CUmod_stPKc.exit

_Z12__get_kernelPvP8CUmod_stPKc.exit:             ; preds = %if.end3, %if.then.i
  %5 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call12.i = call i32 @cuEventRecord(%struct.CUevent_st* %5, %struct.CUstream_st* null)
  %6 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call13.i = call i32 @cuEventSynchronize(%struct.CUevent_st* %6)
  %7 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %8 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call14.i = call i32 @cuEventElapsedTime(float* %msec.i, %struct.CUevent_st* %7, %struct.CUevent_st* %8)
  %9 = load float* %msec.i, align 4, !tbaa !15
  %conv.i = fpext float %9 to double
  %call15.i = call i64 @halide_current_time_ns(i8* %user_context)
  %call16.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([24 x i8]* @.str22, i64 0, i64 0), double %conv.i, i64 %call15.i)
  %10 = load %struct.CUfunc_st** %f.i, align 8, !tbaa !1
  call void @llvm.lifetime.end(i64 256, i8* %3) #4
  call void @llvm.lifetime.end(i64 8, i8* %1)
  call void @llvm.lifetime.end(i64 4, i8* %2)
  %11 = getelementptr inbounds [256 x i8]* %msg, i64 0, i64 0
  call void @llvm.lifetime.start(i64 256, i8* %11) #4
  %call4 = call i64 @halide_current_time_ns(i8* %user_context)
  %call5 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %11, i64 256, i8* getelementptr inbounds ([71 x i8]* @.str30, i64 0, i64 0), i8* %entry_name, i32 %blocksX, i32 %blocksY, i32 %blocksZ, i32 %threadsX, i32 %threadsY, i32 %threadsZ, i32 %shared_mem_bytes, i64 %call4)
  %12 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %call6 = call i32 @cuEventRecord(%struct.CUevent_st* %12, %struct.CUstream_st* null)
  %call9 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0), i8* %11)
  %call10 = call i32 @cuLaunchKernel(%struct.CUfunc_st* %10, i32 %blocksX, i32 %blocksY, i32 %blocksZ, i32 %threadsX, i32 %threadsY, i32 %threadsZ, i32 %shared_mem_bytes, %struct.CUstream_st* null, i8** %args, i8** null)
  %cond = icmp eq i32 %call10, 0
  br i1 %cond, label %do.end, label %if.then11

if.then11:                                        ; preds = %_Z12__get_kernelPvP8CUmod_stPKc.exit
  %call13 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str5, i64 0, i64 0), i8* %11, i32 %call10)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([23 x i8]* @.str6, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %_Z12__get_kernelPvP8CUmod_stPKc.exit, %if.then11
  %13 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call18 = call i32 @cuEventRecord(%struct.CUevent_st* %13, %struct.CUstream_st* null)
  %14 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call19 = call i32 @cuEventSynchronize(%struct.CUevent_st* %14)
  %15 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %16 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call20 = call i32 @cuEventElapsedTime(float* %msec, %struct.CUevent_st* %15, %struct.CUevent_st* %16)
  %17 = load float* %msec, align 4, !tbaa !15
  %conv = fpext float %17 to double
  %call21 = call i64 @halide_current_time_ns(i8* %user_context)
  %call22 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([24 x i8]* @.str22, i64 0, i64 0), double %conv, i64 %call21)
  call void @llvm.lifetime.end(i64 256, i8* %11) #4
  ret void
}

declare i32 @cuLaunchKernel(%struct.CUfunc_st*, i32, i32, i32, i32, i32, i32, i32, %struct.CUstream_st*, i8**, i8**) #1

declare i32 @cuModuleGetFunction(%struct.CUfunc_st**, %struct.CUmod_st*, i8*) #1

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !7, i64 0}
!6 = metadata !{metadata !"_ZTS8buffer_t", metadata !7, i64 0, metadata !2, i64 8, metadata !3, i64 16, metadata !3, i64 32, metadata !3, i64 48, metadata !8, i64 64, metadata !9, i64 68, metadata !9, i64 69}
!7 = metadata !{metadata !"long long", metadata !3, i64 0}
!8 = metadata !{metadata !"int", metadata !3, i64 0}
!9 = metadata !{metadata !"bool", metadata !3, i64 0}
!10 = metadata !{metadata !8, metadata !8, i64 0}
!11 = metadata !{metadata !12, metadata !2, i64 0}
!12 = metadata !{metadata !"_ZTS14_module_state_", metadata !2, i64 0, metadata !2, i64 8}
!13 = metadata !{metadata !12, metadata !2, i64 8}
!14 = metadata !{metadata !6, metadata !8, i64 64}
!15 = metadata !{metadata !16, metadata !16, i64 0}
!16 = metadata !{metadata !"float", metadata !3, i64 0}
!17 = metadata !{metadata !7, metadata !7, i64 0}
!18 = metadata !{metadata !6, metadata !9, i64 68}
!19 = metadata !{i8 0, i8 2}
!20 = metadata !{metadata !6, metadata !2, i64 8}
!21 = metadata !{metadata !6, metadata !9, i64 69}
