; ModuleID = 'src/runtime/cuda.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.CUctx_st = type opaque
%struct._module_state_ = type { %struct.CUmod_st*, %struct._module_state_* }
%struct.CUmod_st = type opaque
%struct.CUevent_st = type opaque
%struct.buffer_t = type { i64, i8*, [4 x i32], [4 x i32], [4 x i32], i32, i8, i8 }
%struct.CUfunc_st = type opaque
%struct.CUstream_st = type opaque

@weak_cuda_ctx = weak global %struct.CUctx_st* null, align 8
@cuda_ctx_ptr = weak global %struct.CUctx_st** null, align 8
@state_list = weak global %struct._module_state_* null, align 8
@.str = private unnamed_addr constant [58 x i8] c"Bad device pointer %p: cuPointerGetAttribute returned %d\0A\00", align 1
@.str1 = private unnamed_addr constant [16 x i8] c"deviceCount > 0\00", align 1
@.str2 = private unnamed_addr constant [14 x i8] c"HL_GPU_DEVICE\00", align 1
@.str3 = private unnamed_addr constant [51 x i8] c"status == CUDA_SUCCESS && \22Failed to get device\5Cn\22\00", align 1
@_Z7__start = internal global %struct.CUevent_st* null, align 8
@_Z5__end = internal global %struct.CUevent_st* null, align 8
@.str4 = private unnamed_addr constant [9 x i8] c"buf->dev\00", align 1
@.str5 = private unnamed_addr constant [22 x i8] c"buf->host && buf->dev\00", align 1
@.str6 = private unnamed_addr constant [10 x i8] c"buf->host\00", align 1
@.str7 = private unnamed_addr constant [10 x i8] c"state_ptr\00", align 1
@.str8 = private unnamed_addr constant [4 x i8] c"mod\00", align 1
@.str9 = private unnamed_addr constant [5 x i8] c"size\00", align 1

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
  %call = tail call i32 @cuMemFree_v2(i64 %0)
  store i64 0, i64* %dev, align 8, !tbaa !5
  br label %return

return:                                           ; preds = %entry, %if.end
  ret void
}

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
  br i1 %cmp1, label %if.then2, label %if.end25

if.then2:                                         ; preds = %if.end
  %call = call i32 @cuInit(i32 0)
  store i32 0, i32* %deviceCount, align 4, !tbaa !10
  %call3 = call i32 @cuDeviceGetCount(i32* %deviceCount)
  %3 = load i32* %deviceCount, align 4, !tbaa !10
  %cmp4 = icmp sgt i32 %3, 0
  br i1 %cmp4, label %if.end6, label %if.then5

if.then5:                                         ; preds = %if.then2
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0))
  br label %if.end6

if.end6:                                          ; preds = %if.then5, %if.then2
  %call7 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str2, i64 0, i64 0))
  %tobool = icmp eq i8* %call7, null
  br i1 %tobool, label %if.else, label %if.end19

if.else:                                          ; preds = %if.end6
  %4 = load i32* %deviceCount, align 4, !tbaa !10
  %cmp11 = icmp sgt i32 %4, 2
  br i1 %cmp11, label %if.then12, label %for.cond

if.then12:                                        ; preds = %if.else
  store i32 2, i32* %deviceCount, align 4, !tbaa !10
  br label %for.cond

for.cond:                                         ; preds = %if.else, %if.then12, %for.body
  %id.0.in = phi i32 [ %id.0, %for.body ], [ %4, %if.else ], [ 2, %if.then12 ]
  %id.0 = add nsw i32 %id.0.in, -1
  %cmp14 = icmp sgt i32 %id.0.in, 0
  br i1 %cmp14, label %for.body, label %if.then21

for.body:                                         ; preds = %for.cond
  %call15 = call i32 @cuDeviceGet(i32* %dev, i32 %id.0)
  %cmp16 = icmp eq i32 %call15, 0
  br i1 %cmp16, label %if.end22, label %for.cond

if.end19:                                         ; preds = %if.end6
  %call9 = call i32 @atoi(i8* %call7)
  %call10 = call i32 @cuDeviceGet(i32* %dev, i32 %call9)
  %cmp20 = icmp eq i32 %call10, 0
  br i1 %cmp20, label %if.end22, label %if.then21

if.then21:                                        ; preds = %for.cond, %if.end19
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([51 x i8]* @.str3, i64 0, i64 0))
  br label %if.end22

if.end22:                                         ; preds = %for.body, %if.then21, %if.end19
  %5 = load %struct.CUctx_st*** @cuda_ctx_ptr, align 8, !tbaa !1
  %6 = load i32* %dev, align 4, !tbaa !10
  %call23 = call i32 @cuCtxCreate_v2(%struct.CUctx_st** %5, i32 0, i32 %6)
  br label %if.end25

if.end25:                                         ; preds = %if.end, %if.end22
  %7 = bitcast i8* %state_ptr to %struct._module_state_*
  %tobool26 = icmp eq i8* %state_ptr, null
  br i1 %tobool26, label %if.then27, label %if.end29

if.then27:                                        ; preds = %if.end25
  %call28 = call i8* @malloc(i64 16)
  %8 = bitcast i8* %call28 to %struct._module_state_*
  %module = bitcast i8* %call28 to %struct.CUmod_st**
  store %struct.CUmod_st* null, %struct.CUmod_st** %module, align 8, !tbaa !11
  %9 = load %struct._module_state_** @state_list, align 8, !tbaa !1
  %next = getelementptr inbounds i8* %call28, i64 8
  %10 = bitcast i8* %next to %struct._module_state_**
  store %struct._module_state_* %9, %struct._module_state_** %10, align 8, !tbaa !13
  store %struct._module_state_* %8, %struct._module_state_** @state_list, align 8, !tbaa !1
  br label %if.end29

if.end29:                                         ; preds = %if.end25, %if.then27
  %state.0 = phi %struct._module_state_* [ %7, %if.end25 ], [ %8, %if.then27 ]
  %module30 = getelementptr inbounds %struct._module_state_* %state.0, i64 0, i32 0
  %11 = load %struct.CUmod_st** %module30, align 8, !tbaa !11
  %tobool31 = icmp eq %struct.CUmod_st* %11, null
  br i1 %tobool31, label %if.then32, label %if.end35

if.then32:                                        ; preds = %if.end29
  %call34 = call i32 @cuModuleLoadData(%struct.CUmod_st** %module30, i8* %ptx_src)
  br label %if.end35

if.end35:                                         ; preds = %if.end29, %if.then32
  %12 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %tobool36 = icmp eq %struct.CUevent_st* %12, null
  br i1 %tobool36, label %if.then37, label %if.end40

if.then37:                                        ; preds = %if.end35
  %call38 = call i32 @cuEventCreate(%struct.CUevent_st** @_Z7__start, i32 0)
  %call39 = call i32 @cuEventCreate(%struct.CUevent_st** @_Z5__end, i32 0)
  br label %if.end40

if.end40:                                         ; preds = %if.end35, %if.then37
  %13 = bitcast %struct._module_state_* %state.0 to i8*
  ret i8* %13
}

declare i32 @cuInit(i32) #1

declare i32 @cuDeviceGetCount(i32*) #1

declare void @halide_error(i8*, i8*) #1

; Function Attrs: nounwind readonly
declare i8* @getenv(i8* nocapture) #2

declare i32 @cuDeviceGet(i32*, i32) #1

; Function Attrs: nounwind readonly
declare i32 @atoi(i8* nocapture) #2

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
  br i1 %cmp, label %if.end15, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call i32 @cuCtxSynchronize()
  %1 = load %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  %tobool = icmp eq %struct.CUevent_st* %1, null
  br i1 %tobool, label %while.cond.preheader, label %if.then1

if.then1:                                         ; preds = %if.then
  %call2 = tail call i32 @cuEventDestroy_v2(%struct.CUevent_st* %1)
  %2 = load %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  %call3 = tail call i32 @cuEventDestroy_v2(%struct.CUevent_st* %2)
  store %struct.CUevent_st* null, %struct.CUevent_st** @_Z5__end, align 8, !tbaa !1
  store %struct.CUevent_st* null, %struct.CUevent_st** @_Z7__start, align 8, !tbaa !1
  br label %while.cond.preheader

while.cond.preheader:                             ; preds = %if.then, %if.then1
  %state.020 = load %struct._module_state_** @state_list, align 8
  %tobool421 = icmp eq %struct._module_state_* %state.020, null
  br i1 %tobool421, label %while.end, label %while.body

while.body:                                       ; preds = %while.cond.preheader, %if.end10
  %state.022 = phi %struct._module_state_* [ %state.0, %if.end10 ], [ %state.020, %while.cond.preheader ]
  %module = getelementptr inbounds %struct._module_state_* %state.022, i64 0, i32 0
  %3 = load %struct.CUmod_st** %module, align 8, !tbaa !11
  %tobool5 = icmp eq %struct.CUmod_st* %3, null
  br i1 %tobool5, label %if.end10, label %if.then6

if.then6:                                         ; preds = %while.body
  %call8 = tail call i32 @cuModuleUnload(%struct.CUmod_st* %3)
  store %struct.CUmod_st* null, %struct.CUmod_st** %module, align 8, !tbaa !11
  br label %if.end10

if.end10:                                         ; preds = %while.body, %if.then6
  %next = getelementptr inbounds %struct._module_state_* %state.022, i64 0, i32 1
  %state.0 = load %struct._module_state_** %next, align 8
  %tobool4 = icmp eq %struct._module_state_* %state.0, null
  br i1 %tobool4, label %while.end, label %while.body

while.end:                                        ; preds = %if.end10, %while.cond.preheader
  %4 = load %struct.CUctx_st** @weak_cuda_ctx, align 8, !tbaa !1
  %tobool11 = icmp eq %struct.CUctx_st* %4, null
  br i1 %tobool11, label %if.end14, label %if.then12

if.then12:                                        ; preds = %while.end
  %call13 = tail call i32 @cuCtxDestroy_v2(%struct.CUctx_st* %4)
  store %struct.CUctx_st* null, %struct.CUctx_st** @weak_cuda_ctx, align 8, !tbaa !1
  br label %if.end14

if.end14:                                         ; preds = %while.end, %if.then12
  store %struct.CUctx_st** null, %struct.CUctx_st*** @cuda_ctx_ptr, align 8, !tbaa !1
  br label %if.end15

if.end15:                                         ; preds = %entry, %if.end14
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
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %0 = load i64* %dev, align 8, !tbaa !5
  %tobool = icmp eq i64 %0, 0
  br i1 %tobool, label %if.end, label %if.end6

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
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str9, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then6.i
  %call1 = call i32 @cuMemAlloc_v2(i64* %p, i64 %conv4.size.0.3.i)
  %10 = load i64* %p, align 8, !tbaa !15
  store i64 %10, i64* %dev, align 8, !tbaa !5
  %tobool4 = icmp eq i64 %10, 0
  br i1 %tobool4, label %if.then5, label %if.end6

if.then5:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str4, i64 0, i64 0))
  br label %if.end6

if.end6:                                          ; preds = %_Z10__buf_sizePvP8buffer_t.exit, %entry, %if.then5
  ret void
}

declare i32 @cuMemAlloc_v2(i64*, i64) #1

; Function Attrs: uwtable
define weak void @halide_copy_to_dev(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %host_dirty = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 6
  %0 = load i8* %host_dirty, align 1, !tbaa !16, !range !17
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end7, label %if.then

if.then:                                          ; preds = %entry
  %host = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 1
  %1 = load i8** %host, align 8, !tbaa !18
  %tobool1 = icmp eq i8* %1, null
  br i1 %tobool1, label %if.then3, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.then
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %2 = load i64* %dev, align 8, !tbaa !5
  %tobool2 = icmp eq i64 %2, 0
  br i1 %tobool2, label %if.then3, label %if.end

if.then3:                                         ; preds = %land.lhs.true, %if.then
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str5, i64 0, i64 0))
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
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str9, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then6.i
  %dev4 = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %12 = load i64* %dev4, align 8, !tbaa !5
  %13 = load i8** %host, align 8, !tbaa !18
  %call6 = tail call i32 @cuMemcpyHtoD_v2(i64 %12, i8* %13, i64 %conv4.size.0.3.i)
  br label %if.end7

if.end7:                                          ; preds = %entry, %_Z10__buf_sizePvP8buffer_t.exit
  store i8 0, i8* %host_dirty, align 1, !tbaa !16
  ret void
}

declare i32 @cuMemcpyHtoD_v2(i64, i8*, i64) #1

; Function Attrs: uwtable
define weak void @halide_copy_to_host(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %dev_dirty = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 7
  %0 = load i8* %dev_dirty, align 1, !tbaa !19, !range !17
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end9, label %if.then

if.then:                                          ; preds = %entry
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %1 = load i64* %dev, align 8, !tbaa !5
  %tobool1 = icmp eq i64 %1, 0
  br i1 %tobool1, label %if.then2, label %if.end

if.then2:                                         ; preds = %if.then
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str4, i64 0, i64 0))
  br label %if.end

if.end:                                           ; preds = %if.then, %if.then2
  %host = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 1
  %2 = load i8** %host, align 8, !tbaa !18
  %tobool3 = icmp eq i8* %2, null
  br i1 %tobool3, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([10 x i8]* @.str6, i64 0, i64 0))
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
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str9, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end5, %if.then6.i
  %12 = load i8** %host, align 8, !tbaa !18
  %13 = load i64* %dev, align 8, !tbaa !5
  %call8 = tail call i32 @cuMemcpyDtoH_v2(i8* %12, i64 %13, i64 %conv4.size.0.3.i)
  br label %if.end9

if.end9:                                          ; preds = %entry, %_Z10__buf_sizePvP8buffer_t.exit
  store i8 0, i8* %dev_dirty, align 1, !tbaa !19
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
  %tobool = icmp eq i8* %state_ptr, null
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([10 x i8]* @.str7, i64 0, i64 0))
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %module = bitcast i8* %state_ptr to %struct.CUmod_st**
  %0 = load %struct.CUmod_st** %module, align 8, !tbaa !11
  %tobool1 = icmp eq %struct.CUmod_st* %0, null
  br i1 %tobool1, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([4 x i8]* @.str8, i64 0, i64 0))
  br label %if.end3

if.end3:                                          ; preds = %if.end, %if.then2
  %1 = bitcast %struct.CUfunc_st** %f.i to i8*
  call void @llvm.lifetime.start(i64 8, i8* %1)
  %call.i = call i32 @cuModuleGetFunction(%struct.CUfunc_st** %f.i, %struct.CUmod_st* %0, i8* %entry_name)
  %2 = load %struct.CUfunc_st** %f.i, align 8, !tbaa !1
  call void @llvm.lifetime.end(i64 8, i8* %1)
  %call4 = call i32 @cuLaunchKernel(%struct.CUfunc_st* %2, i32 %blocksX, i32 %blocksY, i32 %blocksZ, i32 %threadsX, i32 %threadsY, i32 %threadsZ, i32 %shared_mem_bytes, %struct.CUstream_st* null, i8** %args, i8** null)
  ret void
}

declare i32 @cuLaunchKernel(%struct.CUfunc_st*, i32, i32, i32, i32, i32, i32, i32, %struct.CUstream_st*, i8**, i8**) #1

declare i32 @cuModuleGetFunction(%struct.CUfunc_st**, %struct.CUmod_st*, i8*) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #4

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #4

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
!15 = metadata !{metadata !7, metadata !7, i64 0}
!16 = metadata !{metadata !6, metadata !9, i64 68}
!17 = metadata !{i8 0, i8 2}
!18 = metadata !{metadata !6, metadata !2, i64 8}
!19 = metadata !{metadata !6, metadata !9, i64 69}
