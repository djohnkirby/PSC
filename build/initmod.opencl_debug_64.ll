; ModuleID = 'src/runtime/opencl_debug.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._cl_context = type opaque
%struct._cl_command_queue = type opaque
%struct._cl_program = type opaque
%struct.buffer_t = type { i64, i8*, [4 x i32], [4 x i32], [4 x i32], i32, i8, i8 }
%struct._cl_mem = type opaque
%struct._cl_device_id = type opaque
%struct._cl_platform_id = type opaque
%struct._cl_event = type opaque
%struct._cl_kernel = type opaque

@weak_cl_ctx = weak global %struct._cl_context* null, align 8
@weak_cl_q = weak global %struct._cl_command_queue* null, align 8
@_Z6cl_ctx = internal unnamed_addr global %struct._cl_context** @weak_cl_ctx, align 8
@_Z4cl_q = internal unnamed_addr global %struct._cl_command_queue** @weak_cl_q, align 8
@.str = private unnamed_addr constant [55 x i8] c"Bad device pointer %p: clGetMemObjectInfo returned %d\0A\00", align 1
@.str1 = private unnamed_addr constant [52 x i8] c"validate %p: asked for %lld, actual allocated %lld\0A\00", align 1
@.str2 = private unnamed_addr constant [65 x i8] c"real_size >= size && \22Validating pointer with insufficient size\22\00", align 1
@.str3 = private unnamed_addr constant [31 x i8] c"In dev_free of %p - dev: 0x%p\0A\00", align 1
@.str4 = private unnamed_addr constant [47 x i8] c"halide_validate_dev_pointer(user_context, buf)\00", align 1
@.str5 = private unnamed_addr constant [33 x i8] c"CL: %s returned non-success: %d\0A\00", align 1
@.str6 = private unnamed_addr constant [19 x i8] c"clReleaseMemObject\00", align 1
@.str7 = private unnamed_addr constant [18 x i8] c"err == CL_SUCCESS\00", align 1
@.str8 = private unnamed_addr constant [17 x i8] c"clGetPlatformIDs\00", align 1
@.str9 = private unnamed_addr constant [16 x i8] c"HL_OCL_PLATFORM\00", align 1
@.str10 = private unnamed_addr constant [32 x i8] c"Failed to find OpenCL platform\0A\00", align 1
@.str11 = private unnamed_addr constant [18 x i8] c"clGetPlatformInfo\00", align 1
@.str12 = private unnamed_addr constant [53 x i8] c"Got platform '%s', about to create context (t=%lld)\0A\00", align 1
@.str13 = private unnamed_addr constant [14 x i8] c"HL_OCL_DEVICE\00", align 1
@.str14 = private unnamed_addr constant [4 x i8] c"cpu\00", align 1
@.str15 = private unnamed_addr constant [4 x i8] c"gpu\00", align 1
@.str16 = private unnamed_addr constant [15 x i8] c"clGetDeviceIDs\00", align 1
@.str17 = private unnamed_addr constant [22 x i8] c"Failed to get device\0A\00", align 1
@.str18 = private unnamed_addr constant [16 x i8] c"clGetDeviceInfo\00", align 1
@.str19 = private unnamed_addr constant [51 x i8] c"Got device '%s', about to create context (t=%lld)\0A\00", align 1
@.str20 = private unnamed_addr constant [16 x i8] c"clCreateContext\00", align 1
@.str21 = private unnamed_addr constant [9 x i8] c"!(*cl_q)\00", align 1
@.str22 = private unnamed_addr constant [21 x i8] c"clCreateCommandQueue\00", align 1
@.str23 = private unnamed_addr constant [24 x i8] c"Already had context %p\0A\00", align 1
@.str24 = private unnamed_addr constant [16 x i8] c"clRetainContext\00", align 1
@.str25 = private unnamed_addr constant [21 x i8] c"clRetainCommandQueue\00", align 1
@.str26 = private unnamed_addr constant [17 x i8] c"clGetContextInfo\00", align 1
@_Z5__mod = internal unnamed_addr global %struct._cl_program* null, align 8
@.str27 = private unnamed_addr constant [13 x i8] c"/*OpenCL C*/\00", align 1
@.str28 = private unnamed_addr constant [32 x i8] c"Compiling OpenCL C kernel: %s\0A\0A\00", align 1
@.str29 = private unnamed_addr constant [26 x i8] c"clCreateProgramWithSource\00", align 1
@.str30 = private unnamed_addr constant [34 x i8] c"Compiling SPIR kernel (%i bytes)\0A\00", align 1
@.str31 = private unnamed_addr constant [26 x i8] c"clCreateProgramWithBinary\00", align 1
@.str32 = private unnamed_addr constant [53 x i8] c"Error: Failed to build program executable! err = %d\0A\00", align 1
@.str33 = private unnamed_addr constant [22 x i8] c"Build Log:\0A %s\0A-----\0A\00", align 1
@.str34 = private unnamed_addr constant [48 x i8] c"clGetProgramBuildInfo failed to get build log!\0A\00", align 1
@.str35 = private unnamed_addr constant [18 x i8] c"dev_sync on exit\0A\00", align 1
@.str36 = private unnamed_addr constant [21 x i8] c"clReleaseProgram %p\0A\00", align 1
@.str37 = private unnamed_addr constant [17 x i8] c"clReleaseProgram\00", align 1
@.str38 = private unnamed_addr constant [22 x i8] c"clReleaseCommandQueue\00", align 1
@.str39 = private unnamed_addr constant [21 x i8] c"clReleaseContext %p\0A\00", align 1
@.str40 = private unnamed_addr constant [17 x i8] c"clReleaseContext\00", align 1
@.str41 = private unnamed_addr constant [126 x i8] c"dev_malloc allocating buffer of %lld bytes, extents: %lldx%lldx%lldx%lld strides: %lldx%lldx%lldx%lld (%d bytes per element)\0A\00", align 1
@.str42 = private unnamed_addr constant [55 x i8] c"dev_malloc allocated buffer %p of with buf->dev of %p\0A\00", align 1
@.str43 = private unnamed_addr constant [9 x i8] c"buf->dev\00", align 1
@.str44 = private unnamed_addr constant [22 x i8] c"buf->host && buf->dev\00", align 1
@.str45 = private unnamed_addr constant [35 x i8] c"copy_to_dev (%lld bytes) %p -> %p\0A\00", align 1
@.str46 = private unnamed_addr constant [21 x i8] c"clEnqueueWriteBuffer\00", align 1
@.str47 = private unnamed_addr constant [43 x i8] c"copy_to_host buf %p (%lld bytes) %p -> %p\0A\00", align 1
@.str48 = private unnamed_addr constant [53 x i8] c"halide_validate_dev_pointer(user_context, buf, size)\00", align 1
@.str49 = private unnamed_addr constant [20 x i8] c"clEnqueueReadBuffer\00", align 1
@.str50 = private unnamed_addr constant [63 x i8] c"dev_run %s with (%dx%dx%d) blks, (%dx%dx%d) threads, %d shmem\0A\00", align 1
@.str51 = private unnamed_addr constant [33 x i8] c"clSetKernelArg %i %i [0x%x ...]\0A\00", align 1
@.str52 = private unnamed_addr constant [15 x i8] c"clSetKernelArg\00", align 1
@.str53 = private unnamed_addr constant [23 x i8] c"clEnqueueNDRangeKernel\00", align 1
@.str54 = private unnamed_addr constant [15 x i8] c"get_kernel %s\0A\00", align 1
@.str55 = private unnamed_addr constant [15 x i8] c"clCreateKernel\00", align 1
@.str56 = private unnamed_addr constant [25 x i8] c"dev_malloc (%lld bytes)\0A\00", align 1
@.str57 = private unnamed_addr constant [28 x i8] c"    returned: %p (err: %d)\0A\00", align 1
@.str58 = private unnamed_addr constant [2 x i8] c"p\00", align 1
@.str59 = private unnamed_addr constant [5 x i8] c"size\00", align 1

; Function Attrs: uwtable
define weak void @halide_set_cl_context(%struct._cl_context** %ctx, %struct._cl_command_queue** %q) #0 {
entry:
  store %struct._cl_context** %ctx, %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  store %struct._cl_command_queue** %q, %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  ret void
}

; Function Attrs: uwtable
define weak zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i64 %size) #0 {
entry:
  %real_size = alloca i64, align 8
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %0 = load i64* %dev, align 8, !tbaa !5
  %cmp = icmp eq i64 %0, 0
  br i1 %cmp, label %return, label %if.end

if.end:                                           ; preds = %entry
  %1 = inttoptr i64 %0 to %struct._cl_mem*
  %2 = bitcast i64* %real_size to i8*
  %call = call i32 @clGetMemObjectInfo(%struct._cl_mem* %1, i32 4354, i64 8, i8* %2, i64* null)
  %tobool = icmp eq i32 %call, 0
  %3 = load i64* %dev, align 8, !tbaa !5
  %4 = inttoptr i64 %3 to i8*
  br i1 %tobool, label %if.end5, label %if.then2

if.then2:                                         ; preds = %if.end
  %call4 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([55 x i8]* @.str, i64 0, i64 0), i8* %4, i32 %call)
  br label %return

if.end5:                                          ; preds = %if.end
  %5 = load i64* %real_size, align 8, !tbaa !10
  %call7 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([52 x i8]* @.str1, i64 0, i64 0), i8* %4, i64 %size, i64 %5)
  %tobool8 = icmp eq i64 %size, 0
  br i1 %tobool8, label %return, label %if.then9

if.then9:                                         ; preds = %if.end5
  %6 = load i64* %real_size, align 8, !tbaa !10
  %cmp10 = icmp ult i64 %6, %size
  br i1 %cmp10, label %if.then11, label %return

if.then11:                                        ; preds = %if.then9
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([65 x i8]* @.str2, i64 0, i64 0))
  br label %return

return:                                           ; preds = %if.then11, %if.end5, %if.then9, %entry, %if.then2
  %retval.0 = phi i1 [ false, %if.then2 ], [ true, %entry ], [ true, %if.then9 ], [ true, %if.end5 ], [ true, %if.then11 ]
  ret i1 %retval.0
}

declare i32 @clGetMemObjectInfo(%struct._cl_mem*, i32, i64, i8*, i64*) #1

declare i32 @halide_printf(i8*, i8*, ...) #1

declare void @halide_error(i8*, i8*) #1

; Function Attrs: uwtable
define weak void @halide_dev_free(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %0 = load i64* %dev, align 8, !tbaa !5
  %cmp = icmp eq i64 %0, 0
  br i1 %cmp, label %return, label %if.end

if.end:                                           ; preds = %entry
  %1 = inttoptr i64 %0 to i8*
  %call = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([31 x i8]* @.str3, i64 0, i64 0), %struct.buffer_t* %buf, i8* %1)
  %call2 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i64 0)
  br i1 %call2, label %do.body, label %if.then3

if.then3:                                         ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str4, i64 0, i64 0))
  br label %do.body

do.body:                                          ; preds = %if.end, %if.then3
  %2 = load i64* %dev, align 8, !tbaa !5
  %3 = inttoptr i64 %2 to %struct._cl_mem*
  %call6 = tail call i32 @clReleaseMemObject(%struct._cl_mem* %3)
  %cond = icmp eq i32 %call6, 0
  br i1 %cond, label %do.end, label %if.then8

if.then8:                                         ; preds = %do.body
  %call9 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([19 x i8]* @.str6, i64 0, i64 0), i32 %call6)
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %do.body, %if.then8
  store i64 0, i64* %dev, align 8, !tbaa !5
  br label %return

return:                                           ; preds = %entry, %do.end
  ret void
}

declare i32 @clReleaseMemObject(%struct._cl_mem*) #1

; Function Attrs: uwtable
define weak void @halide_init_kernels(i8* %user_context, i8* %src, i32 %size) #0 {
entry:
  %err = alloca i32, align 4
  %dev = alloca %struct._cl_device_id*, align 8
  %platforms = alloca [4 x %struct._cl_platform_id*], align 16
  %platformCount = alloca i32, align 4
  %platformName = alloca [256 x i8], align 16
  %platformName32 = alloca [256 x i8], align 16
  %devices = alloca [4 x %struct._cl_device_id*], align 16
  %deviceCount = alloca i32, align 4
  %deviceName = alloca [256 x i8], align 16
  %properties = alloca [3 x i64], align 16
  %devices168 = alloca [1 x %struct._cl_device_id*], align 8
  %lengths = alloca [1 x i64], align 8
  %sources = alloca [1 x i8*], align 8
  %binaries = alloca [1 x i8*], align 8
  %len = alloca i64, align 8
  %buffer = alloca [2048 x i8], align 16
  %0 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %1 = load %struct._cl_context** %0, align 8, !tbaa !1
  %tobool = icmp eq %struct._cl_context* %1, null
  br i1 %tobool, label %if.then, label %if.else126

if.then:                                          ; preds = %entry
  store i32 0, i32* %platformCount, align 4, !tbaa !11
  %arraydecay = getelementptr inbounds [4 x %struct._cl_platform_id*]* %platforms, i64 0, i64 0
  %call = call i32 @clGetPlatformIDs(i32 4, %struct._cl_platform_id** %arraydecay, i32* %platformCount)
  store i32 %call, i32* %err, align 4, !tbaa !11
  %cmp = icmp eq i32 %call, 0
  br i1 %cmp, label %do.end, label %if.end

if.end:                                           ; preds = %if.then
  %call2 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([17 x i8]* @.str8, i64 0, i64 0), i32 %call)
  %.pr = load i32* %err, align 4, !tbaa !11
  %cmp3 = icmp eq i32 %.pr, 0
  br i1 %cmp3, label %do.end, label %if.then4

if.then4:                                         ; preds = %if.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %if.then, %if.end, %if.then4
  %call6 = call i8* @getenv(i8* getelementptr inbounds ([16 x i8]* @.str9, i64 0, i64 0))
  %cmp7 = icmp eq i8* %call6, null
  %2 = load i32* %platformCount, align 4, !tbaa !11
  %cmp22 = icmp eq i32 %2, 0
  br i1 %cmp7, label %if.else, label %for.cond.preheader

for.cond.preheader:                               ; preds = %do.end
  br i1 %cmp22, label %if.then28, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %3 = getelementptr inbounds [256 x i8]* %platformName, i64 0, i64 0
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %i.0304 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  call void @llvm.lifetime.start(i64 256, i8* %3) #3
  %idxprom = zext i32 %i.0304 to i64
  %arrayidx = getelementptr inbounds [4 x %struct._cl_platform_id*]* %platforms, i64 0, i64 %idxprom
  %4 = load %struct._cl_platform_id** %arrayidx, align 8, !tbaa !1
  %call11 = call i32 @clGetPlatformInfo(%struct._cl_platform_id* %4, i32 2306, i64 256, i8* %3, i64* null)
  store i32 %call11, i32* %err, align 4, !tbaa !11
  %cmp12 = icmp eq i32 %call11, 0
  br i1 %cmp12, label %if.end14, label %for.inc

if.end14:                                         ; preds = %for.body
  %call16 = call i8* @strstr(i8* %3, i8* %call6)
  %tobool17 = icmp eq i8* %call16, null
  br i1 %tobool17, label %for.inc, label %cleanup

cleanup:                                          ; preds = %if.end14
  %5 = load %struct._cl_platform_id** %arrayidx, align 8, !tbaa !1
  call void @llvm.lifetime.end(i64 256, i8* %3) #3
  br label %if.end26

for.inc:                                          ; preds = %for.body, %if.end14
  call void @llvm.lifetime.end(i64 256, i8* %3) #3
  %inc = add i32 %i.0304, 1
  %6 = load i32* %platformCount, align 4, !tbaa !11
  %cmp9 = icmp ult i32 %inc, %6
  br i1 %cmp9, label %for.body, label %if.then28

if.else:                                          ; preds = %do.end
  br i1 %cmp22, label %if.then28, label %if.then23

if.then23:                                        ; preds = %if.else
  %7 = load %struct._cl_platform_id** %arraydecay, align 16, !tbaa !1
  br label %if.end26

if.end26:                                         ; preds = %cleanup, %if.then23
  %platform.2 = phi %struct._cl_platform_id* [ %5, %cleanup ], [ %7, %if.then23 ]
  %cmp27 = icmp eq %struct._cl_platform_id* %platform.2, null
  br i1 %cmp27, label %if.then28, label %if.end30

if.then28:                                        ; preds = %for.inc, %for.cond.preheader, %if.else, %if.end26
  %call29 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([32 x i8]* @.str10, i64 0, i64 0))
  br label %if.end223

if.end30:                                         ; preds = %if.end26
  %8 = getelementptr inbounds [256 x i8]* %platformName32, i64 0, i64 0
  call void @llvm.lifetime.start(i64 256, i8* %8) #3
  %call34 = call i32 @clGetPlatformInfo(%struct._cl_platform_id* %platform.2, i32 2306, i64 256, i8* %8, i64* null)
  store i32 %call34, i32* %err, align 4, !tbaa !11
  %cmp36 = icmp eq i32 %call34, 0
  br i1 %cmp36, label %do.end43, label %if.end39

if.end39:                                         ; preds = %if.end30
  %call38 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([18 x i8]* @.str11, i64 0, i64 0), i32 %call34)
  %.pr289 = load i32* %err, align 4, !tbaa !11
  %cmp40 = icmp eq i32 %.pr289, 0
  br i1 %cmp40, label %do.end43, label %if.then41

if.then41:                                        ; preds = %if.end39
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end43

do.end43:                                         ; preds = %if.end30, %if.then41, %if.end39
  %call45 = call i64 @halide_current_time_ns(i8* %user_context)
  %call46 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str12, i64 0, i64 0), i8* %8, i64 %call45)
  %call47 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str13, i64 0, i64 0))
  %cmp48 = icmp eq i8* %call47, null
  br i1 %cmp48, label %if.end59, label %if.then49

if.then49:                                        ; preds = %do.end43
  %call50 = call i8* @strstr(i8* getelementptr inbounds ([4 x i8]* @.str14, i64 0, i64 0), i8* %call47)
  %tobool51 = icmp eq i8* %call50, null
  %. = select i1 %tobool51, i64 0, i64 2
  %call54 = call i8* @strstr(i8* getelementptr inbounds ([4 x i8]* @.str15, i64 0, i64 0), i8* %call47)
  %tobool55 = icmp eq i8* %call54, null
  %or57 = or i64 %., 4
  %..or57 = select i1 %tobool55, i64 %., i64 %or57
  br label %if.end59

if.end59:                                         ; preds = %if.then49, %do.end43
  %device_type.1 = phi i64 [ 0, %do.end43 ], [ %..or57, %if.then49 ]
  %cmp60 = icmp eq i64 %device_type.1, 0
  %.device_type.1 = select i1 %cmp60, i64 4294967295, i64 %device_type.1
  store i32 0, i32* %deviceCount, align 4, !tbaa !11
  %arraydecay63 = getelementptr inbounds [4 x %struct._cl_device_id*]* %devices, i64 0, i64 0
  %call64 = call i32 @clGetDeviceIDs(%struct._cl_platform_id* %platform.2, i64 %.device_type.1, i32 4, %struct._cl_device_id** %arraydecay63, i32* %deviceCount)
  store i32 %call64, i32* %err, align 4, !tbaa !11
  %cmp66 = icmp eq i32 %call64, 0
  br i1 %cmp66, label %do.end74, label %if.end69

if.end69:                                         ; preds = %if.end59
  %call68 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([15 x i8]* @.str16, i64 0, i64 0), i32 %call64)
  %.pr291 = load i32* %err, align 4, !tbaa !11
  %cmp70 = icmp eq i32 %.pr291, 0
  br i1 %cmp70, label %do.end74, label %if.then71

if.then71:                                        ; preds = %if.end69
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end74

do.end74:                                         ; preds = %if.end59, %if.then71, %if.end69
  %9 = load i32* %deviceCount, align 4, !tbaa !11
  %cmp75 = icmp eq i32 %9, 0
  br i1 %cmp75, label %if.then76, label %if.end78

if.then76:                                        ; preds = %do.end74
  %call77 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str17, i64 0, i64 0))
  br label %cleanup123

if.end78:                                         ; preds = %do.end74
  %sub = add i32 %9, -1
  %idxprom79 = zext i32 %sub to i64
  %arrayidx80 = getelementptr inbounds [4 x %struct._cl_device_id*]* %devices, i64 0, i64 %idxprom79
  %10 = load %struct._cl_device_id** %arrayidx80, align 8, !tbaa !1
  store %struct._cl_device_id* %10, %struct._cl_device_id** %dev, align 8, !tbaa !1
  %11 = getelementptr inbounds [256 x i8]* %deviceName, i64 0, i64 0
  call void @llvm.lifetime.start(i64 256, i8* %11) #3
  %call82 = call i32 @clGetDeviceInfo(%struct._cl_device_id* %10, i32 4139, i64 256, i8* %11, i64* null)
  store i32 %call82, i32* %err, align 4, !tbaa !11
  %cmp84 = icmp eq i32 %call82, 0
  br i1 %cmp84, label %do.end92, label %if.end87

if.end87:                                         ; preds = %if.end78
  %call86 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([16 x i8]* @.str18, i64 0, i64 0), i32 %call82)
  %.pr293 = load i32* %err, align 4, !tbaa !11
  %cmp88 = icmp eq i32 %.pr293, 0
  br i1 %cmp88, label %do.end92, label %if.then89

if.then89:                                        ; preds = %if.end87
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end92

do.end92:                                         ; preds = %if.end78, %if.then89, %if.end87
  %call94 = call i64 @halide_current_time_ns(i8* %user_context)
  %call95 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([51 x i8]* @.str19, i64 0, i64 0), i8* %11, i64 %call94)
  %arrayinit.begin = getelementptr inbounds [3 x i64]* %properties, i64 0, i64 0
  store i64 4228, i64* %arrayinit.begin, align 16, !tbaa !10
  %arrayinit.element = getelementptr inbounds [3 x i64]* %properties, i64 0, i64 1
  %12 = ptrtoint %struct._cl_platform_id* %platform.2 to i64
  store i64 %12, i64* %arrayinit.element, align 8, !tbaa !10
  %arrayinit.element96 = getelementptr inbounds [3 x i64]* %properties, i64 0, i64 2
  store i64 0, i64* %arrayinit.element96, align 16, !tbaa !10
  %call98 = call %struct._cl_context* @clCreateContext(i64* %arrayinit.begin, i32 1, %struct._cl_device_id** %dev, void (i8*, i8*, i64, i8*)* null, i8* null, i32* %err)
  %13 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  store %struct._cl_context* %call98, %struct._cl_context** %13, align 8, !tbaa !1
  %14 = load i32* %err, align 4, !tbaa !11
  %cmp100 = icmp eq i32 %14, 0
  br i1 %cmp100, label %do.end108, label %if.end103

if.end103:                                        ; preds = %do.end92
  %call102 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([16 x i8]* @.str20, i64 0, i64 0), i32 %14)
  %.pr295 = load i32* %err, align 4, !tbaa !11
  %cmp104 = icmp eq i32 %.pr295, 0
  br i1 %cmp104, label %do.end108, label %if.then105

if.then105:                                       ; preds = %if.end103
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end108

do.end108:                                        ; preds = %do.end92, %if.then105, %if.end103
  %15 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %16 = load %struct._cl_command_queue** %15, align 8, !tbaa !1
  %tobool109 = icmp eq %struct._cl_command_queue* %16, null
  br i1 %tobool109, label %if.end111, label %if.then110

if.then110:                                       ; preds = %do.end108
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str21, i64 0, i64 0))
  br label %if.end111

if.end111:                                        ; preds = %do.end108, %if.then110
  %17 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %18 = load %struct._cl_context** %17, align 8, !tbaa !1
  %19 = load %struct._cl_device_id** %dev, align 8, !tbaa !1
  %call112 = call %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context* %18, %struct._cl_device_id* %19, i64 0, i32* %err)
  %20 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  store %struct._cl_command_queue* %call112, %struct._cl_command_queue** %20, align 8, !tbaa !1
  %21 = load i32* %err, align 4, !tbaa !11
  %cmp114 = icmp eq i32 %21, 0
  br i1 %cmp114, label %cleanup123, label %if.end117

if.end117:                                        ; preds = %if.end111
  %call116 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([21 x i8]* @.str22, i64 0, i64 0), i32 %21)
  %.pr297 = load i32* %err, align 4, !tbaa !11
  %cmp118 = icmp eq i32 %.pr297, 0
  br i1 %cmp118, label %cleanup123, label %if.then119

if.then119:                                       ; preds = %if.end117
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %cleanup123

cleanup123:                                       ; preds = %if.end111, %if.end117, %if.then119, %if.then76
  %cleanup.dest.slot.1 = phi i1 [ true, %if.then76 ], [ false, %if.then119 ], [ false, %if.end117 ], [ false, %if.end111 ]
  call void @llvm.lifetime.end(i64 256, i8* %8) #3
  %22 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %tobool165 = icmp ne %struct._cl_program* %22, null
  %or.cond = or i1 %cleanup.dest.slot.1, %tobool165
  %or.cond.not = xor i1 %or.cond, true
  %cmp166.old = icmp sgt i32 %size, 1
  %or.cond283 = and i1 %cmp166.old, %or.cond.not
  br i1 %or.cond283, label %if.then167, label %if.end223

if.else126:                                       ; preds = %entry
  %call127 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([24 x i8]* @.str23, i64 0, i64 0), %struct._cl_context* %1)
  %23 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %24 = load %struct._cl_context** %23, align 8, !tbaa !1
  %call130 = call i32 @clRetainContext(%struct._cl_context* %24)
  %cond = icmp eq i32 %call130, 0
  br i1 %cond, label %do.body140, label %if.then132

if.then132:                                       ; preds = %if.else126
  %call133 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([16 x i8]* @.str24, i64 0, i64 0), i32 %call130)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.body140

do.body140:                                       ; preds = %if.else126, %if.then132
  %25 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %26 = load %struct._cl_command_queue** %25, align 8, !tbaa !1
  %call142 = call i32 @clRetainCommandQueue(%struct._cl_command_queue* %26)
  %cond284 = icmp eq i32 %call142, 0
  br i1 %cond284, label %do.body152, label %if.then144

if.then144:                                       ; preds = %do.body140
  %call145 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([21 x i8]* @.str25, i64 0, i64 0), i32 %call142)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.body152

do.body152:                                       ; preds = %do.body140, %if.then144
  %27 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %28 = load %struct._cl_context** %27, align 8, !tbaa !1
  %29 = bitcast %struct._cl_device_id** %dev to i8*
  %call154 = call i32 @clGetContextInfo(%struct._cl_context* %28, i32 4225, i64 8, i8* %29, i64* null)
  %cond285 = icmp eq i32 %call154, 0
  br i1 %cond285, label %if.end164, label %if.then156

if.then156:                                       ; preds = %do.body152
  %call157 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([17 x i8]* @.str26, i64 0, i64 0), i32 %call154)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %if.end164

if.end164:                                        ; preds = %do.body152, %if.then156
  %.old = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %tobool165.old = icmp eq %struct._cl_program* %.old, null
  %cmp166 = icmp sgt i32 %size, 1
  %or.cond282 = and i1 %tobool165.old, %cmp166
  br i1 %or.cond282, label %if.then167, label %if.end223

if.then167:                                       ; preds = %cleanup123, %if.end164
  %arrayinit.begin169 = getelementptr inbounds [1 x %struct._cl_device_id*]* %devices168, i64 0, i64 0
  %30 = load %struct._cl_device_id** %dev, align 8, !tbaa !1
  store %struct._cl_device_id* %30, %struct._cl_device_id** %arrayinit.begin169, align 8, !tbaa !1
  %arrayinit.begin170 = getelementptr inbounds [1 x i64]* %lengths, i64 0, i64 0
  %conv = sext i32 %size to i64
  store i64 %conv, i64* %arrayinit.begin170, align 8, !tbaa !10
  %call171 = call i8* @strstr(i8* %src, i8* getelementptr inbounds ([13 x i8]* @.str27, i64 0, i64 0))
  %tobool172 = icmp eq i8* %call171, null
  br i1 %tobool172, label %if.else188, label %if.then173

if.then173:                                       ; preds = %if.then167
  %call174 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([32 x i8]* @.str28, i64 0, i64 0), i8* %src)
  %arrayinit.begin175 = getelementptr inbounds [1 x i8*]* %sources, i64 0, i64 0
  store i8* %src, i8** %arrayinit.begin175, align 8, !tbaa !1
  %31 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %32 = load %struct._cl_context** %31, align 8, !tbaa !1
  %call177 = call %struct._cl_program* @clCreateProgramWithSource(%struct._cl_context* %32, i32 1, i8** %arrayinit.begin175, i64* null, i32* %err)
  store %struct._cl_program* %call177, %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %33 = load i32* %err, align 4, !tbaa !11
  %cmp179 = icmp eq i32 %33, 0
  br i1 %cmp179, label %if.end205, label %if.end182

if.end182:                                        ; preds = %if.then173
  %call181 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([26 x i8]* @.str29, i64 0, i64 0), i32 %33)
  %.pr299 = load i32* %err, align 4, !tbaa !11
  %cmp183 = icmp eq i32 %.pr299, 0
  br i1 %cmp183, label %if.end205, label %if.then184

if.then184:                                       ; preds = %if.end182
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %if.end205

if.else188:                                       ; preds = %if.then167
  %call189 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([34 x i8]* @.str30, i64 0, i64 0), i32 %size)
  %arrayinit.begin190 = getelementptr inbounds [1 x i8*]* %binaries, i64 0, i64 0
  store i8* %src, i8** %arrayinit.begin190, align 8, !tbaa !1
  %34 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %35 = load %struct._cl_context** %34, align 8, !tbaa !1
  %call194 = call %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context* %35, i32 1, %struct._cl_device_id** %arrayinit.begin169, i64* %arrayinit.begin170, i8** %arrayinit.begin190, i32* null, i32* %err)
  store %struct._cl_program* %call194, %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %36 = load i32* %err, align 4, !tbaa !11
  %cmp196 = icmp eq i32 %36, 0
  br i1 %cmp196, label %if.end205, label %if.end199

if.end199:                                        ; preds = %if.else188
  %call198 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([26 x i8]* @.str31, i64 0, i64 0), i32 %36)
  %.pr301 = load i32* %err, align 4, !tbaa !11
  %cmp200 = icmp eq i32 %.pr301, 0
  br i1 %cmp200, label %if.end205, label %if.then201

if.then201:                                       ; preds = %if.end199
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %if.end205

if.end205:                                        ; preds = %if.else188, %if.then173, %if.then201, %if.end199, %if.then184, %if.end182
  %37 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %call206 = call i32 @clBuildProgram(%struct._cl_program* %37, i32 1, %struct._cl_device_id** %dev, i8* null, void (%struct._cl_program*, i8*)* null, i8* null)
  store i32 %call206, i32* %err, align 4, !tbaa !11
  %cmp207 = icmp eq i32 %call206, 0
  br i1 %cmp207, label %if.end223, label %if.then208

if.then208:                                       ; preds = %if.end205
  %38 = getelementptr inbounds [2048 x i8]* %buffer, i64 0, i64 0
  call void @llvm.lifetime.start(i64 2048, i8* %38) #3
  %call209 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str32, i64 0, i64 0), i32 %call206)
  %39 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %40 = load %struct._cl_device_id** %dev, align 8, !tbaa !1
  %call211 = call i32 @clGetProgramBuildInfo(%struct._cl_program* %39, %struct._cl_device_id* %40, i32 4483, i64 2048, i8* %38, i64* %len)
  %cmp212 = icmp eq i32 %call211, 0
  br i1 %cmp212, label %if.then213, label %if.else216

if.then213:                                       ; preds = %if.then208
  %call215 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str33, i64 0, i64 0), i8* %38)
  br label %if.end218

if.else216:                                       ; preds = %if.then208
  %call217 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([48 x i8]* @.str34, i64 0, i64 0))
  br label %if.end218

if.end218:                                        ; preds = %if.else216, %if.then213
  %41 = load i32* %err, align 4, !tbaa !11
  %cmp219 = icmp eq i32 %41, 0
  br i1 %cmp219, label %if.end223, label %if.then220

if.then220:                                       ; preds = %if.end218
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %if.end223

if.end223:                                        ; preds = %if.end218, %if.then220, %cleanup123, %if.end164, %if.end205, %if.then28
  ret void
}

declare i32 @clGetPlatformIDs(i32, %struct._cl_platform_id**, i32*) #1

; Function Attrs: nounwind readonly
declare i8* @getenv(i8* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #3

declare i32 @clGetPlatformInfo(%struct._cl_platform_id*, i32, i64, i8*, i64*) #1

; Function Attrs: nounwind readonly
declare i8* @strstr(i8*, i8* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #3

declare i64 @halide_current_time_ns(i8*) #1

declare i32 @clGetDeviceIDs(%struct._cl_platform_id*, i64, i32, %struct._cl_device_id**, i32*) #1

declare i32 @clGetDeviceInfo(%struct._cl_device_id*, i32, i64, i8*, i64*) #1

declare %struct._cl_context* @clCreateContext(i64*, i32, %struct._cl_device_id**, void (i8*, i8*, i64, i8*)*, i8*, i32*) #1

declare %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context*, %struct._cl_device_id*, i64, i32*) #1

declare i32 @clRetainContext(%struct._cl_context*) #1

declare i32 @clRetainCommandQueue(%struct._cl_command_queue*) #1

declare i32 @clGetContextInfo(%struct._cl_context*, i32, i64, i8*, i64*) #1

declare %struct._cl_program* @clCreateProgramWithSource(%struct._cl_context*, i32, i8**, i64*, i32*) #1

declare %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context*, i32, %struct._cl_device_id**, i64*, i8**, i32*, i32*) #1

declare i32 @clBuildProgram(%struct._cl_program*, i32, %struct._cl_device_id**, i8*, void (%struct._cl_program*, i8*)*, i8*) #1

declare i32 @clGetProgramBuildInfo(%struct._cl_program*, %struct._cl_device_id*, i32, i64, i8*, i64*) #1

; Function Attrs: uwtable
define weak void @halide_dev_sync(i8* %user_context) #0 {
entry:
  %0 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %1 = load %struct._cl_command_queue** %0, align 8, !tbaa !1
  %call = tail call i32 @clFinish(%struct._cl_command_queue* %1)
  ret void
}

declare i32 @clFinish(%struct._cl_command_queue*) #1

; Function Attrs: uwtable
define weak void @halide_release(i8* %user_context) #0 {
entry:
  %refs = alloca i32, align 4
  %call = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str35, i64 0, i64 0))
  call void @halide_dev_sync(i8* %user_context)
  %0 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %tobool = icmp eq %struct._cl_program* %0, null
  br i1 %tobool, label %if.end8, label %if.then

if.then:                                          ; preds = %entry
  %call1 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([21 x i8]* @.str36, i64 0, i64 0), %struct._cl_program* %0)
  %1 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %call2 = call i32 @clReleaseProgram(%struct._cl_program* %1)
  %cond = icmp eq i32 %call2, 0
  br i1 %cond, label %do.end, label %if.then3

if.then3:                                         ; preds = %if.then
  %call4 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([17 x i8]* @.str37, i64 0, i64 0), i32 %call2)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %if.then, %if.then3
  store %struct._cl_program* null, %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  br label %if.end8

if.end8:                                          ; preds = %entry, %do.end
  store i32 0, i32* %refs, align 4, !tbaa !11
  %2 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %3 = load %struct._cl_context** %2, align 8, !tbaa !1
  %4 = bitcast i32* %refs to i8*
  %call9 = call i32 @clGetContextInfo(%struct._cl_context* %3, i32 4224, i64 4, i8* %4, i64* null)
  %5 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %6 = load %struct._cl_command_queue** %5, align 8, !tbaa !1
  %call12 = call i32 @clReleaseCommandQueue(%struct._cl_command_queue* %6)
  %cond51 = icmp eq i32 %call12, 0
  br i1 %cond51, label %do.end20, label %if.then14

if.then14:                                        ; preds = %if.end8
  %call15 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([22 x i8]* @.str38, i64 0, i64 0), i32 %call12)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end20

do.end20:                                         ; preds = %if.end8, %if.then14
  %7 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %8 = load %struct._cl_context** %7, align 8, !tbaa !1
  %call21 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([21 x i8]* @.str39, i64 0, i64 0), %struct._cl_context* %8)
  %9 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %10 = load %struct._cl_context** %9, align 8, !tbaa !1
  %call24 = call i32 @clReleaseContext(%struct._cl_context* %10)
  %cond52 = icmp eq i32 %call24, 0
  br i1 %cond52, label %do.end32, label %if.then26

if.then26:                                        ; preds = %do.end20
  %call27 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([17 x i8]* @.str40, i64 0, i64 0), i32 %call24)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end32

do.end32:                                         ; preds = %do.end20, %if.then26
  %11 = load i32* %refs, align 4, !tbaa !11
  %dec = add i32 %11, -1
  store i32 %dec, i32* %refs, align 4, !tbaa !11
  %cmp33 = icmp eq i32 %dec, 0
  br i1 %cmp33, label %if.then34, label %if.end35

if.then34:                                        ; preds = %do.end32
  %12 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  store %struct._cl_context* null, %struct._cl_context** %12, align 8, !tbaa !1
  %13 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  store %struct._cl_command_queue* null, %struct._cl_command_queue** %13, align 8, !tbaa !1
  br label %if.end35

if.end35:                                         ; preds = %if.then34, %do.end32
  ret void
}

declare i32 @clReleaseProgram(%struct._cl_program*) #1

declare i32 @clReleaseCommandQueue(%struct._cl_command_queue*) #1

declare i32 @clReleaseContext(%struct._cl_context*) #1

; Function Attrs: uwtable
define weak void @halide_dev_malloc(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %err.i = alloca i32, align 4
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %0 = load i64* %dev, align 8, !tbaa !5
  %tobool = icmp eq i64 %0, 0
  br i1 %tobool, label %if.end2, label %if.then

if.then:                                          ; preds = %entry
  %call = call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i64 0)
  br i1 %call, label %if.end32, label %if.then1

if.then1:                                         ; preds = %if.then
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str4, i64 0, i64 0))
  br label %if.end32

if.end2:                                          ; preds = %entry
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 5
  %1 = load i32* %elem_size.i, align 4, !tbaa !12
  %arrayidx.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 0
  %2 = load i32* %arrayidx.i, align 4, !tbaa !11
  %mul.i = mul nsw i32 %2, %1
  %arrayidx2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 0
  %3 = load i32* %arrayidx2.i, align 4, !tbaa !11
  %mul3.i = mul nsw i32 %mul.i, %3
  %conv4.i = sext i32 %mul3.i to i64
  %arrayidx.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 1
  %4 = load i32* %arrayidx.1.i, align 4, !tbaa !11
  %mul.1.i = mul nsw i32 %4, %1
  %arrayidx2.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 1
  %5 = load i32* %arrayidx2.1.i, align 4, !tbaa !11
  %mul3.1.i = mul nsw i32 %mul.1.i, %5
  %conv4.1.i = sext i32 %mul3.1.i to i64
  %cmp5.1.i = icmp ugt i64 %conv4.1.i, %conv4.i
  %conv4.size.0.1.i = select i1 %cmp5.1.i, i64 %conv4.1.i, i64 %conv4.i
  %arrayidx.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 2
  %6 = load i32* %arrayidx.2.i, align 4, !tbaa !11
  %mul.2.i = mul nsw i32 %6, %1
  %arrayidx2.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 2
  %7 = load i32* %arrayidx2.2.i, align 4, !tbaa !11
  %mul3.2.i = mul nsw i32 %mul.2.i, %7
  %conv4.2.i = sext i32 %mul3.2.i to i64
  %cmp5.2.i = icmp ugt i64 %conv4.2.i, %conv4.size.0.1.i
  %conv4.size.0.2.i = select i1 %cmp5.2.i, i64 %conv4.2.i, i64 %conv4.size.0.1.i
  %arrayidx.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 3
  %8 = load i32* %arrayidx.3.i, align 4, !tbaa !11
  %mul.3.i = mul nsw i32 %8, %1
  %arrayidx2.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 3
  %9 = load i32* %arrayidx2.3.i, align 4, !tbaa !11
  %mul3.3.i = mul nsw i32 %mul.3.i, %9
  %conv4.3.i = sext i32 %mul3.3.i to i64
  %cmp5.3.i = icmp ugt i64 %conv4.3.i, %conv4.size.0.2.i
  %conv4.size.0.3.i = select i1 %cmp5.3.i, i64 %conv4.3.i, i64 %conv4.size.0.2.i
  %tobool.i = icmp eq i64 %conv4.size.0.3.i, 0
  br i1 %tobool.i, label %if.then6.i, label %_Z10__buf_sizePvP8buffer_t.exit

if.then6.i:                                       ; preds = %if.end2
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str59, i64 0, i64 0))
  %.pre = load i32* %arrayidx.i, align 4, !tbaa !11
  %.pre54 = load i32* %arrayidx.1.i, align 4, !tbaa !11
  %.pre55 = load i32* %arrayidx.2.i, align 4, !tbaa !11
  %.pre56 = load i32* %arrayidx.3.i, align 4, !tbaa !11
  %.pre57 = load i32* %arrayidx2.i, align 4, !tbaa !11
  %.pre58 = load i32* %arrayidx2.1.i, align 4, !tbaa !11
  %.pre59 = load i32* %arrayidx2.2.i, align 4, !tbaa !11
  %.pre60 = load i32* %arrayidx2.3.i, align 4, !tbaa !11
  %.pre61 = load i32* %elem_size.i, align 4, !tbaa !12
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end2, %if.then6.i
  %10 = phi i32 [ %1, %if.end2 ], [ %.pre61, %if.then6.i ]
  %11 = phi i32 [ %9, %if.end2 ], [ %.pre60, %if.then6.i ]
  %12 = phi i32 [ %7, %if.end2 ], [ %.pre59, %if.then6.i ]
  %13 = phi i32 [ %5, %if.end2 ], [ %.pre58, %if.then6.i ]
  %14 = phi i32 [ %3, %if.end2 ], [ %.pre57, %if.then6.i ]
  %15 = phi i32 [ %8, %if.end2 ], [ %.pre56, %if.then6.i ]
  %16 = phi i32 [ %6, %if.end2 ], [ %.pre55, %if.then6.i ]
  %17 = phi i32 [ %4, %if.end2 ], [ %.pre54, %if.then6.i ]
  %18 = phi i32 [ %2, %if.end2 ], [ %.pre, %if.then6.i ]
  %conv = sext i32 %18 to i64
  %conv6 = sext i32 %17 to i64
  %conv9 = sext i32 %16 to i64
  %conv12 = sext i32 %15 to i64
  %conv14 = sext i32 %14 to i64
  %conv17 = sext i32 %13 to i64
  %conv20 = sext i32 %12 to i64
  %conv23 = sext i32 %11 to i64
  %call24 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([126 x i8]* @.str41, i64 0, i64 0), i64 %conv4.size.0.3.i, i64 %conv, i64 %conv6, i64 %conv9, i64 %conv12, i64 %conv14, i64 %conv17, i64 %conv20, i64 %conv23, i32 %10)
  %19 = bitcast i32* %err.i to i8*
  call void @llvm.lifetime.start(i64 4, i8* %19)
  %call.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([25 x i8]* @.str56, i64 0, i64 0), i64 %conv4.size.0.3.i)
  %20 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %21 = load %struct._cl_context** %20, align 8, !tbaa !1
  %call1.i = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %21, i64 1, i64 %conv4.size.0.3.i, i8* null, i32* %err.i)
  %22 = load i32* %err.i, align 4, !tbaa !11
  %call2.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([28 x i8]* @.str57, i64 0, i64 0), %struct._cl_mem* %call1.i, i32 %22)
  %tobool.i53 = icmp eq %struct._cl_mem* %call1.i, null
  br i1 %tobool.i53, label %if.then.i, label %_Z12__dev_mallocPvm.exit

if.then.i:                                        ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([2 x i8]* @.str58, i64 0, i64 0))
  br label %_Z12__dev_mallocPvm.exit

_Z12__dev_mallocPvm.exit:                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit, %if.then.i
  call void @llvm.lifetime.end(i64 4, i8* %19)
  %23 = ptrtoint %struct._cl_mem* %call1.i to i64
  store i64 %23, i64* %dev, align 8, !tbaa !5
  %call28 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([55 x i8]* @.str42, i64 0, i64 0), %struct.buffer_t* %buf, %struct._cl_mem* %call1.i)
  %24 = load i64* %dev, align 8, !tbaa !5
  %tobool30 = icmp eq i64 %24, 0
  br i1 %tobool30, label %if.then31, label %if.end32

if.then31:                                        ; preds = %_Z12__dev_mallocPvm.exit
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str43, i64 0, i64 0))
  br label %if.end32

if.end32:                                         ; preds = %_Z12__dev_mallocPvm.exit, %if.then, %if.then1, %if.then31
  ret void
}

; Function Attrs: uwtable
define weak void @halide_copy_to_dev(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %host_dirty = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 6
  %0 = load i8* %host_dirty, align 1, !tbaa !13, !range !14
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end19, label %if.then

if.then:                                          ; preds = %entry
  %host = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 1
  %1 = load i8** %host, align 8, !tbaa !15
  %tobool1 = icmp eq i8* %1, null
  br i1 %tobool1, label %if.then3, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.then
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %2 = load i64* %dev, align 8, !tbaa !5
  %tobool2 = icmp eq i64 %2, 0
  br i1 %tobool2, label %if.then3, label %if.end

if.then3:                                         ; preds = %land.lhs.true, %if.then
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str44, i64 0, i64 0))
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then3
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 5
  %3 = load i32* %elem_size.i, align 4, !tbaa !12
  %arrayidx.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 0
  %4 = load i32* %arrayidx.i, align 4, !tbaa !11
  %mul.i = mul nsw i32 %4, %3
  %arrayidx2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 0
  %5 = load i32* %arrayidx2.i, align 4, !tbaa !11
  %mul3.i = mul nsw i32 %mul.i, %5
  %conv4.i = sext i32 %mul3.i to i64
  %arrayidx.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 1
  %6 = load i32* %arrayidx.1.i, align 4, !tbaa !11
  %mul.1.i = mul nsw i32 %6, %3
  %arrayidx2.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 1
  %7 = load i32* %arrayidx2.1.i, align 4, !tbaa !11
  %mul3.1.i = mul nsw i32 %mul.1.i, %7
  %conv4.1.i = sext i32 %mul3.1.i to i64
  %cmp5.1.i = icmp ugt i64 %conv4.1.i, %conv4.i
  %conv4.size.0.1.i = select i1 %cmp5.1.i, i64 %conv4.1.i, i64 %conv4.i
  %arrayidx.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 2
  %8 = load i32* %arrayidx.2.i, align 4, !tbaa !11
  %mul.2.i = mul nsw i32 %8, %3
  %arrayidx2.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 2
  %9 = load i32* %arrayidx2.2.i, align 4, !tbaa !11
  %mul3.2.i = mul nsw i32 %mul.2.i, %9
  %conv4.2.i = sext i32 %mul3.2.i to i64
  %cmp5.2.i = icmp ugt i64 %conv4.2.i, %conv4.size.0.1.i
  %conv4.size.0.2.i = select i1 %cmp5.2.i, i64 %conv4.2.i, i64 %conv4.size.0.1.i
  %arrayidx.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 3
  %10 = load i32* %arrayidx.3.i, align 4, !tbaa !11
  %mul.3.i = mul nsw i32 %10, %3
  %arrayidx2.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 3
  %11 = load i32* %arrayidx2.3.i, align 4, !tbaa !11
  %mul3.3.i = mul nsw i32 %mul.3.i, %11
  %conv4.3.i = sext i32 %mul3.3.i to i64
  %cmp5.3.i = icmp ugt i64 %conv4.3.i, %conv4.size.0.2.i
  %conv4.size.0.3.i = select i1 %cmp5.3.i, i64 %conv4.3.i, i64 %conv4.size.0.2.i
  %tobool.i = icmp eq i64 %conv4.size.0.3.i, 0
  br i1 %tobool.i, label %if.then6.i, label %_Z10__buf_sizePvP8buffer_t.exit

if.then6.i:                                       ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str59, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then6.i
  %12 = load i8** %host, align 8, !tbaa !15
  %dev5 = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %13 = load i64* %dev5, align 8, !tbaa !5
  %14 = inttoptr i64 %13 to i8*
  %call6 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str45, i64 0, i64 0), i64 %conv4.size.0.3.i, i8* %12, i8* %14)
  %call7 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i64 0)
  br i1 %call7, label %if.end9, label %if.then8

if.then8:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str4, i64 0, i64 0))
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %_Z10__buf_sizePvP8buffer_t.exit
  %15 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %16 = load %struct._cl_command_queue** %15, align 8, !tbaa !1
  %17 = load i64* %dev5, align 8, !tbaa !5
  %18 = inttoptr i64 %17 to %struct._cl_mem*
  %19 = load i8** %host, align 8, !tbaa !15
  %call12 = tail call i32 @clEnqueueWriteBuffer(%struct._cl_command_queue* %16, %struct._cl_mem* %18, i32 1, i64 0, i64 %conv4.size.0.3.i, i8* %19, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  %cond = icmp eq i32 %call12, 0
  br i1 %cond, label %if.end19, label %if.then13

if.then13:                                        ; preds = %if.end9
  %call14 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([21 x i8]* @.str46, i64 0, i64 0), i32 %call12)
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %if.end19

if.end19:                                         ; preds = %if.end9, %entry, %if.then13
  store i8 0, i8* %host_dirty, align 1, !tbaa !13
  ret void
}

declare i32 @clEnqueueWriteBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i64, i64, i8*, i32, %struct._cl_event**, %struct._cl_event**) #1

; Function Attrs: uwtable
define weak void @halide_copy_to_host(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %dev_dirty = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 7
  %0 = load i8* %dev_dirty, align 1, !tbaa !16, !range !14
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end20, label %if.then

if.then:                                          ; preds = %entry
  %1 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %2 = load %struct._cl_command_queue** %1, align 8, !tbaa !1
  %call = tail call i32 @clFinish(%struct._cl_command_queue* %2)
  %host = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 1
  %3 = load i8** %host, align 8, !tbaa !15
  %tobool1 = icmp eq i8* %3, null
  br i1 %tobool1, label %if.then3, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.then
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %4 = load i64* %dev, align 8, !tbaa !5
  %tobool2 = icmp eq i64 %4, 0
  br i1 %tobool2, label %if.then3, label %if.end

if.then3:                                         ; preds = %land.lhs.true, %if.then
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str44, i64 0, i64 0))
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then3
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 5
  %5 = load i32* %elem_size.i, align 4, !tbaa !12
  %arrayidx.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 0
  %6 = load i32* %arrayidx.i, align 4, !tbaa !11
  %mul.i = mul nsw i32 %6, %5
  %arrayidx2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 0
  %7 = load i32* %arrayidx2.i, align 4, !tbaa !11
  %mul3.i = mul nsw i32 %mul.i, %7
  %conv4.i = sext i32 %mul3.i to i64
  %arrayidx.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 1
  %8 = load i32* %arrayidx.1.i, align 4, !tbaa !11
  %mul.1.i = mul nsw i32 %8, %5
  %arrayidx2.1.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 1
  %9 = load i32* %arrayidx2.1.i, align 4, !tbaa !11
  %mul3.1.i = mul nsw i32 %mul.1.i, %9
  %conv4.1.i = sext i32 %mul3.1.i to i64
  %cmp5.1.i = icmp ugt i64 %conv4.1.i, %conv4.i
  %conv4.size.0.1.i = select i1 %cmp5.1.i, i64 %conv4.1.i, i64 %conv4.i
  %arrayidx.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 2
  %10 = load i32* %arrayidx.2.i, align 4, !tbaa !11
  %mul.2.i = mul nsw i32 %10, %5
  %arrayidx2.2.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 2
  %11 = load i32* %arrayidx2.2.i, align 4, !tbaa !11
  %mul3.2.i = mul nsw i32 %mul.2.i, %11
  %conv4.2.i = sext i32 %mul3.2.i to i64
  %cmp5.2.i = icmp ugt i64 %conv4.2.i, %conv4.size.0.1.i
  %conv4.size.0.2.i = select i1 %cmp5.2.i, i64 %conv4.2.i, i64 %conv4.size.0.1.i
  %arrayidx.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 2, i64 3
  %12 = load i32* %arrayidx.3.i, align 4, !tbaa !11
  %mul.3.i = mul nsw i32 %12, %5
  %arrayidx2.3.i = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 3, i64 3
  %13 = load i32* %arrayidx2.3.i, align 4, !tbaa !11
  %mul3.3.i = mul nsw i32 %mul.3.i, %13
  %conv4.3.i = sext i32 %mul3.3.i to i64
  %cmp5.3.i = icmp ugt i64 %conv4.3.i, %conv4.size.0.2.i
  %conv4.size.0.3.i = select i1 %cmp5.3.i, i64 %conv4.3.i, i64 %conv4.size.0.2.i
  %tobool.i = icmp eq i64 %conv4.size.0.3.i, 0
  br i1 %tobool.i, label %if.then6.i, label %_Z10__buf_sizePvP8buffer_t.exit

if.then6.i:                                       ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str59, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then6.i
  %dev5 = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %14 = load i64* %dev5, align 8, !tbaa !5
  %15 = inttoptr i64 %14 to i8*
  %16 = load i8** %host, align 8, !tbaa !15
  %call7 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([43 x i8]* @.str47, i64 0, i64 0), %struct.buffer_t* %buf, i64 %conv4.size.0.3.i, i8* %15, i8* %16)
  %call8 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i64 %conv4.size.0.3.i)
  br i1 %call8, label %if.end10, label %if.then9

if.then9:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str48, i64 0, i64 0))
  br label %if.end10

if.end10:                                         ; preds = %if.then9, %_Z10__buf_sizePvP8buffer_t.exit
  %17 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %18 = load %struct._cl_command_queue** %17, align 8, !tbaa !1
  %19 = load i64* %dev5, align 8, !tbaa !5
  %20 = inttoptr i64 %19 to %struct._cl_mem*
  %21 = load i8** %host, align 8, !tbaa !15
  %call13 = tail call i32 @clEnqueueReadBuffer(%struct._cl_command_queue* %18, %struct._cl_mem* %20, i32 1, i64 0, i64 %conv4.size.0.3.i, i8* %21, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  %cond = icmp eq i32 %call13, 0
  br i1 %cond, label %if.end20, label %if.then14

if.then14:                                        ; preds = %if.end10
  %call15 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([20 x i8]* @.str49, i64 0, i64 0), i32 %call13)
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %if.end20

if.end20:                                         ; preds = %if.end10, %entry, %if.then14
  store i8 0, i8* %dev_dirty, align 1, !tbaa !16
  ret void
}

declare i32 @clEnqueueReadBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i64, i64, i8*, i32, %struct._cl_event**, %struct._cl_event**) #1

; Function Attrs: uwtable
define weak void @halide_dev_run(i8* %user_context, i8* %entry_name, i32 %blocksX, i32 %blocksY, i32 %blocksZ, i32 %threadsX, i32 %threadsY, i32 %threadsZ, i32 %shared_mem_bytes, i64* %arg_sizes, i8** %args) #0 {
entry:
  %err.i = alloca i32, align 4
  %global_dim = alloca [3 x i64], align 16
  %local_dim = alloca [3 x i64], align 16
  %0 = bitcast i32* %err.i to i8*
  call void @llvm.lifetime.start(i64 4, i8* %0)
  %call.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([15 x i8]* @.str54, i64 0, i64 0), i8* %entry_name)
  %1 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %call1.i = call %struct._cl_kernel* @clCreateKernel(%struct._cl_program* %1, i8* %entry_name, i32* %err.i)
  %2 = load i32* %err.i, align 4, !tbaa !11
  %cmp.i = icmp eq i32 %2, 0
  br i1 %cmp.i, label %_Z12__get_kernelPvPKc.exit, label %if.end.i

if.end.i:                                         ; preds = %entry
  %call2.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([15 x i8]* @.str55, i64 0, i64 0), i32 %2)
  %.pr.i = load i32* %err.i, align 4, !tbaa !11
  %cmp3.i = icmp eq i32 %.pr.i, 0
  br i1 %cmp3.i, label %_Z12__get_kernelPvPKc.exit, label %if.then4.i

if.then4.i:                                       ; preds = %if.end.i
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %_Z12__get_kernelPvPKc.exit

_Z12__get_kernelPvPKc.exit:                       ; preds = %entry, %if.end.i, %if.then4.i
  call void @llvm.lifetime.end(i64 4, i8* %0)
  %call1 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([63 x i8]* @.str50, i64 0, i64 0), i8* %entry_name, i32 %blocksX, i32 %blocksY, i32 %blocksZ, i32 %threadsX, i32 %threadsY, i32 %threadsZ, i32 %shared_mem_bytes)
  %arrayinit.begin = getelementptr inbounds [3 x i64]* %global_dim, i64 0, i64 0
  %mul = mul nsw i32 %threadsX, %blocksX
  %conv = sext i32 %mul to i64
  store i64 %conv, i64* %arrayinit.begin, align 16, !tbaa !10
  %arrayinit.element = getelementptr inbounds [3 x i64]* %global_dim, i64 0, i64 1
  %mul2 = mul nsw i32 %threadsY, %blocksY
  %conv3 = sext i32 %mul2 to i64
  store i64 %conv3, i64* %arrayinit.element, align 8, !tbaa !10
  %arrayinit.element4 = getelementptr inbounds [3 x i64]* %global_dim, i64 0, i64 2
  %mul5 = mul nsw i32 %threadsZ, %blocksZ
  %conv6 = sext i32 %mul5 to i64
  store i64 %conv6, i64* %arrayinit.element4, align 16, !tbaa !10
  %arrayinit.begin7 = getelementptr inbounds [3 x i64]* %local_dim, i64 0, i64 0
  %conv8 = sext i32 %threadsX to i64
  store i64 %conv8, i64* %arrayinit.begin7, align 16, !tbaa !10
  %arrayinit.element9 = getelementptr inbounds [3 x i64]* %local_dim, i64 0, i64 1
  %conv10 = sext i32 %threadsY to i64
  store i64 %conv10, i64* %arrayinit.element9, align 8, !tbaa !10
  %arrayinit.element11 = getelementptr inbounds [3 x i64]* %local_dim, i64 0, i64 2
  %conv12 = sext i32 %threadsZ to i64
  store i64 %conv12, i64* %arrayinit.element11, align 16, !tbaa !10
  %3 = load i64* %arg_sizes, align 8, !tbaa !10
  %cmp94 = icmp eq i64 %3, 0
  br i1 %cmp94, label %do.body28, label %while.body

while.body:                                       ; preds = %_Z12__get_kernelPvPKc.exit, %do.end
  %indvars.iv = phi i64 [ %indvars.iv.next, %do.end ], [ 0, %_Z12__get_kernelPvPKc.exit ]
  %4 = phi i64 [ %11, %do.end ], [ %3, %_Z12__get_kernelPvPKc.exit ]
  %arrayidx97 = phi i64* [ %arrayidx, %do.end ], [ %arg_sizes, %_Z12__get_kernelPvPKc.exit ]
  %i.095 = phi i32 [ %inc, %do.end ], [ 0, %_Z12__get_kernelPvPKc.exit ]
  %arrayidx16 = getelementptr inbounds i8** %args, i64 %indvars.iv
  %5 = load i8** %arrayidx16, align 8, !tbaa !1
  %6 = bitcast i8* %5 to i32*
  %7 = load i32* %6, align 4, !tbaa !11
  %8 = trunc i64 %indvars.iv to i32
  %call17 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str51, i64 0, i64 0), i32 %8, i64 %4, i32 %7)
  %9 = load i64* %arrayidx97, align 8, !tbaa !10
  %10 = load i8** %arrayidx16, align 8, !tbaa !1
  %call22 = call i32 @clSetKernelArg(%struct._cl_kernel* %call1.i, i32 %8, i64 %9, i8* %10)
  %cond = icmp eq i32 %call22, 0
  br i1 %cond, label %do.end, label %if.then

if.then:                                          ; preds = %while.body
  %call24 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([15 x i8]* @.str52, i64 0, i64 0), i32 %call22)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end

do.end:                                           ; preds = %while.body, %if.then
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %inc = add nsw i32 %i.095, 1
  %arrayidx = getelementptr inbounds i64* %arg_sizes, i64 %indvars.iv.next
  %11 = load i64* %arrayidx, align 8, !tbaa !10
  %cmp = icmp eq i64 %11, 0
  br i1 %cmp, label %do.body28, label %while.body

do.body28:                                        ; preds = %do.end, %_Z12__get_kernelPvPKc.exit
  %i.0.lcssa = phi i32 [ 0, %_Z12__get_kernelPvPKc.exit ], [ %inc, %do.end ]
  %cmp30 = icmp slt i32 %shared_mem_bytes, 1
  %12 = sext i32 %shared_mem_bytes to i64
  %conv31 = select i1 %cmp30, i64 1, i64 %12
  %call32 = call i32 @clSetKernelArg(%struct._cl_kernel* %call1.i, i32 %i.0.lcssa, i64 %conv31, i8* null)
  %cond92 = icmp eq i32 %call32, 0
  br i1 %cond92, label %do.end40, label %if.then34

if.then34:                                        ; preds = %do.body28
  %call35 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([15 x i8]* @.str52, i64 0, i64 0), i32 %call32)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end40

do.end40:                                         ; preds = %do.body28, %if.then34
  %13 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %14 = load %struct._cl_command_queue** %13, align 8, !tbaa !1
  %call43 = call i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue* %14, %struct._cl_kernel* %call1.i, i32 3, i64* null, i64* %arrayinit.begin, i64* %arrayinit.begin7, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  %cond93 = icmp eq i32 %call43, 0
  br i1 %cond93, label %do.end52, label %if.then46

if.then46:                                        ; preds = %do.end40
  %call47 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0), i8* getelementptr inbounds ([23 x i8]* @.str53, i64 0, i64 0), i32 %call43)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i64 0, i64 0))
  br label %do.end52

do.end52:                                         ; preds = %do.end40, %if.then46
  ret void
}

declare i32 @clSetKernelArg(%struct._cl_kernel*, i32, i64, i8*) #1

declare i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue*, %struct._cl_kernel*, i32, i64*, i64*, i64*, i32, %struct._cl_event**, %struct._cl_event**) #1

declare %struct._cl_kernel* @clCreateKernel(%struct._cl_program*, i8*, i32*) #1

declare %struct._cl_mem* @clCreateBuffer(%struct._cl_context*, i64, i64, i8*, i32*) #1

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !7, i64 0}
!6 = metadata !{metadata !"_ZTS8buffer_t", metadata !7, i64 0, metadata !2, i64 8, metadata !3, i64 16, metadata !3, i64 32, metadata !3, i64 48, metadata !8, i64 64, metadata !9, i64 68, metadata !9, i64 69}
!7 = metadata !{metadata !"long", metadata !3, i64 0}
!8 = metadata !{metadata !"int", metadata !3, i64 0}
!9 = metadata !{metadata !"bool", metadata !3, i64 0}
!10 = metadata !{metadata !7, metadata !7, i64 0}
!11 = metadata !{metadata !8, metadata !8, i64 0}
!12 = metadata !{metadata !6, metadata !8, i64 64}
!13 = metadata !{metadata !6, metadata !9, i64 68}
!14 = metadata !{i8 0, i8 2}
!15 = metadata !{metadata !6, metadata !2, i64 8}
!16 = metadata !{metadata !6, metadata !9, i64 69}
