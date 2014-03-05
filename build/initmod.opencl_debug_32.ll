; ModuleID = 'src/runtime/opencl_debug.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%struct._cl_context = type opaque
%struct._cl_command_queue = type opaque
%struct._cl_program = type opaque
%struct.buffer_t = type { i64, i8*, [4 x i32], [4 x i32], [4 x i32], i32, i8, i8 }
%struct._cl_mem = type opaque
%struct._cl_device_id = type opaque
%struct._cl_platform_id = type opaque
%struct._cl_event = type opaque
%struct._cl_kernel = type opaque

@weak_cl_ctx = weak global %struct._cl_context* null, align 4
@weak_cl_q = weak global %struct._cl_command_queue* null, align 4
@_Z6cl_ctx = internal unnamed_addr global %struct._cl_context** @weak_cl_ctx, align 4
@_Z4cl_q = internal unnamed_addr global %struct._cl_command_queue** @weak_cl_q, align 4
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
@_Z5__mod = internal unnamed_addr global %struct._cl_program* null, align 4
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

define weak void @halide_set_cl_context(%struct._cl_context** %ctx, %struct._cl_command_queue** %q) #0 {
entry:
  store %struct._cl_context** %ctx, %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  store %struct._cl_command_queue** %q, %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  ret void
}

define weak zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i32 %size) #0 {
entry:
  %real_size = alloca i32, align 4
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %0 = load i64* %dev, align 4, !tbaa !5
  %cmp = icmp eq i64 %0, 0
  br i1 %cmp, label %return, label %if.end

if.end:                                           ; preds = %entry
  %conv = trunc i64 %0 to i32
  %1 = inttoptr i32 %conv to %struct._cl_mem*
  %2 = bitcast i32* %real_size to i8*
  %call = call i32 @clGetMemObjectInfo(%struct._cl_mem* %1, i32 4354, i32 4, i8* %2, i32* null)
  %tobool = icmp eq i32 %call, 0
  %3 = load i64* %dev, align 4, !tbaa !5
  %conv4 = trunc i64 %3 to i32
  %4 = inttoptr i32 %conv4 to i8*
  br i1 %tobool, label %if.end6, label %if.then2

if.then2:                                         ; preds = %if.end
  %call5 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([55 x i8]* @.str, i32 0, i32 0), i8* %4, i32 %call)
  br label %return

if.end6:                                          ; preds = %if.end
  %conv9 = zext i32 %size to i64
  %5 = load i32* %real_size, align 4, !tbaa !10
  %conv10 = zext i32 %5 to i64
  %call11 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([52 x i8]* @.str1, i32 0, i32 0), i8* %4, i64 %conv9, i64 %conv10)
  %tobool12 = icmp eq i32 %size, 0
  br i1 %tobool12, label %return, label %if.then13

if.then13:                                        ; preds = %if.end6
  %6 = load i32* %real_size, align 4, !tbaa !10
  %cmp14 = icmp ult i32 %6, %size
  br i1 %cmp14, label %if.then15, label %return

if.then15:                                        ; preds = %if.then13
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([65 x i8]* @.str2, i32 0, i32 0))
  br label %return

return:                                           ; preds = %if.then15, %if.end6, %if.then13, %entry, %if.then2
  %retval.0 = phi i1 [ false, %if.then2 ], [ true, %entry ], [ true, %if.then13 ], [ true, %if.end6 ], [ true, %if.then15 ]
  ret i1 %retval.0
}

declare i32 @clGetMemObjectInfo(%struct._cl_mem*, i32, i32, i8*, i32*) #0

declare i32 @halide_printf(i8*, i8*, ...) #0

declare void @halide_error(i8*, i8*) #0

define weak void @halide_dev_free(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %0 = load i64* %dev, align 4, !tbaa !5
  %cmp = icmp eq i64 %0, 0
  br i1 %cmp, label %return, label %if.end

if.end:                                           ; preds = %entry
  %conv = trunc i64 %0 to i32
  %1 = inttoptr i32 %conv to i8*
  %call = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([31 x i8]* @.str3, i32 0, i32 0), %struct.buffer_t* %buf, i8* %1)
  %call2 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i32 0)
  br i1 %call2, label %do.body, label %if.then3

if.then3:                                         ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str4, i32 0, i32 0))
  br label %do.body

do.body:                                          ; preds = %if.end, %if.then3
  %2 = load i64* %dev, align 4, !tbaa !5
  %conv6 = trunc i64 %2 to i32
  %3 = inttoptr i32 %conv6 to %struct._cl_mem*
  %call7 = tail call i32 @clReleaseMemObject(%struct._cl_mem* %3)
  %cond = icmp eq i32 %call7, 0
  br i1 %cond, label %do.end, label %if.then9

if.then9:                                         ; preds = %do.body
  %call10 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([19 x i8]* @.str6, i32 0, i32 0), i32 %call7)
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end

do.end:                                           ; preds = %do.body, %if.then9
  store i64 0, i64* %dev, align 4, !tbaa !5
  br label %return

return:                                           ; preds = %entry, %do.end
  ret void
}

declare i32 @clReleaseMemObject(%struct._cl_mem*) #0

define weak void @halide_init_kernels(i8* %user_context, i8* %src, i32 %size) #0 {
entry:
  %err = alloca i32, align 4
  %dev = alloca %struct._cl_device_id*, align 4
  %platforms = alloca [4 x %struct._cl_platform_id*], align 4
  %platformCount = alloca i32, align 4
  %platformName = alloca [256 x i8], align 1
  %platformName31 = alloca [256 x i8], align 1
  %devices = alloca [4 x %struct._cl_device_id*], align 4
  %deviceCount = alloca i32, align 4
  %deviceName = alloca [256 x i8], align 1
  %properties = alloca [3 x i32], align 4
  %devices166 = alloca [1 x %struct._cl_device_id*], align 4
  %lengths = alloca [1 x i32], align 4
  %sources = alloca [1 x i8*], align 4
  %binaries = alloca [1 x i8*], align 4
  %len = alloca i32, align 4
  %buffer = alloca [2048 x i8], align 1
  %0 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %1 = load %struct._cl_context** %0, align 4, !tbaa !1
  %tobool = icmp eq %struct._cl_context* %1, null
  br i1 %tobool, label %if.then, label %if.else124

if.then:                                          ; preds = %entry
  store i32 0, i32* %platformCount, align 4, !tbaa !10
  %arraydecay = getelementptr inbounds [4 x %struct._cl_platform_id*]* %platforms, i32 0, i32 0
  %call = call i32 @clGetPlatformIDs(i32 4, %struct._cl_platform_id** %arraydecay, i32* %platformCount)
  store i32 %call, i32* %err, align 4, !tbaa !10
  %cmp = icmp eq i32 %call, 0
  br i1 %cmp, label %do.end, label %if.end

if.end:                                           ; preds = %if.then
  %call2 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([17 x i8]* @.str8, i32 0, i32 0), i32 %call)
  %.pr = load i32* %err, align 4, !tbaa !10
  %cmp3 = icmp eq i32 %.pr, 0
  br i1 %cmp3, label %do.end, label %if.then4

if.then4:                                         ; preds = %if.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end

do.end:                                           ; preds = %if.then, %if.end, %if.then4
  %call6 = call i8* @getenv(i8* getelementptr inbounds ([16 x i8]* @.str9, i32 0, i32 0))
  %cmp7 = icmp eq i8* %call6, null
  %2 = load i32* %platformCount, align 4, !tbaa !10
  %cmp21 = icmp eq i32 %2, 0
  br i1 %cmp7, label %if.else, label %for.cond.preheader

for.cond.preheader:                               ; preds = %do.end
  br i1 %cmp21, label %if.then27, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %3 = getelementptr inbounds [256 x i8]* %platformName, i32 0, i32 0
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %i.0303 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  call void @llvm.lifetime.start(i64 256, i8* %3) #2
  %arrayidx = getelementptr inbounds [4 x %struct._cl_platform_id*]* %platforms, i32 0, i32 %i.0303
  %4 = load %struct._cl_platform_id** %arrayidx, align 4, !tbaa !1
  %call11 = call i32 @clGetPlatformInfo(%struct._cl_platform_id* %4, i32 2306, i32 256, i8* %3, i32* null)
  store i32 %call11, i32* %err, align 4, !tbaa !10
  %cmp12 = icmp eq i32 %call11, 0
  br i1 %cmp12, label %if.end14, label %for.inc

if.end14:                                         ; preds = %for.body
  %call16 = call i8* @strstr(i8* %3, i8* %call6)
  %tobool17 = icmp eq i8* %call16, null
  br i1 %tobool17, label %for.inc, label %cleanup

cleanup:                                          ; preds = %if.end14
  %5 = load %struct._cl_platform_id** %arrayidx, align 4, !tbaa !1
  call void @llvm.lifetime.end(i64 256, i8* %3) #2
  br label %if.end25

for.inc:                                          ; preds = %for.body, %if.end14
  call void @llvm.lifetime.end(i64 256, i8* %3) #2
  %inc = add i32 %i.0303, 1
  %6 = load i32* %platformCount, align 4, !tbaa !10
  %cmp9 = icmp ult i32 %inc, %6
  br i1 %cmp9, label %for.body, label %if.then27

if.else:                                          ; preds = %do.end
  %7 = load %struct._cl_platform_id** %arraydecay, align 4, !tbaa !1
  br i1 %cmp21, label %if.then27, label %if.end25

if.end25:                                         ; preds = %if.else, %cleanup
  %platform.2 = phi %struct._cl_platform_id* [ %5, %cleanup ], [ %7, %if.else ]
  %cmp26 = icmp eq %struct._cl_platform_id* %platform.2, null
  br i1 %cmp26, label %if.then27, label %if.end29

if.then27:                                        ; preds = %for.inc, %for.cond.preheader, %if.else, %if.end25
  %call28 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([32 x i8]* @.str10, i32 0, i32 0))
  br label %if.end221

if.end29:                                         ; preds = %if.end25
  %8 = getelementptr inbounds [256 x i8]* %platformName31, i32 0, i32 0
  call void @llvm.lifetime.start(i64 256, i8* %8) #2
  %call33 = call i32 @clGetPlatformInfo(%struct._cl_platform_id* %platform.2, i32 2306, i32 256, i8* %8, i32* null)
  store i32 %call33, i32* %err, align 4, !tbaa !10
  %cmp35 = icmp eq i32 %call33, 0
  br i1 %cmp35, label %do.end42, label %if.end38

if.end38:                                         ; preds = %if.end29
  %call37 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8]* @.str11, i32 0, i32 0), i32 %call33)
  %.pr288 = load i32* %err, align 4, !tbaa !10
  %cmp39 = icmp eq i32 %.pr288, 0
  br i1 %cmp39, label %do.end42, label %if.then40

if.then40:                                        ; preds = %if.end38
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end42

do.end42:                                         ; preds = %if.end29, %if.then40, %if.end38
  %call44 = call i64 @halide_current_time_ns(i8* %user_context)
  %call45 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str12, i32 0, i32 0), i8* %8, i64 %call44)
  %call46 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str13, i32 0, i32 0))
  %cmp47 = icmp eq i8* %call46, null
  br i1 %cmp47, label %if.end58, label %if.then48

if.then48:                                        ; preds = %do.end42
  %call49 = call i8* @strstr(i8* getelementptr inbounds ([4 x i8]* @.str14, i32 0, i32 0), i8* %call46)
  %tobool50 = icmp eq i8* %call49, null
  %.280 = select i1 %tobool50, i64 0, i64 2
  %call53 = call i8* @strstr(i8* getelementptr inbounds ([4 x i8]* @.str15, i32 0, i32 0), i8* %call46)
  %tobool54 = icmp eq i8* %call53, null
  %or56 = or i64 %.280, 4
  %.280.or56 = select i1 %tobool54, i64 %.280, i64 %or56
  br label %if.end58

if.end58:                                         ; preds = %if.then48, %do.end42
  %device_type.1 = phi i64 [ 0, %do.end42 ], [ %.280.or56, %if.then48 ]
  %cmp59 = icmp eq i64 %device_type.1, 0
  %.device_type.1 = select i1 %cmp59, i64 4294967295, i64 %device_type.1
  store i32 0, i32* %deviceCount, align 4, !tbaa !10
  %arraydecay62 = getelementptr inbounds [4 x %struct._cl_device_id*]* %devices, i32 0, i32 0
  %call63 = call i32 @clGetDeviceIDs(%struct._cl_platform_id* %platform.2, i64 %.device_type.1, i32 4, %struct._cl_device_id** %arraydecay62, i32* %deviceCount)
  store i32 %call63, i32* %err, align 4, !tbaa !10
  %cmp65 = icmp eq i32 %call63, 0
  br i1 %cmp65, label %do.end73, label %if.end68

if.end68:                                         ; preds = %if.end58
  %call67 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8]* @.str16, i32 0, i32 0), i32 %call63)
  %.pr290 = load i32* %err, align 4, !tbaa !10
  %cmp69 = icmp eq i32 %.pr290, 0
  br i1 %cmp69, label %do.end73, label %if.then70

if.then70:                                        ; preds = %if.end68
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end73

do.end73:                                         ; preds = %if.end58, %if.then70, %if.end68
  %9 = load i32* %deviceCount, align 4, !tbaa !10
  %cmp74 = icmp eq i32 %9, 0
  br i1 %cmp74, label %if.then75, label %if.end77

if.then75:                                        ; preds = %do.end73
  %call76 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str17, i32 0, i32 0))
  br label %cleanup121

if.end77:                                         ; preds = %do.end73
  %sub = add i32 %9, -1
  %arrayidx78 = getelementptr inbounds [4 x %struct._cl_device_id*]* %devices, i32 0, i32 %sub
  %10 = load %struct._cl_device_id** %arrayidx78, align 4, !tbaa !1
  store %struct._cl_device_id* %10, %struct._cl_device_id** %dev, align 4, !tbaa !1
  %11 = getelementptr inbounds [256 x i8]* %deviceName, i32 0, i32 0
  call void @llvm.lifetime.start(i64 256, i8* %11) #2
  %call80 = call i32 @clGetDeviceInfo(%struct._cl_device_id* %10, i32 4139, i32 256, i8* %11, i32* null)
  store i32 %call80, i32* %err, align 4, !tbaa !10
  %cmp82 = icmp eq i32 %call80, 0
  br i1 %cmp82, label %do.end90, label %if.end85

if.end85:                                         ; preds = %if.end77
  %call84 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8]* @.str18, i32 0, i32 0), i32 %call80)
  %.pr292 = load i32* %err, align 4, !tbaa !10
  %cmp86 = icmp eq i32 %.pr292, 0
  br i1 %cmp86, label %do.end90, label %if.then87

if.then87:                                        ; preds = %if.end85
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end90

do.end90:                                         ; preds = %if.end77, %if.then87, %if.end85
  %call92 = call i64 @halide_current_time_ns(i8* %user_context)
  %call93 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([51 x i8]* @.str19, i32 0, i32 0), i8* %11, i64 %call92)
  %arrayinit.begin = getelementptr inbounds [3 x i32]* %properties, i32 0, i32 0
  store i32 4228, i32* %arrayinit.begin, align 4, !tbaa !10
  %arrayinit.element = getelementptr inbounds [3 x i32]* %properties, i32 0, i32 1
  %12 = ptrtoint %struct._cl_platform_id* %platform.2 to i32
  store i32 %12, i32* %arrayinit.element, align 4, !tbaa !10
  %arrayinit.element94 = getelementptr inbounds [3 x i32]* %properties, i32 0, i32 2
  store i32 0, i32* %arrayinit.element94, align 4, !tbaa !10
  %call96 = call %struct._cl_context* @clCreateContext(i32* %arrayinit.begin, i32 1, %struct._cl_device_id** %dev, void (i8*, i8*, i32, i8*)* null, i8* null, i32* %err)
  %13 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  store %struct._cl_context* %call96, %struct._cl_context** %13, align 4, !tbaa !1
  %14 = load i32* %err, align 4, !tbaa !10
  %cmp98 = icmp eq i32 %14, 0
  br i1 %cmp98, label %do.end106, label %if.end101

if.end101:                                        ; preds = %do.end90
  %call100 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8]* @.str20, i32 0, i32 0), i32 %14)
  %.pr294 = load i32* %err, align 4, !tbaa !10
  %cmp102 = icmp eq i32 %.pr294, 0
  br i1 %cmp102, label %do.end106, label %if.then103

if.then103:                                       ; preds = %if.end101
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end106

do.end106:                                        ; preds = %do.end90, %if.then103, %if.end101
  %15 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %16 = load %struct._cl_command_queue** %15, align 4, !tbaa !1
  %tobool107 = icmp eq %struct._cl_command_queue* %16, null
  br i1 %tobool107, label %if.end109, label %if.then108

if.then108:                                       ; preds = %do.end106
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str21, i32 0, i32 0))
  br label %if.end109

if.end109:                                        ; preds = %do.end106, %if.then108
  %17 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %18 = load %struct._cl_context** %17, align 4, !tbaa !1
  %19 = load %struct._cl_device_id** %dev, align 4, !tbaa !1
  %call110 = call %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context* %18, %struct._cl_device_id* %19, i64 0, i32* %err)
  %20 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  store %struct._cl_command_queue* %call110, %struct._cl_command_queue** %20, align 4, !tbaa !1
  %21 = load i32* %err, align 4, !tbaa !10
  %cmp112 = icmp eq i32 %21, 0
  br i1 %cmp112, label %cleanup121, label %if.end115

if.end115:                                        ; preds = %if.end109
  %call114 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([21 x i8]* @.str22, i32 0, i32 0), i32 %21)
  %.pr296 = load i32* %err, align 4, !tbaa !10
  %cmp116 = icmp eq i32 %.pr296, 0
  br i1 %cmp116, label %cleanup121, label %if.then117

if.then117:                                       ; preds = %if.end115
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %cleanup121

cleanup121:                                       ; preds = %if.end109, %if.end115, %if.then117, %if.then75
  %cleanup.dest.slot.1 = phi i1 [ true, %if.then75 ], [ false, %if.then117 ], [ false, %if.end115 ], [ false, %if.end109 ]
  call void @llvm.lifetime.end(i64 256, i8* %8) #2
  %22 = load %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  %tobool163 = icmp ne %struct._cl_program* %22, null
  %or.cond = or i1 %cleanup.dest.slot.1, %tobool163
  %or.cond.not = xor i1 %or.cond, true
  %cmp164.old = icmp sgt i32 %size, 1
  %or.cond282 = and i1 %cmp164.old, %or.cond.not
  br i1 %or.cond282, label %if.then165, label %if.end221

if.else124:                                       ; preds = %entry
  %call125 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([24 x i8]* @.str23, i32 0, i32 0), %struct._cl_context* %1)
  %23 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %24 = load %struct._cl_context** %23, align 4, !tbaa !1
  %call128 = call i32 @clRetainContext(%struct._cl_context* %24)
  %cond = icmp eq i32 %call128, 0
  br i1 %cond, label %do.body138, label %if.then130

if.then130:                                       ; preds = %if.else124
  %call131 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8]* @.str24, i32 0, i32 0), i32 %call128)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.body138

do.body138:                                       ; preds = %if.else124, %if.then130
  %25 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %26 = load %struct._cl_command_queue** %25, align 4, !tbaa !1
  %call140 = call i32 @clRetainCommandQueue(%struct._cl_command_queue* %26)
  %cond283 = icmp eq i32 %call140, 0
  br i1 %cond283, label %do.body150, label %if.then142

if.then142:                                       ; preds = %do.body138
  %call143 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([21 x i8]* @.str25, i32 0, i32 0), i32 %call140)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.body150

do.body150:                                       ; preds = %do.body138, %if.then142
  %27 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %28 = load %struct._cl_context** %27, align 4, !tbaa !1
  %29 = bitcast %struct._cl_device_id** %dev to i8*
  %call152 = call i32 @clGetContextInfo(%struct._cl_context* %28, i32 4225, i32 4, i8* %29, i32* null)
  %cond284 = icmp eq i32 %call152, 0
  br i1 %cond284, label %if.end162, label %if.then154

if.then154:                                       ; preds = %do.body150
  %call155 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([17 x i8]* @.str26, i32 0, i32 0), i32 %call152)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %if.end162

if.end162:                                        ; preds = %do.body150, %if.then154
  %.old = load %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  %tobool163.old = icmp eq %struct._cl_program* %.old, null
  %cmp164 = icmp sgt i32 %size, 1
  %or.cond281 = and i1 %tobool163.old, %cmp164
  br i1 %or.cond281, label %if.then165, label %if.end221

if.then165:                                       ; preds = %cleanup121, %if.end162
  %arrayinit.begin167 = getelementptr inbounds [1 x %struct._cl_device_id*]* %devices166, i32 0, i32 0
  %30 = load %struct._cl_device_id** %dev, align 4, !tbaa !1
  store %struct._cl_device_id* %30, %struct._cl_device_id** %arrayinit.begin167, align 4, !tbaa !1
  %arrayinit.begin168 = getelementptr inbounds [1 x i32]* %lengths, i32 0, i32 0
  store i32 %size, i32* %arrayinit.begin168, align 4, !tbaa !10
  %call169 = call i8* @strstr(i8* %src, i8* getelementptr inbounds ([13 x i8]* @.str27, i32 0, i32 0))
  %tobool170 = icmp eq i8* %call169, null
  br i1 %tobool170, label %if.else186, label %if.then171

if.then171:                                       ; preds = %if.then165
  %call172 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([32 x i8]* @.str28, i32 0, i32 0), i8* %src)
  %arrayinit.begin173 = getelementptr inbounds [1 x i8*]* %sources, i32 0, i32 0
  store i8* %src, i8** %arrayinit.begin173, align 4, !tbaa !1
  %31 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %32 = load %struct._cl_context** %31, align 4, !tbaa !1
  %call175 = call %struct._cl_program* @clCreateProgramWithSource(%struct._cl_context* %32, i32 1, i8** %arrayinit.begin173, i32* null, i32* %err)
  store %struct._cl_program* %call175, %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  %33 = load i32* %err, align 4, !tbaa !10
  %cmp177 = icmp eq i32 %33, 0
  br i1 %cmp177, label %if.end203, label %if.end180

if.end180:                                        ; preds = %if.then171
  %call179 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8]* @.str29, i32 0, i32 0), i32 %33)
  %.pr298 = load i32* %err, align 4, !tbaa !10
  %cmp181 = icmp eq i32 %.pr298, 0
  br i1 %cmp181, label %if.end203, label %if.then182

if.then182:                                       ; preds = %if.end180
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %if.end203

if.else186:                                       ; preds = %if.then165
  %call187 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([34 x i8]* @.str30, i32 0, i32 0), i32 %size)
  %arrayinit.begin188 = getelementptr inbounds [1 x i8*]* %binaries, i32 0, i32 0
  store i8* %src, i8** %arrayinit.begin188, align 4, !tbaa !1
  %34 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %35 = load %struct._cl_context** %34, align 4, !tbaa !1
  %call192 = call %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context* %35, i32 1, %struct._cl_device_id** %arrayinit.begin167, i32* %arrayinit.begin168, i8** %arrayinit.begin188, i32* null, i32* %err)
  store %struct._cl_program* %call192, %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  %36 = load i32* %err, align 4, !tbaa !10
  %cmp194 = icmp eq i32 %36, 0
  br i1 %cmp194, label %if.end203, label %if.end197

if.end197:                                        ; preds = %if.else186
  %call196 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8]* @.str31, i32 0, i32 0), i32 %36)
  %.pr300 = load i32* %err, align 4, !tbaa !10
  %cmp198 = icmp eq i32 %.pr300, 0
  br i1 %cmp198, label %if.end203, label %if.then199

if.then199:                                       ; preds = %if.end197
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %if.end203

if.end203:                                        ; preds = %if.else186, %if.then171, %if.then199, %if.end197, %if.then182, %if.end180
  %37 = load %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  %call204 = call i32 @clBuildProgram(%struct._cl_program* %37, i32 1, %struct._cl_device_id** %dev, i8* null, void (%struct._cl_program*, i8*)* null, i8* null)
  store i32 %call204, i32* %err, align 4, !tbaa !10
  %cmp205 = icmp eq i32 %call204, 0
  br i1 %cmp205, label %if.end221, label %if.then206

if.then206:                                       ; preds = %if.end203
  %38 = getelementptr inbounds [2048 x i8]* %buffer, i32 0, i32 0
  call void @llvm.lifetime.start(i64 2048, i8* %38) #2
  %call207 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str32, i32 0, i32 0), i32 %call204)
  %39 = load %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  %40 = load %struct._cl_device_id** %dev, align 4, !tbaa !1
  %call209 = call i32 @clGetProgramBuildInfo(%struct._cl_program* %39, %struct._cl_device_id* %40, i32 4483, i32 2048, i8* %38, i32* %len)
  %cmp210 = icmp eq i32 %call209, 0
  br i1 %cmp210, label %if.then211, label %if.else214

if.then211:                                       ; preds = %if.then206
  %call213 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str33, i32 0, i32 0), i8* %38)
  br label %if.end216

if.else214:                                       ; preds = %if.then206
  %call215 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([48 x i8]* @.str34, i32 0, i32 0))
  br label %if.end216

if.end216:                                        ; preds = %if.else214, %if.then211
  %41 = load i32* %err, align 4, !tbaa !10
  %cmp217 = icmp eq i32 %41, 0
  br i1 %cmp217, label %if.end221, label %if.then218

if.then218:                                       ; preds = %if.end216
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %if.end221

if.end221:                                        ; preds = %if.end216, %if.then218, %cleanup121, %if.end162, %if.end203, %if.then27
  ret void
}

declare i32 @clGetPlatformIDs(i32, %struct._cl_platform_id**, i32*) #0

; Function Attrs: nounwind readonly
declare i8* @getenv(i8* nocapture) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #2

declare i32 @clGetPlatformInfo(%struct._cl_platform_id*, i32, i32, i8*, i32*) #0

; Function Attrs: nounwind readonly
declare i8* @strstr(i8*, i8* nocapture) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #2

declare i64 @halide_current_time_ns(i8*) #0

declare i32 @clGetDeviceIDs(%struct._cl_platform_id*, i64, i32, %struct._cl_device_id**, i32*) #0

declare i32 @clGetDeviceInfo(%struct._cl_device_id*, i32, i32, i8*, i32*) #0

declare %struct._cl_context* @clCreateContext(i32*, i32, %struct._cl_device_id**, void (i8*, i8*, i32, i8*)*, i8*, i32*) #0

declare %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context*, %struct._cl_device_id*, i64, i32*) #0

declare i32 @clRetainContext(%struct._cl_context*) #0

declare i32 @clRetainCommandQueue(%struct._cl_command_queue*) #0

declare i32 @clGetContextInfo(%struct._cl_context*, i32, i32, i8*, i32*) #0

declare %struct._cl_program* @clCreateProgramWithSource(%struct._cl_context*, i32, i8**, i32*, i32*) #0

declare %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context*, i32, %struct._cl_device_id**, i32*, i8**, i32*, i32*) #0

declare i32 @clBuildProgram(%struct._cl_program*, i32, %struct._cl_device_id**, i8*, void (%struct._cl_program*, i8*)*, i8*) #0

declare i32 @clGetProgramBuildInfo(%struct._cl_program*, %struct._cl_device_id*, i32, i32, i8*, i32*) #0

define weak void @halide_dev_sync(i8* %user_context) #0 {
entry:
  %0 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %1 = load %struct._cl_command_queue** %0, align 4, !tbaa !1
  %call = tail call i32 @clFinish(%struct._cl_command_queue* %1)
  ret void
}

declare i32 @clFinish(%struct._cl_command_queue*) #0

define weak void @halide_release(i8* %user_context) #0 {
entry:
  %refs = alloca i32, align 4
  %call = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str35, i32 0, i32 0))
  call void @halide_dev_sync(i8* %user_context)
  %0 = load %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  %tobool = icmp eq %struct._cl_program* %0, null
  br i1 %tobool, label %if.end8, label %if.then

if.then:                                          ; preds = %entry
  %call1 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([21 x i8]* @.str36, i32 0, i32 0), %struct._cl_program* %0)
  %1 = load %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  %call2 = call i32 @clReleaseProgram(%struct._cl_program* %1)
  %cond = icmp eq i32 %call2, 0
  br i1 %cond, label %do.end, label %if.then3

if.then3:                                         ; preds = %if.then
  %call4 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([17 x i8]* @.str37, i32 0, i32 0), i32 %call2)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end

do.end:                                           ; preds = %if.then, %if.then3
  store %struct._cl_program* null, %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  br label %if.end8

if.end8:                                          ; preds = %entry, %do.end
  store i32 0, i32* %refs, align 4, !tbaa !10
  %2 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %3 = load %struct._cl_context** %2, align 4, !tbaa !1
  %4 = bitcast i32* %refs to i8*
  %call9 = call i32 @clGetContextInfo(%struct._cl_context* %3, i32 4224, i32 4, i8* %4, i32* null)
  %5 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %6 = load %struct._cl_command_queue** %5, align 4, !tbaa !1
  %call12 = call i32 @clReleaseCommandQueue(%struct._cl_command_queue* %6)
  %cond51 = icmp eq i32 %call12, 0
  br i1 %cond51, label %do.end20, label %if.then14

if.then14:                                        ; preds = %if.end8
  %call15 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([22 x i8]* @.str38, i32 0, i32 0), i32 %call12)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end20

do.end20:                                         ; preds = %if.end8, %if.then14
  %7 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %8 = load %struct._cl_context** %7, align 4, !tbaa !1
  %call21 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([21 x i8]* @.str39, i32 0, i32 0), %struct._cl_context* %8)
  %9 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %10 = load %struct._cl_context** %9, align 4, !tbaa !1
  %call24 = call i32 @clReleaseContext(%struct._cl_context* %10)
  %cond52 = icmp eq i32 %call24, 0
  br i1 %cond52, label %do.end32, label %if.then26

if.then26:                                        ; preds = %do.end20
  %call27 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([17 x i8]* @.str40, i32 0, i32 0), i32 %call24)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end32

do.end32:                                         ; preds = %do.end20, %if.then26
  %11 = load i32* %refs, align 4, !tbaa !10
  %dec = add i32 %11, -1
  store i32 %dec, i32* %refs, align 4, !tbaa !10
  %cmp33 = icmp eq i32 %dec, 0
  br i1 %cmp33, label %if.then34, label %if.end35

if.then34:                                        ; preds = %do.end32
  %12 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  store %struct._cl_context* null, %struct._cl_context** %12, align 4, !tbaa !1
  %13 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  store %struct._cl_command_queue* null, %struct._cl_command_queue** %13, align 4, !tbaa !1
  br label %if.end35

if.end35:                                         ; preds = %if.then34, %do.end32
  ret void
}

declare i32 @clReleaseProgram(%struct._cl_program*) #0

declare i32 @clReleaseCommandQueue(%struct._cl_command_queue*) #0

declare i32 @clReleaseContext(%struct._cl_context*) #0

define weak void @halide_dev_malloc(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %err.i = alloca i32, align 4
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %0 = load i64* %dev, align 4, !tbaa !5
  %tobool = icmp eq i64 %0, 0
  br i1 %tobool, label %if.end2, label %if.then

if.then:                                          ; preds = %entry
  %call = call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i32 0)
  br i1 %call, label %if.end34, label %if.then1

if.then1:                                         ; preds = %if.then
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str4, i32 0, i32 0))
  br label %if.end34

if.end2:                                          ; preds = %entry
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 5
  %1 = load i32* %elem_size.i, align 4, !tbaa !11
  %arrayidx.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 0
  %2 = load i32* %arrayidx.i, align 4, !tbaa !10
  %mul.i = mul nsw i32 %2, %1
  %arrayidx1.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 0
  %3 = load i32* %arrayidx1.i, align 4, !tbaa !10
  %mul2.i = mul nsw i32 %mul.i, %3
  %arrayidx.1.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 1
  %4 = load i32* %arrayidx.1.i, align 4, !tbaa !10
  %mul.1.i = mul nsw i32 %4, %1
  %arrayidx1.1.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 1
  %5 = load i32* %arrayidx1.1.i, align 4, !tbaa !10
  %mul2.1.i = mul nsw i32 %mul.1.i, %5
  %cmp3.1.i = icmp ugt i32 %mul2.1.i, %mul2.i
  %mul2.size.0.1.i = select i1 %cmp3.1.i, i32 %mul2.1.i, i32 %mul2.i
  %arrayidx.2.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 2
  %6 = load i32* %arrayidx.2.i, align 4, !tbaa !10
  %mul.2.i = mul nsw i32 %6, %1
  %arrayidx1.2.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 2
  %7 = load i32* %arrayidx1.2.i, align 4, !tbaa !10
  %mul2.2.i = mul nsw i32 %mul.2.i, %7
  %cmp3.2.i = icmp ugt i32 %mul2.2.i, %mul2.size.0.1.i
  %mul2.size.0.2.i = select i1 %cmp3.2.i, i32 %mul2.2.i, i32 %mul2.size.0.1.i
  %arrayidx.3.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 3
  %8 = load i32* %arrayidx.3.i, align 4, !tbaa !10
  %mul.3.i = mul nsw i32 %8, %1
  %arrayidx1.3.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 3
  %9 = load i32* %arrayidx1.3.i, align 4, !tbaa !10
  %mul2.3.i = mul nsw i32 %mul.3.i, %9
  %cmp3.3.i = icmp ugt i32 %mul2.3.i, %mul2.size.0.2.i
  %mul2.size.0.3.i = select i1 %cmp3.3.i, i32 %mul2.3.i, i32 %mul2.size.0.2.i
  %tobool.i = icmp eq i32 %mul2.size.0.3.i, 0
  br i1 %tobool.i, label %if.then4.i, label %_Z10__buf_sizePvP8buffer_t.exit

if.then4.i:                                       ; preds = %if.end2
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str59, i32 0, i32 0))
  %.pre = load i32* %arrayidx.i, align 4, !tbaa !10
  %.pre56 = load i32* %arrayidx.1.i, align 4, !tbaa !10
  %.pre57 = load i32* %arrayidx.2.i, align 4, !tbaa !10
  %.pre58 = load i32* %arrayidx.3.i, align 4, !tbaa !10
  %.pre59 = load i32* %arrayidx1.i, align 4, !tbaa !10
  %.pre60 = load i32* %arrayidx1.1.i, align 4, !tbaa !10
  %.pre61 = load i32* %arrayidx1.2.i, align 4, !tbaa !10
  %.pre62 = load i32* %arrayidx1.3.i, align 4, !tbaa !10
  %.pre63 = load i32* %elem_size.i, align 4, !tbaa !11
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end2, %if.then4.i
  %10 = phi i32 [ %1, %if.end2 ], [ %.pre63, %if.then4.i ]
  %11 = phi i32 [ %9, %if.end2 ], [ %.pre62, %if.then4.i ]
  %12 = phi i32 [ %7, %if.end2 ], [ %.pre61, %if.then4.i ]
  %13 = phi i32 [ %5, %if.end2 ], [ %.pre60, %if.then4.i ]
  %14 = phi i32 [ %3, %if.end2 ], [ %.pre59, %if.then4.i ]
  %15 = phi i32 [ %8, %if.end2 ], [ %.pre58, %if.then4.i ]
  %16 = phi i32 [ %6, %if.end2 ], [ %.pre57, %if.then4.i ]
  %17 = phi i32 [ %4, %if.end2 ], [ %.pre56, %if.then4.i ]
  %18 = phi i32 [ %2, %if.end2 ], [ %.pre, %if.then4.i ]
  %conv = zext i32 %mul2.size.0.3.i to i64
  %conv4 = sext i32 %18 to i64
  %conv7 = sext i32 %17 to i64
  %conv10 = sext i32 %16 to i64
  %conv13 = sext i32 %15 to i64
  %conv15 = sext i32 %14 to i64
  %conv18 = sext i32 %13 to i64
  %conv21 = sext i32 %12 to i64
  %conv24 = sext i32 %11 to i64
  %call25 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([126 x i8]* @.str41, i32 0, i32 0), i64 %conv, i64 %conv4, i64 %conv7, i64 %conv10, i64 %conv13, i64 %conv15, i64 %conv18, i64 %conv21, i64 %conv24, i32 %10)
  %19 = bitcast i32* %err.i to i8*
  call void @llvm.lifetime.start(i64 4, i8* %19)
  %call.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([25 x i8]* @.str56, i32 0, i32 0), i64 %conv)
  %20 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %21 = load %struct._cl_context** %20, align 4, !tbaa !1
  %call1.i = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %21, i64 1, i32 %mul2.size.0.3.i, i8* null, i32* %err.i)
  %22 = load i32* %err.i, align 4, !tbaa !10
  %call2.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([28 x i8]* @.str57, i32 0, i32 0), %struct._cl_mem* %call1.i, i32 %22)
  %tobool.i55 = icmp eq %struct._cl_mem* %call1.i, null
  br i1 %tobool.i55, label %if.then.i, label %_Z12__dev_mallocPvj.exit

if.then.i:                                        ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([2 x i8]* @.str58, i32 0, i32 0))
  br label %_Z12__dev_mallocPvj.exit

_Z12__dev_mallocPvj.exit:                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit, %if.then.i
  call void @llvm.lifetime.end(i64 4, i8* %19)
  %23 = ptrtoint %struct._cl_mem* %call1.i to i32
  %24 = zext i32 %23 to i64
  store i64 %24, i64* %dev, align 4, !tbaa !5
  %call30 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([55 x i8]* @.str42, i32 0, i32 0), %struct.buffer_t* %buf, %struct._cl_mem* %call1.i)
  %25 = load i64* %dev, align 4, !tbaa !5
  %tobool32 = icmp eq i64 %25, 0
  br i1 %tobool32, label %if.then33, label %if.end34

if.then33:                                        ; preds = %_Z12__dev_mallocPvj.exit
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str43, i32 0, i32 0))
  br label %if.end34

if.end34:                                         ; preds = %_Z12__dev_mallocPvj.exit, %if.then, %if.then1, %if.then33
  ret void
}

define weak void @halide_copy_to_dev(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %host_dirty = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 6
  %0 = load i8* %host_dirty, align 1, !tbaa !12, !range !13
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end21, label %if.then

if.then:                                          ; preds = %entry
  %host = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 1
  %1 = load i8** %host, align 4, !tbaa !14
  %tobool1 = icmp eq i8* %1, null
  br i1 %tobool1, label %if.then3, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.then
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %2 = load i64* %dev, align 4, !tbaa !5
  %tobool2 = icmp eq i64 %2, 0
  br i1 %tobool2, label %if.then3, label %if.end

if.then3:                                         ; preds = %land.lhs.true, %if.then
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str44, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then3
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 5
  %3 = load i32* %elem_size.i, align 4, !tbaa !11
  %arrayidx.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 0
  %4 = load i32* %arrayidx.i, align 4, !tbaa !10
  %mul.i = mul nsw i32 %4, %3
  %arrayidx1.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 0
  %5 = load i32* %arrayidx1.i, align 4, !tbaa !10
  %mul2.i = mul nsw i32 %mul.i, %5
  %arrayidx.1.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 1
  %6 = load i32* %arrayidx.1.i, align 4, !tbaa !10
  %mul.1.i = mul nsw i32 %6, %3
  %arrayidx1.1.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 1
  %7 = load i32* %arrayidx1.1.i, align 4, !tbaa !10
  %mul2.1.i = mul nsw i32 %mul.1.i, %7
  %cmp3.1.i = icmp ugt i32 %mul2.1.i, %mul2.i
  %mul2.size.0.1.i = select i1 %cmp3.1.i, i32 %mul2.1.i, i32 %mul2.i
  %arrayidx.2.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 2
  %8 = load i32* %arrayidx.2.i, align 4, !tbaa !10
  %mul.2.i = mul nsw i32 %8, %3
  %arrayidx1.2.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 2
  %9 = load i32* %arrayidx1.2.i, align 4, !tbaa !10
  %mul2.2.i = mul nsw i32 %mul.2.i, %9
  %cmp3.2.i = icmp ugt i32 %mul2.2.i, %mul2.size.0.1.i
  %mul2.size.0.2.i = select i1 %cmp3.2.i, i32 %mul2.2.i, i32 %mul2.size.0.1.i
  %arrayidx.3.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 3
  %10 = load i32* %arrayidx.3.i, align 4, !tbaa !10
  %mul.3.i = mul nsw i32 %10, %3
  %arrayidx1.3.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 3
  %11 = load i32* %arrayidx1.3.i, align 4, !tbaa !10
  %mul2.3.i = mul nsw i32 %mul.3.i, %11
  %cmp3.3.i = icmp ugt i32 %mul2.3.i, %mul2.size.0.2.i
  %mul2.size.0.3.i = select i1 %cmp3.3.i, i32 %mul2.3.i, i32 %mul2.size.0.2.i
  %tobool.i = icmp eq i32 %mul2.size.0.3.i, 0
  br i1 %tobool.i, label %if.then4.i, label %_Z10__buf_sizePvP8buffer_t.exit

if.then4.i:                                       ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str59, i32 0, i32 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then4.i
  %conv = zext i32 %mul2.size.0.3.i to i64
  %12 = load i8** %host, align 4, !tbaa !14
  %dev5 = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %13 = load i64* %dev5, align 4, !tbaa !5
  %conv6 = trunc i64 %13 to i32
  %14 = inttoptr i32 %conv6 to i8*
  %call7 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([35 x i8]* @.str45, i32 0, i32 0), i64 %conv, i8* %12, i8* %14)
  %call8 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i32 0)
  br i1 %call8, label %if.end10, label %if.then9

if.then9:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str4, i32 0, i32 0))
  br label %if.end10

if.end10:                                         ; preds = %if.then9, %_Z10__buf_sizePvP8buffer_t.exit
  %15 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %16 = load %struct._cl_command_queue** %15, align 4, !tbaa !1
  %17 = load i64* %dev5, align 4, !tbaa !5
  %conv12 = trunc i64 %17 to i32
  %18 = inttoptr i32 %conv12 to %struct._cl_mem*
  %19 = load i8** %host, align 4, !tbaa !14
  %call14 = tail call i32 @clEnqueueWriteBuffer(%struct._cl_command_queue* %16, %struct._cl_mem* %18, i32 1, i32 0, i32 %mul2.size.0.3.i, i8* %19, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  %cond = icmp eq i32 %call14, 0
  br i1 %cond, label %if.end21, label %if.then15

if.then15:                                        ; preds = %if.end10
  %call16 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([21 x i8]* @.str46, i32 0, i32 0), i32 %call14)
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %if.end21

if.end21:                                         ; preds = %if.end10, %entry, %if.then15
  store i8 0, i8* %host_dirty, align 1, !tbaa !12
  ret void
}

declare i32 @clEnqueueWriteBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i32, i32, i8*, i32, %struct._cl_event**, %struct._cl_event**) #0

define weak void @halide_copy_to_host(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %dev_dirty = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 7
  %0 = load i8* %dev_dirty, align 1, !tbaa !15, !range !13
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end22, label %if.then

if.then:                                          ; preds = %entry
  %1 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %2 = load %struct._cl_command_queue** %1, align 4, !tbaa !1
  %call = tail call i32 @clFinish(%struct._cl_command_queue* %2)
  %host = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 1
  %3 = load i8** %host, align 4, !tbaa !14
  %tobool1 = icmp eq i8* %3, null
  br i1 %tobool1, label %if.then3, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.then
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %4 = load i64* %dev, align 4, !tbaa !5
  %tobool2 = icmp eq i64 %4, 0
  br i1 %tobool2, label %if.then3, label %if.end

if.then3:                                         ; preds = %land.lhs.true, %if.then
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str44, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then3
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 5
  %5 = load i32* %elem_size.i, align 4, !tbaa !11
  %arrayidx.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 0
  %6 = load i32* %arrayidx.i, align 4, !tbaa !10
  %mul.i = mul nsw i32 %6, %5
  %arrayidx1.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 0
  %7 = load i32* %arrayidx1.i, align 4, !tbaa !10
  %mul2.i = mul nsw i32 %mul.i, %7
  %arrayidx.1.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 1
  %8 = load i32* %arrayidx.1.i, align 4, !tbaa !10
  %mul.1.i = mul nsw i32 %8, %5
  %arrayidx1.1.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 1
  %9 = load i32* %arrayidx1.1.i, align 4, !tbaa !10
  %mul2.1.i = mul nsw i32 %mul.1.i, %9
  %cmp3.1.i = icmp ugt i32 %mul2.1.i, %mul2.i
  %mul2.size.0.1.i = select i1 %cmp3.1.i, i32 %mul2.1.i, i32 %mul2.i
  %arrayidx.2.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 2
  %10 = load i32* %arrayidx.2.i, align 4, !tbaa !10
  %mul.2.i = mul nsw i32 %10, %5
  %arrayidx1.2.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 2
  %11 = load i32* %arrayidx1.2.i, align 4, !tbaa !10
  %mul2.2.i = mul nsw i32 %mul.2.i, %11
  %cmp3.2.i = icmp ugt i32 %mul2.2.i, %mul2.size.0.1.i
  %mul2.size.0.2.i = select i1 %cmp3.2.i, i32 %mul2.2.i, i32 %mul2.size.0.1.i
  %arrayidx.3.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 2, i32 3
  %12 = load i32* %arrayidx.3.i, align 4, !tbaa !10
  %mul.3.i = mul nsw i32 %12, %5
  %arrayidx1.3.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 3, i32 3
  %13 = load i32* %arrayidx1.3.i, align 4, !tbaa !10
  %mul2.3.i = mul nsw i32 %mul.3.i, %13
  %cmp3.3.i = icmp ugt i32 %mul2.3.i, %mul2.size.0.2.i
  %mul2.size.0.3.i = select i1 %cmp3.3.i, i32 %mul2.3.i, i32 %mul2.size.0.2.i
  %tobool.i = icmp eq i32 %mul2.size.0.3.i, 0
  br i1 %tobool.i, label %if.then4.i, label %_Z10__buf_sizePvP8buffer_t.exit

if.then4.i:                                       ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str59, i32 0, i32 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then4.i
  %conv = zext i32 %mul2.size.0.3.i to i64
  %dev5 = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %14 = load i64* %dev5, align 4, !tbaa !5
  %conv6 = trunc i64 %14 to i32
  %15 = inttoptr i32 %conv6 to i8*
  %16 = load i8** %host, align 4, !tbaa !14
  %call8 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([43 x i8]* @.str47, i32 0, i32 0), %struct.buffer_t* %buf, i64 %conv, i8* %15, i8* %16)
  %call9 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i32 %mul2.size.0.3.i)
  br i1 %call9, label %if.end11, label %if.then10

if.then10:                                        ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str48, i32 0, i32 0))
  br label %if.end11

if.end11:                                         ; preds = %if.then10, %_Z10__buf_sizePvP8buffer_t.exit
  %17 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %18 = load %struct._cl_command_queue** %17, align 4, !tbaa !1
  %19 = load i64* %dev5, align 4, !tbaa !5
  %conv13 = trunc i64 %19 to i32
  %20 = inttoptr i32 %conv13 to %struct._cl_mem*
  %21 = load i8** %host, align 4, !tbaa !14
  %call15 = tail call i32 @clEnqueueReadBuffer(%struct._cl_command_queue* %18, %struct._cl_mem* %20, i32 1, i32 0, i32 %mul2.size.0.3.i, i8* %21, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  %cond = icmp eq i32 %call15, 0
  br i1 %cond, label %if.end22, label %if.then16

if.then16:                                        ; preds = %if.end11
  %call17 = tail call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([20 x i8]* @.str49, i32 0, i32 0), i32 %call15)
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %if.end22

if.end22:                                         ; preds = %if.end11, %entry, %if.then16
  store i8 0, i8* %dev_dirty, align 1, !tbaa !15
  ret void
}

declare i32 @clEnqueueReadBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i32, i32, i8*, i32, %struct._cl_event**, %struct._cl_event**) #0

define weak void @halide_dev_run(i8* %user_context, i8* %entry_name, i32 %blocksX, i32 %blocksY, i32 %blocksZ, i32 %threadsX, i32 %threadsY, i32 %threadsZ, i32 %shared_mem_bytes, i32* %arg_sizes, i8** %args) #0 {
entry:
  %err.i = alloca i32, align 4
  %global_dim = alloca [3 x i32], align 4
  %local_dim = alloca [3 x i32], align 4
  %0 = bitcast i32* %err.i to i8*
  call void @llvm.lifetime.start(i64 4, i8* %0)
  %call.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([15 x i8]* @.str54, i32 0, i32 0), i8* %entry_name)
  %1 = load %struct._cl_program** @_Z5__mod, align 4, !tbaa !1
  %call1.i = call %struct._cl_kernel* @clCreateKernel(%struct._cl_program* %1, i8* %entry_name, i32* %err.i)
  %2 = load i32* %err.i, align 4, !tbaa !10
  %cmp.i = icmp eq i32 %2, 0
  br i1 %cmp.i, label %_Z12__get_kernelPvPKc.exit, label %if.end.i

if.end.i:                                         ; preds = %entry
  %call2.i = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8]* @.str55, i32 0, i32 0), i32 %2)
  %.pr.i = load i32* %err.i, align 4, !tbaa !10
  %cmp3.i = icmp eq i32 %.pr.i, 0
  br i1 %cmp3.i, label %_Z12__get_kernelPvPKc.exit, label %if.then4.i

if.then4.i:                                       ; preds = %if.end.i
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %_Z12__get_kernelPvPKc.exit

_Z12__get_kernelPvPKc.exit:                       ; preds = %entry, %if.end.i, %if.then4.i
  call void @llvm.lifetime.end(i64 4, i8* %0)
  %call1 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([63 x i8]* @.str50, i32 0, i32 0), i8* %entry_name, i32 %blocksX, i32 %blocksY, i32 %blocksZ, i32 %threadsX, i32 %threadsY, i32 %threadsZ, i32 %shared_mem_bytes)
  %arrayinit.begin = getelementptr inbounds [3 x i32]* %global_dim, i32 0, i32 0
  %mul = mul nsw i32 %threadsX, %blocksX
  store i32 %mul, i32* %arrayinit.begin, align 4, !tbaa !10
  %arrayinit.element = getelementptr inbounds [3 x i32]* %global_dim, i32 0, i32 1
  %mul2 = mul nsw i32 %threadsY, %blocksY
  store i32 %mul2, i32* %arrayinit.element, align 4, !tbaa !10
  %arrayinit.element3 = getelementptr inbounds [3 x i32]* %global_dim, i32 0, i32 2
  %mul4 = mul nsw i32 %threadsZ, %blocksZ
  store i32 %mul4, i32* %arrayinit.element3, align 4, !tbaa !10
  %arrayinit.begin5 = getelementptr inbounds [3 x i32]* %local_dim, i32 0, i32 0
  store i32 %threadsX, i32* %arrayinit.begin5, align 4, !tbaa !10
  %arrayinit.element6 = getelementptr inbounds [3 x i32]* %local_dim, i32 0, i32 1
  store i32 %threadsY, i32* %arrayinit.element6, align 4, !tbaa !10
  %arrayinit.element7 = getelementptr inbounds [3 x i32]* %local_dim, i32 0, i32 2
  store i32 %threadsZ, i32* %arrayinit.element7, align 4, !tbaa !10
  %3 = load i32* %arg_sizes, align 4, !tbaa !10
  %cmp85 = icmp eq i32 %3, 0
  br i1 %cmp85, label %do.body19, label %while.body

while.body:                                       ; preds = %_Z12__get_kernelPvPKc.exit, %do.end
  %4 = phi i32 [ %10, %do.end ], [ %3, %_Z12__get_kernelPvPKc.exit ]
  %arrayidx87 = phi i32* [ %arrayidx, %do.end ], [ %arg_sizes, %_Z12__get_kernelPvPKc.exit ]
  %i.086 = phi i32 [ %inc, %do.end ], [ 0, %_Z12__get_kernelPvPKc.exit ]
  %arrayidx9 = getelementptr inbounds i8** %args, i32 %i.086
  %5 = load i8** %arrayidx9, align 4, !tbaa !1
  %6 = bitcast i8* %5 to i32*
  %7 = load i32* %6, align 4, !tbaa !10
  %call10 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str51, i32 0, i32 0), i32 %i.086, i32 %4, i32 %7)
  %8 = load i32* %arrayidx87, align 4, !tbaa !10
  %9 = load i8** %arrayidx9, align 4, !tbaa !1
  %call13 = call i32 @clSetKernelArg(%struct._cl_kernel* %call1.i, i32 %i.086, i32 %8, i8* %9)
  %cond82 = icmp eq i32 %call13, 0
  br i1 %cond82, label %do.end, label %if.then

if.then:                                          ; preds = %while.body
  %call15 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8]* @.str52, i32 0, i32 0), i32 %call13)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end

do.end:                                           ; preds = %while.body, %if.then
  %inc = add nsw i32 %i.086, 1
  %arrayidx = getelementptr inbounds i32* %arg_sizes, i32 %inc
  %10 = load i32* %arrayidx, align 4, !tbaa !10
  %cmp = icmp eq i32 %10, 0
  br i1 %cmp, label %do.body19, label %while.body

do.body19:                                        ; preds = %do.end, %_Z12__get_kernelPvPKc.exit
  %i.0.lcssa = phi i32 [ 0, %_Z12__get_kernelPvPKc.exit ], [ %inc, %do.end ]
  %cmp21 = icmp slt i32 %shared_mem_bytes, 1
  %cond = select i1 %cmp21, i32 1, i32 %shared_mem_bytes
  %call22 = call i32 @clSetKernelArg(%struct._cl_kernel* %call1.i, i32 %i.0.lcssa, i32 %cond, i8* null)
  %cond83 = icmp eq i32 %call22, 0
  br i1 %cond83, label %do.end30, label %if.then24

if.then24:                                        ; preds = %do.body19
  %call25 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8]* @.str52, i32 0, i32 0), i32 %call22)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end30

do.end30:                                         ; preds = %do.body19, %if.then24
  %11 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %12 = load %struct._cl_command_queue** %11, align 4, !tbaa !1
  %call33 = call i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue* %12, %struct._cl_kernel* %call1.i, i32 3, i32* null, i32* %arrayinit.begin, i32* %arrayinit.begin5, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  %cond84 = icmp eq i32 %call33, 0
  br i1 %cond84, label %do.end42, label %if.then36

if.then36:                                        ; preds = %do.end30
  %call37 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([33 x i8]* @.str5, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8]* @.str53, i32 0, i32 0), i32 %call33)
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str7, i32 0, i32 0))
  br label %do.end42

do.end42:                                         ; preds = %do.end30, %if.then36
  ret void
}

declare i32 @clSetKernelArg(%struct._cl_kernel*, i32, i32, i8*) #0

declare i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue*, %struct._cl_kernel*, i32, i32*, i32*, i32*, i32, %struct._cl_event**, %struct._cl_event**) #0

declare %struct._cl_kernel* @clCreateKernel(%struct._cl_program*, i8*, i32*) #0

declare %struct._cl_mem* @clCreateBuffer(%struct._cl_context*, i64, i32, i8*, i32*) #0

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !7, i64 0}
!6 = metadata !{metadata !"_ZTS8buffer_t", metadata !7, i64 0, metadata !2, i64 8, metadata !3, i64 12, metadata !3, i64 28, metadata !3, i64 44, metadata !8, i64 60, metadata !9, i64 64, metadata !9, i64 65}
!7 = metadata !{metadata !"long long", metadata !3, i64 0}
!8 = metadata !{metadata !"int", metadata !3, i64 0}
!9 = metadata !{metadata !"bool", metadata !3, i64 0}
!10 = metadata !{metadata !8, metadata !8, i64 0}
!11 = metadata !{metadata !6, metadata !8, i64 60}
!12 = metadata !{metadata !6, metadata !9, i64 64}
!13 = metadata !{i8 0, i8 2}
!14 = metadata !{metadata !6, metadata !2, i64 8}
!15 = metadata !{metadata !6, metadata !9, i64 65}
