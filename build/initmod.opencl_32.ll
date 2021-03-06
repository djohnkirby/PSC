; ModuleID = 'src/runtime/opencl.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%struct._cl_context = type opaque
%struct._cl_command_queue = type opaque
%struct._module_state_ = type { %struct._cl_program*, %struct._module_state_* }
%struct._cl_program = type opaque
%struct.buffer_t = type { i64, i8*, [4 x i32], [4 x i32], [4 x i32], i32, i8, i8 }
%struct._cl_mem = type opaque
%struct._cl_device_id = type opaque
%struct._cl_platform_id = type opaque
%struct._cl_event = type opaque
%struct._cl_kernel = type opaque

@weak_cl_ctx = weak global %struct._cl_context* null, align 4
@weak_cl_q = weak global %struct._cl_command_queue* null, align 4
@state_list = weak global %struct._module_state_* null, align 4
@_Z6cl_ctx = internal unnamed_addr global %struct._cl_context** @weak_cl_ctx, align 4
@_Z4cl_q = internal unnamed_addr global %struct._cl_command_queue** @weak_cl_q, align 4
@.str = private unnamed_addr constant [55 x i8] c"Bad device pointer %p: clGetMemObjectInfo returned %d\0A\00", align 1
@.str1 = private unnamed_addr constant [65 x i8] c"real_size >= size && \22Validating pointer with insufficient size\22\00", align 1
@.str2 = private unnamed_addr constant [47 x i8] c"halide_validate_dev_pointer(user_context, buf)\00", align 1
@.str3 = private unnamed_addr constant [16 x i8] c"HL_OCL_PLATFORM\00", align 1
@.str4 = private unnamed_addr constant [32 x i8] c"Failed to find OpenCL platform\0A\00", align 1
@.str5 = private unnamed_addr constant [14 x i8] c"HL_OCL_DEVICE\00", align 1
@.str6 = private unnamed_addr constant [4 x i8] c"cpu\00", align 1
@.str7 = private unnamed_addr constant [4 x i8] c"gpu\00", align 1
@.str8 = private unnamed_addr constant [22 x i8] c"Failed to get device\0A\00", align 1
@.str9 = private unnamed_addr constant [9 x i8] c"!(*cl_q)\00", align 1
@.str10 = private unnamed_addr constant [13 x i8] c"/*OpenCL C*/\00", align 1
@.str11 = private unnamed_addr constant [53 x i8] c"Error: Failed to build program executable! err = %d\0A\00", align 1
@.str12 = private unnamed_addr constant [22 x i8] c"Build Log:\0A %s\0A-----\0A\00", align 1
@.str13 = private unnamed_addr constant [48 x i8] c"clGetProgramBuildInfo failed to get build log!\0A\00", align 1
@.str14 = private unnamed_addr constant [18 x i8] c"err == CL_SUCCESS\00", align 1
@.str15 = private unnamed_addr constant [9 x i8] c"buf->dev\00", align 1
@.str16 = private unnamed_addr constant [22 x i8] c"buf->host && buf->dev\00", align 1
@.str17 = private unnamed_addr constant [53 x i8] c"halide_validate_dev_pointer(user_context, buf, size)\00", align 1
@.str18 = private unnamed_addr constant [10 x i8] c"state_ptr\00", align 1
@.str19 = private unnamed_addr constant [8 x i8] c"program\00", align 1
@.str20 = private unnamed_addr constant [2 x i8] c"p\00", align 1
@.str21 = private unnamed_addr constant [5 x i8] c"size\00", align 1

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
  br i1 %tobool, label %if.end6, label %if.then2

if.then2:                                         ; preds = %if.end
  %3 = load i64* %dev, align 4, !tbaa !5
  %conv4 = trunc i64 %3 to i32
  %4 = inttoptr i32 %conv4 to i8*
  %call5 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([55 x i8]* @.str, i32 0, i32 0), i8* %4, i32 %call)
  br label %return

if.end6:                                          ; preds = %if.end
  %tobool7 = icmp eq i32 %size, 0
  br i1 %tobool7, label %return, label %if.then8

if.then8:                                         ; preds = %if.end6
  %5 = load i32* %real_size, align 4, !tbaa !10
  %cmp9 = icmp ult i32 %5, %size
  br i1 %cmp9, label %if.then10, label %return

if.then10:                                        ; preds = %if.then8
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([65 x i8]* @.str1, i32 0, i32 0))
  br label %return

return:                                           ; preds = %if.then10, %if.end6, %if.then8, %entry, %if.then2
  %retval.0 = phi i1 [ false, %if.then2 ], [ true, %entry ], [ true, %if.then8 ], [ true, %if.end6 ], [ true, %if.then10 ]
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
  %call = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i32 0)
  br i1 %call, label %if.end2, label %if.then1

if.then1:                                         ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i32 0, i32 0))
  br label %if.end2

if.end2:                                          ; preds = %if.then1, %if.end
  %1 = load i64* %dev, align 4, !tbaa !5
  %conv = trunc i64 %1 to i32
  %2 = inttoptr i32 %conv to %struct._cl_mem*
  %call4 = tail call i32 @clReleaseMemObject(%struct._cl_mem* %2)
  store i64 0, i64* %dev, align 4, !tbaa !5
  br label %return

return:                                           ; preds = %entry, %if.end2
  ret void
}

declare i32 @clReleaseMemObject(%struct._cl_mem*) #0

define weak i8* @halide_init_kernels(i8* %user_context, i8* %state_ptr, i8* %src, i32 %size) #0 {
entry:
  %err = alloca i32, align 4
  %dev = alloca %struct._cl_device_id*, align 4
  %platforms = alloca [4 x %struct._cl_platform_id*], align 4
  %platformCount = alloca i32, align 4
  %platformName = alloca [256 x i8], align 1
  %devices = alloca [4 x %struct._cl_device_id*], align 4
  %deviceCount = alloca i32, align 4
  %properties = alloca [3 x i32], align 4
  %devices66 = alloca [1 x %struct._cl_device_id*], align 4
  %lengths = alloca [1 x i32], align 4
  %sources = alloca [1 x i8*], align 4
  %binaries = alloca [1 x i8*], align 4
  %len = alloca i32, align 4
  %0 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %1 = load %struct._cl_context** %0, align 4, !tbaa !1
  %tobool = icmp eq %struct._cl_context* %1, null
  br i1 %tobool, label %if.then, label %if.else53

if.then:                                          ; preds = %entry
  store i32 0, i32* %platformCount, align 4, !tbaa !10
  %arraydecay = getelementptr inbounds [4 x %struct._cl_platform_id*]* %platforms, i32 0, i32 0
  %call = call i32 @clGetPlatformIDs(i32 4, %struct._cl_platform_id** %arraydecay, i32* %platformCount)
  store i32 %call, i32* %err, align 4, !tbaa !10
  %call1 = call i8* @getenv(i8* getelementptr inbounds ([16 x i8]* @.str3, i32 0, i32 0))
  %cmp = icmp eq i8* %call1, null
  %2 = load i32* %platformCount, align 4, !tbaa !10
  %cmp14 = icmp eq i32 %2, 0
  br i1 %cmp, label %if.else, label %for.cond.preheader

for.cond.preheader:                               ; preds = %if.then
  br i1 %cmp14, label %if.then20, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %3 = getelementptr inbounds [256 x i8]* %platformName, i32 0, i32 0
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %i.0162 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  call void @llvm.lifetime.start(i64 256, i8* %3) #2
  %arrayidx = getelementptr inbounds [4 x %struct._cl_platform_id*]* %platforms, i32 0, i32 %i.0162
  %4 = load %struct._cl_platform_id** %arrayidx, align 4, !tbaa !1
  %call5 = call i32 @clGetPlatformInfo(%struct._cl_platform_id* %4, i32 2306, i32 256, i8* %3, i32* null)
  store i32 %call5, i32* %err, align 4, !tbaa !10
  %cmp6 = icmp eq i32 %call5, 0
  br i1 %cmp6, label %if.end, label %for.inc

if.end:                                           ; preds = %for.body
  %call9 = call i8* @strstr(i8* %3, i8* %call1)
  %tobool10 = icmp eq i8* %call9, null
  br i1 %tobool10, label %for.inc, label %cleanup

cleanup:                                          ; preds = %if.end
  %5 = load %struct._cl_platform_id** %arrayidx, align 4, !tbaa !1
  call void @llvm.lifetime.end(i64 256, i8* %3) #2
  br label %if.end18

for.inc:                                          ; preds = %for.body, %if.end
  call void @llvm.lifetime.end(i64 256, i8* %3) #2
  %inc = add i32 %i.0162, 1
  %6 = load i32* %platformCount, align 4, !tbaa !10
  %cmp3 = icmp ult i32 %inc, %6
  br i1 %cmp3, label %for.body, label %if.then20

if.else:                                          ; preds = %if.then
  %7 = load %struct._cl_platform_id** %arraydecay, align 4, !tbaa !1
  br i1 %cmp14, label %if.then20, label %if.end18

if.end18:                                         ; preds = %if.else, %cleanup
  %platform.2 = phi %struct._cl_platform_id* [ %5, %cleanup ], [ %7, %if.else ]
  %cmp19 = icmp eq %struct._cl_platform_id* %platform.2, null
  br i1 %cmp19, label %if.then20, label %if.end22

if.then20:                                        ; preds = %for.inc, %for.cond.preheader, %if.else, %if.end18
  %call21 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([32 x i8]* @.str4, i32 0, i32 0))
  br label %return

if.end22:                                         ; preds = %if.end18
  %call23 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str5, i32 0, i32 0))
  %cmp24 = icmp eq i8* %call23, null
  br i1 %cmp24, label %if.end35, label %if.then25

if.then25:                                        ; preds = %if.end22
  %call26 = call i8* @strstr(i8* getelementptr inbounds ([4 x i8]* @.str6, i32 0, i32 0), i8* %call23)
  %tobool27 = icmp eq i8* %call26, null
  %.148 = select i1 %tobool27, i64 0, i64 2
  %call30 = call i8* @strstr(i8* getelementptr inbounds ([4 x i8]* @.str7, i32 0, i32 0), i8* %call23)
  %tobool31 = icmp eq i8* %call30, null
  %or33 = or i64 %.148, 4
  %.148.or33 = select i1 %tobool31, i64 %.148, i64 %or33
  br label %if.end35

if.end35:                                         ; preds = %if.then25, %if.end22
  %device_type.1 = phi i64 [ 0, %if.end22 ], [ %.148.or33, %if.then25 ]
  %cmp36 = icmp eq i64 %device_type.1, 0
  %.device_type.1 = select i1 %cmp36, i64 4294967295, i64 %device_type.1
  store i32 0, i32* %deviceCount, align 4, !tbaa !10
  %arraydecay39 = getelementptr inbounds [4 x %struct._cl_device_id*]* %devices, i32 0, i32 0
  %call40 = call i32 @clGetDeviceIDs(%struct._cl_platform_id* %platform.2, i64 %.device_type.1, i32 4, %struct._cl_device_id** %arraydecay39, i32* %deviceCount)
  store i32 %call40, i32* %err, align 4, !tbaa !10
  %8 = load i32* %deviceCount, align 4, !tbaa !10
  %cmp41 = icmp eq i32 %8, 0
  br i1 %cmp41, label %if.then42, label %if.end44

if.then42:                                        ; preds = %if.end35
  %call43 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str8, i32 0, i32 0))
  br label %return

if.end44:                                         ; preds = %if.end35
  %sub = add i32 %8, -1
  %arrayidx45 = getelementptr inbounds [4 x %struct._cl_device_id*]* %devices, i32 0, i32 %sub
  %9 = load %struct._cl_device_id** %arrayidx45, align 4, !tbaa !1
  store %struct._cl_device_id* %9, %struct._cl_device_id** %dev, align 4, !tbaa !1
  %arrayinit.begin = getelementptr inbounds [3 x i32]* %properties, i32 0, i32 0
  store i32 4228, i32* %arrayinit.begin, align 4, !tbaa !10
  %arrayinit.element = getelementptr inbounds [3 x i32]* %properties, i32 0, i32 1
  %10 = ptrtoint %struct._cl_platform_id* %platform.2 to i32
  store i32 %10, i32* %arrayinit.element, align 4, !tbaa !10
  %arrayinit.element46 = getelementptr inbounds [3 x i32]* %properties, i32 0, i32 2
  store i32 0, i32* %arrayinit.element46, align 4, !tbaa !10
  %call48 = call %struct._cl_context* @clCreateContext(i32* %arrayinit.begin, i32 1, %struct._cl_device_id** %dev, void (i8*, i8*, i32, i8*)* null, i8* null, i32* %err)
  %11 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  store %struct._cl_context* %call48, %struct._cl_context** %11, align 4, !tbaa !1
  %12 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %13 = load %struct._cl_command_queue** %12, align 4, !tbaa !1
  %tobool49 = icmp eq %struct._cl_command_queue* %13, null
  br i1 %tobool49, label %if.end51, label %if.then50

if.then50:                                        ; preds = %if.end44
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str9, i32 0, i32 0))
  br label %if.end51

if.end51:                                         ; preds = %if.end44, %if.then50
  %14 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %15 = load %struct._cl_context** %14, align 4, !tbaa !1
  %16 = load %struct._cl_device_id** %dev, align 4, !tbaa !1
  %call52 = call %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context* %15, %struct._cl_device_id* %16, i64 0, i32* %err)
  %17 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  store %struct._cl_command_queue* %call52, %struct._cl_command_queue** %17, align 4, !tbaa !1
  br label %if.end57

if.else53:                                        ; preds = %entry
  %call54 = call i32 @clRetainContext(%struct._cl_context* %1)
  %18 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %19 = load %struct._cl_command_queue** %18, align 4, !tbaa !1
  %call55 = call i32 @clRetainCommandQueue(%struct._cl_command_queue* %19)
  %20 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %21 = load %struct._cl_context** %20, align 4, !tbaa !1
  %22 = bitcast %struct._cl_device_id** %dev to i8*
  %call56 = call i32 @clGetContextInfo(%struct._cl_context* %21, i32 4225, i32 4, i8* %22, i32* null)
  br label %if.end57

if.end57:                                         ; preds = %if.else53, %if.end51
  %23 = bitcast i8* %state_ptr to %struct._module_state_*
  %tobool58 = icmp eq i8* %state_ptr, null
  br i1 %tobool58, label %if.then59, label %if.end61

if.then59:                                        ; preds = %if.end57
  %call60 = call i8* @malloc(i32 8)
  %24 = bitcast i8* %call60 to %struct._module_state_*
  %program = bitcast i8* %call60 to %struct._cl_program**
  store %struct._cl_program* null, %struct._cl_program** %program, align 4, !tbaa !11
  %25 = load %struct._module_state_** @state_list, align 4, !tbaa !1
  %next = getelementptr inbounds i8* %call60, i32 4
  %26 = bitcast i8* %next to %struct._module_state_**
  store %struct._module_state_* %25, %struct._module_state_** %26, align 4, !tbaa !13
  store %struct._module_state_* %24, %struct._module_state_** @state_list, align 4, !tbaa !1
  br label %if.end61

if.end61:                                         ; preds = %if.end57, %if.then59
  %state.0 = phi %struct._module_state_* [ %23, %if.end57 ], [ %24, %if.then59 ]
  %program62 = getelementptr inbounds %struct._module_state_* %state.0, i32 0, i32 0
  %27 = load %struct._cl_program** %program62, align 4, !tbaa !11
  %tobool63 = icmp eq %struct._cl_program* %27, null
  %cmp64 = icmp sgt i32 %size, 1
  %or.cond = and i1 %tobool63, %cmp64
  br i1 %or.cond, label %if.then65, label %if.end113

if.then65:                                        ; preds = %if.end61
  %arrayinit.begin67 = getelementptr inbounds [1 x %struct._cl_device_id*]* %devices66, i32 0, i32 0
  %28 = load %struct._cl_device_id** %dev, align 4, !tbaa !1
  store %struct._cl_device_id* %28, %struct._cl_device_id** %arrayinit.begin67, align 4, !tbaa !1
  %arrayinit.begin68 = getelementptr inbounds [1 x i32]* %lengths, i32 0, i32 0
  store i32 %size, i32* %arrayinit.begin68, align 4, !tbaa !10
  %call69 = call i8* @strstr(i8* %src, i8* getelementptr inbounds ([13 x i8]* @.str10, i32 0, i32 0))
  %tobool70 = icmp eq i8* %call69, null
  br i1 %tobool70, label %if.else76, label %if.then71

if.then71:                                        ; preds = %if.then65
  %arrayinit.begin72 = getelementptr inbounds [1 x i8*]* %sources, i32 0, i32 0
  store i8* %src, i8** %arrayinit.begin72, align 4, !tbaa !1
  %29 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %30 = load %struct._cl_context** %29, align 4, !tbaa !1
  %call74 = call %struct._cl_program* @clCreateProgramWithSource(%struct._cl_context* %30, i32 1, i8** %arrayinit.begin72, i32* null, i32* %err)
  br label %if.end83

if.else76:                                        ; preds = %if.then65
  %arrayinit.begin77 = getelementptr inbounds [1 x i8*]* %binaries, i32 0, i32 0
  store i8* %src, i8** %arrayinit.begin77, align 4, !tbaa !1
  %31 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %32 = load %struct._cl_context** %31, align 4, !tbaa !1
  %call81 = call %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context* %32, i32 1, %struct._cl_device_id** %arrayinit.begin67, i32* %arrayinit.begin68, i8** %arrayinit.begin77, i32* null, i32* %err)
  br label %if.end83

if.end83:                                         ; preds = %if.else76, %if.then71
  %storemerge = phi %struct._cl_program* [ %call81, %if.else76 ], [ %call74, %if.then71 ]
  store %struct._cl_program* %storemerge, %struct._cl_program** %program62, align 4, !tbaa !11
  %call85 = call i32 @clBuildProgram(%struct._cl_program* %storemerge, i32 1, %struct._cl_device_id** %dev, i8* null, void (%struct._cl_program*, i8*)* null, i8* null)
  store i32 %call85, i32* %err, align 4, !tbaa !10
  %cmp86 = icmp eq i32 %call85, 0
  br i1 %cmp86, label %if.end113, label %if.then87

if.then87:                                        ; preds = %if.end83
  store i32 0, i32* %len, align 4, !tbaa !10
  %call88 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str11, i32 0, i32 0), i32 %call85)
  %33 = load %struct._cl_program** %program62, align 4, !tbaa !11
  %34 = load %struct._cl_device_id** %dev, align 4, !tbaa !1
  %call90 = call i32 @clGetProgramBuildInfo(%struct._cl_program* %33, %struct._cl_device_id* %34, i32 4483, i32 0, i8* null, i32* %len)
  %cmp91 = icmp eq i32 %call90, 0
  br i1 %cmp91, label %if.end95, label %if.end105.thread157

if.end95:                                         ; preds = %if.then87
  %35 = load i32* %len, align 4, !tbaa !10
  %inc93 = add i32 %35, 1
  store i32 %inc93, i32* %len, align 4, !tbaa !10
  %call94 = call i8* @malloc(i32 %inc93)
  %tobool96 = icmp eq i8* %call94, null
  br i1 %tobool96, label %if.end105.thread157, label %land.lhs.true97

land.lhs.true97:                                  ; preds = %if.end95
  %36 = load %struct._cl_program** %program62, align 4, !tbaa !11
  %37 = load %struct._cl_device_id** %dev, align 4, !tbaa !1
  %call99 = call i32 @clGetProgramBuildInfo(%struct._cl_program* %36, %struct._cl_device_id* %37, i32 4483, i32 %inc93, i8* %call94, i32* null)
  %cmp100 = icmp eq i32 %call99, 0
  br i1 %cmp100, label %if.end105.thread, label %if.end105.thread159

if.end105.thread159:                              ; preds = %land.lhs.true97
  %call104160 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([48 x i8]* @.str13, i32 0, i32 0))
  br label %if.then107

if.end105.thread:                                 ; preds = %land.lhs.true97
  %call102 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str12, i32 0, i32 0), i8* %call94)
  br label %if.then107

if.end105.thread157:                              ; preds = %if.end95, %if.then87
  %call104158 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([48 x i8]* @.str13, i32 0, i32 0))
  br label %if.end108

if.then107:                                       ; preds = %if.end105.thread159, %if.end105.thread
  call void @free(i8* %call94)
  br label %if.end108

if.end108:                                        ; preds = %if.end105.thread157, %if.then107
  %38 = load i32* %err, align 4, !tbaa !10
  %cmp109 = icmp eq i32 %38, 0
  br i1 %cmp109, label %if.end113, label %if.then110

if.then110:                                       ; preds = %if.end108
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str14, i32 0, i32 0))
  br label %if.end113

if.end113:                                        ; preds = %if.end83, %if.end61, %if.then110, %if.end108
  %39 = bitcast %struct._module_state_* %state.0 to i8*
  br label %return

return:                                           ; preds = %if.end113, %if.then42, %if.then20
  %retval.0 = phi i8* [ %39, %if.end113 ], [ null, %if.then20 ], [ null, %if.then42 ]
  ret i8* %retval.0
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

declare i32 @clGetDeviceIDs(%struct._cl_platform_id*, i64, i32, %struct._cl_device_id**, i32*) #0

declare %struct._cl_context* @clCreateContext(i32*, i32, %struct._cl_device_id**, void (i8*, i8*, i32, i8*)*, i8*, i32*) #0

declare %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context*, %struct._cl_device_id*, i64, i32*) #0

declare i32 @clRetainContext(%struct._cl_context*) #0

declare i32 @clRetainCommandQueue(%struct._cl_command_queue*) #0

declare i32 @clGetContextInfo(%struct._cl_context*, i32, i32, i8*, i32*) #0

; Function Attrs: nounwind
declare noalias i8* @malloc(i32) #3

declare %struct._cl_program* @clCreateProgramWithSource(%struct._cl_context*, i32, i8**, i32*, i32*) #0

declare %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context*, i32, %struct._cl_device_id**, i32*, i8**, i32*, i32*) #0

declare i32 @clBuildProgram(%struct._cl_program*, i32, %struct._cl_device_id**, i8*, void (%struct._cl_program*, i8*)*, i8*) #0

declare i32 @clGetProgramBuildInfo(%struct._cl_program*, %struct._cl_device_id*, i32, i32, i8*, i32*) #0

; Function Attrs: nounwind
declare void @free(i8* nocapture) #3

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
  call void @halide_dev_sync(i8* %user_context)
  %state.013 = load %struct._module_state_** @state_list, align 4
  %tobool14 = icmp eq %struct._module_state_* %state.013, null
  br i1 %tobool14, label %while.end, label %while.body

while.body:                                       ; preds = %entry, %if.end
  %state.015 = phi %struct._module_state_* [ %state.0, %if.end ], [ %state.013, %entry ]
  %program = getelementptr inbounds %struct._module_state_* %state.015, i32 0, i32 0
  %0 = load %struct._cl_program** %program, align 4, !tbaa !11
  %tobool1 = icmp eq %struct._cl_program* %0, null
  br i1 %tobool1, label %if.end, label %if.then

if.then:                                          ; preds = %while.body
  %call = call i32 @clReleaseProgram(%struct._cl_program* %0)
  store %struct._cl_program* null, %struct._cl_program** %program, align 4, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %while.body, %if.then
  %next = getelementptr inbounds %struct._module_state_* %state.015, i32 0, i32 1
  %state.0 = load %struct._module_state_** %next, align 4
  %tobool = icmp eq %struct._module_state_* %state.0, null
  br i1 %tobool, label %while.end, label %while.body

while.end:                                        ; preds = %if.end, %entry
  store i32 0, i32* %refs, align 4, !tbaa !10
  %1 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %2 = load %struct._cl_context** %1, align 4, !tbaa !1
  %3 = bitcast i32* %refs to i8*
  %call4 = call i32 @clGetContextInfo(%struct._cl_context* %2, i32 4224, i32 4, i8* %3, i32* null)
  %4 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %5 = load %struct._cl_command_queue** %4, align 4, !tbaa !1
  %call5 = call i32 @clReleaseCommandQueue(%struct._cl_command_queue* %5)
  %6 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %7 = load %struct._cl_context** %6, align 4, !tbaa !1
  %call6 = call i32 @clReleaseContext(%struct._cl_context* %7)
  %8 = load i32* %refs, align 4, !tbaa !10
  %dec = add i32 %8, -1
  store i32 %dec, i32* %refs, align 4, !tbaa !10
  %cmp = icmp eq i32 %dec, 0
  br i1 %cmp, label %if.then7, label %if.end8

if.then7:                                         ; preds = %while.end
  %9 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  store %struct._cl_context* null, %struct._cl_context** %9, align 4, !tbaa !1
  %10 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  store %struct._cl_command_queue* null, %struct._cl_command_queue** %10, align 4, !tbaa !1
  br label %if.end8

if.end8:                                          ; preds = %if.then7, %while.end
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
  br i1 %call, label %if.end9, label %if.then1

if.then1:                                         ; preds = %if.then
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i32 0, i32 0))
  br label %if.end9

if.end2:                                          ; preds = %entry
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 5
  %1 = load i32* %elem_size.i, align 4, !tbaa !14
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
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str21, i32 0, i32 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end2, %if.then4.i
  %10 = bitcast i32* %err.i to i8*
  call void @llvm.lifetime.start(i64 4, i8* %10)
  %11 = load %struct._cl_context*** @_Z6cl_ctx, align 4, !tbaa !1
  %12 = load %struct._cl_context** %11, align 4, !tbaa !1
  %call.i = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %12, i64 1, i32 %mul2.size.0.3.i, i8* null, i32* %err.i)
  %tobool.i16 = icmp eq %struct._cl_mem* %call.i, null
  br i1 %tobool.i16, label %if.then8, label %_Z12__dev_mallocPvj.exit

_Z12__dev_mallocPvj.exit:                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  call void @llvm.lifetime.end(i64 4, i8* %10)
  %13 = ptrtoint %struct._cl_mem* %call.i to i32
  %14 = zext i32 %13 to i64
  store i64 %14, i64* %dev, align 4, !tbaa !5
  br label %if.end9

if.then8:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([2 x i8]* @.str20, i32 0, i32 0))
  call void @llvm.lifetime.end(i64 4, i8* %10)
  store i64 0, i64* %dev, align 4, !tbaa !5
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str15, i32 0, i32 0))
  br label %if.end9

if.end9:                                          ; preds = %_Z12__dev_mallocPvj.exit, %if.then, %if.then1, %if.then8
  ret void
}

define weak void @halide_copy_to_dev(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %host_dirty = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 6
  %0 = load i8* %host_dirty, align 1, !tbaa !15, !range !16
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end10, label %if.then

if.then:                                          ; preds = %entry
  %host = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 1
  %1 = load i8** %host, align 4, !tbaa !17
  %tobool1 = icmp eq i8* %1, null
  br i1 %tobool1, label %if.then3, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.then
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %2 = load i64* %dev, align 4, !tbaa !5
  %tobool2 = icmp eq i64 %2, 0
  br i1 %tobool2, label %if.then3, label %if.end

if.then3:                                         ; preds = %land.lhs.true, %if.then
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str16, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then3
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 5
  %3 = load i32* %elem_size.i, align 4, !tbaa !14
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
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str21, i32 0, i32 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then4.i
  %call4 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i32 0)
  br i1 %call4, label %if.end6, label %if.then5

if.then5:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i32 0, i32 0))
  br label %if.end6

if.end6:                                          ; preds = %if.then5, %_Z10__buf_sizePvP8buffer_t.exit
  %12 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %13 = load %struct._cl_command_queue** %12, align 4, !tbaa !1
  %dev7 = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %14 = load i64* %dev7, align 4, !tbaa !5
  %conv = trunc i64 %14 to i32
  %15 = inttoptr i32 %conv to %struct._cl_mem*
  %16 = load i8** %host, align 4, !tbaa !17
  %call9 = tail call i32 @clEnqueueWriteBuffer(%struct._cl_command_queue* %13, %struct._cl_mem* %15, i32 1, i32 0, i32 %mul2.size.0.3.i, i8* %16, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  br label %if.end10

if.end10:                                         ; preds = %entry, %if.end6
  store i8 0, i8* %host_dirty, align 1, !tbaa !15
  ret void
}

declare i32 @clEnqueueWriteBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i32, i32, i8*, i32, %struct._cl_event**, %struct._cl_event**) #0

define weak void @halide_copy_to_host(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %dev_dirty = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 7
  %0 = load i8* %dev_dirty, align 1, !tbaa !18, !range !16
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end11, label %if.then

if.then:                                          ; preds = %entry
  %1 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %2 = load %struct._cl_command_queue** %1, align 4, !tbaa !1
  %call = tail call i32 @clFinish(%struct._cl_command_queue* %2)
  %host = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 1
  %3 = load i8** %host, align 4, !tbaa !17
  %tobool1 = icmp eq i8* %3, null
  br i1 %tobool1, label %if.then3, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.then
  %dev = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %4 = load i64* %dev, align 4, !tbaa !5
  %tobool2 = icmp eq i64 %4, 0
  br i1 %tobool2, label %if.then3, label %if.end

if.then3:                                         ; preds = %land.lhs.true, %if.then
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str16, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then3
  %elem_size.i = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 5
  %5 = load i32* %elem_size.i, align 4, !tbaa !14
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
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str21, i32 0, i32 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then4.i
  %call5 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i32 %mul2.size.0.3.i)
  br i1 %call5, label %if.end7, label %if.then6

if.then6:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str17, i32 0, i32 0))
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %_Z10__buf_sizePvP8buffer_t.exit
  %14 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %15 = load %struct._cl_command_queue** %14, align 4, !tbaa !1
  %dev8 = getelementptr inbounds %struct.buffer_t* %buf, i32 0, i32 0
  %16 = load i64* %dev8, align 4, !tbaa !5
  %conv = trunc i64 %16 to i32
  %17 = inttoptr i32 %conv to %struct._cl_mem*
  %18 = load i8** %host, align 4, !tbaa !17
  %call10 = tail call i32 @clEnqueueReadBuffer(%struct._cl_command_queue* %15, %struct._cl_mem* %17, i32 1, i32 0, i32 %mul2.size.0.3.i, i8* %18, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  br label %if.end11

if.end11:                                         ; preds = %entry, %if.end7
  store i8 0, i8* %dev_dirty, align 1, !tbaa !18
  ret void
}

declare i32 @clEnqueueReadBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i32, i32, i8*, i32, %struct._cl_event**, %struct._cl_event**) #0

define weak void @halide_dev_run(i8* %user_context, i8* %state_ptr, i8* %entry_name, i32 %blocksX, i32 %blocksY, i32 %blocksZ, i32 %threadsX, i32 %threadsY, i32 %threadsZ, i32 %shared_mem_bytes, i32* %arg_sizes, i8** %args) #0 {
entry:
  %err.i = alloca i32, align 4
  %global_dim = alloca [3 x i32], align 4
  %local_dim = alloca [3 x i32], align 4
  %tobool = icmp eq i8* %state_ptr, null
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([10 x i8]* @.str18, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %program1 = bitcast i8* %state_ptr to %struct._cl_program**
  %0 = load %struct._cl_program** %program1, align 4, !tbaa !11
  %tobool2 = icmp eq %struct._cl_program* %0, null
  br i1 %tobool2, label %if.then3, label %if.end4

if.then3:                                         ; preds = %if.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([8 x i8]* @.str19, i32 0, i32 0))
  br label %if.end4

if.end4:                                          ; preds = %if.end, %if.then3
  %1 = bitcast i32* %err.i to i8*
  call void @llvm.lifetime.start(i64 4, i8* %1)
  %call.i = call %struct._cl_kernel* @clCreateKernel(%struct._cl_program* %0, i8* %entry_name, i32* %err.i)
  call void @llvm.lifetime.end(i64 4, i8* %1)
  %arrayinit.begin = getelementptr inbounds [3 x i32]* %global_dim, i32 0, i32 0
  %mul = mul nsw i32 %threadsX, %blocksX
  store i32 %mul, i32* %arrayinit.begin, align 4, !tbaa !10
  %arrayinit.element = getelementptr inbounds [3 x i32]* %global_dim, i32 0, i32 1
  %mul5 = mul nsw i32 %threadsY, %blocksY
  store i32 %mul5, i32* %arrayinit.element, align 4, !tbaa !10
  %arrayinit.element6 = getelementptr inbounds [3 x i32]* %global_dim, i32 0, i32 2
  %mul7 = mul nsw i32 %threadsZ, %blocksZ
  store i32 %mul7, i32* %arrayinit.element6, align 4, !tbaa !10
  %arrayinit.begin8 = getelementptr inbounds [3 x i32]* %local_dim, i32 0, i32 0
  store i32 %threadsX, i32* %arrayinit.begin8, align 4, !tbaa !10
  %arrayinit.element9 = getelementptr inbounds [3 x i32]* %local_dim, i32 0, i32 1
  store i32 %threadsY, i32* %arrayinit.element9, align 4, !tbaa !10
  %arrayinit.element10 = getelementptr inbounds [3 x i32]* %local_dim, i32 0, i32 2
  store i32 %threadsZ, i32* %arrayinit.element10, align 4, !tbaa !10
  %2 = load i32* %arg_sizes, align 4, !tbaa !10
  %cmp32 = icmp eq i32 %2, 0
  br i1 %cmp32, label %while.end, label %while.body

while.body:                                       ; preds = %if.end4, %while.body
  %3 = phi i32 [ %5, %while.body ], [ %2, %if.end4 ]
  %i.033 = phi i32 [ %inc, %while.body ], [ 0, %if.end4 ]
  %arrayidx12 = getelementptr inbounds i8** %args, i32 %i.033
  %4 = load i8** %arrayidx12, align 4, !tbaa !1
  %call13 = call i32 @clSetKernelArg(%struct._cl_kernel* %call.i, i32 %i.033, i32 %3, i8* %4)
  %inc = add nsw i32 %i.033, 1
  %arrayidx = getelementptr inbounds i32* %arg_sizes, i32 %inc
  %5 = load i32* %arrayidx, align 4, !tbaa !10
  %cmp = icmp eq i32 %5, 0
  br i1 %cmp, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %if.end4
  %i.0.lcssa = phi i32 [ 0, %if.end4 ], [ %inc, %while.body ]
  %cmp14 = icmp slt i32 %shared_mem_bytes, 1
  %cond = select i1 %cmp14, i32 1, i32 %shared_mem_bytes
  %call15 = call i32 @clSetKernelArg(%struct._cl_kernel* %call.i, i32 %i.0.lcssa, i32 %cond, i8* null)
  %6 = load %struct._cl_command_queue*** @_Z4cl_q, align 4, !tbaa !1
  %7 = load %struct._cl_command_queue** %6, align 4, !tbaa !1
  %call17 = call i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue* %7, %struct._cl_kernel* %call.i, i32 3, i32* null, i32* %arrayinit.begin, i32* %arrayinit.begin8, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  ret void
}

declare i32 @clSetKernelArg(%struct._cl_kernel*, i32, i32, i8*) #0

declare i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue*, %struct._cl_kernel*, i32, i32*, i32*, i32*, i32, %struct._cl_event**, %struct._cl_event**) #0

declare %struct._cl_kernel* @clCreateKernel(%struct._cl_program*, i8*, i32*) #0

declare %struct._cl_mem* @clCreateBuffer(%struct._cl_context*, i64, i32, i8*, i32*) #0

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }
attributes #3 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

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
!11 = metadata !{metadata !12, metadata !2, i64 0}
!12 = metadata !{metadata !"_ZTS14_module_state_", metadata !2, i64 0, metadata !2, i64 4}
!13 = metadata !{metadata !12, metadata !2, i64 4}
!14 = metadata !{metadata !6, metadata !8, i64 60}
!15 = metadata !{metadata !6, metadata !9, i64 64}
!16 = metadata !{i8 0, i8 2}
!17 = metadata !{metadata !6, metadata !2, i64 8}
!18 = metadata !{metadata !6, metadata !9, i64 65}
