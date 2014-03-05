; ModuleID = 'src/runtime/opencl.cpp'
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
@.str1 = private unnamed_addr constant [65 x i8] c"real_size >= size && \22Validating pointer with insufficient size\22\00", align 1
@.str2 = private unnamed_addr constant [47 x i8] c"halide_validate_dev_pointer(user_context, buf)\00", align 1
@.str3 = private unnamed_addr constant [16 x i8] c"HL_OCL_PLATFORM\00", align 1
@.str4 = private unnamed_addr constant [32 x i8] c"Failed to find OpenCL platform\0A\00", align 1
@.str5 = private unnamed_addr constant [14 x i8] c"HL_OCL_DEVICE\00", align 1
@.str6 = private unnamed_addr constant [4 x i8] c"cpu\00", align 1
@.str7 = private unnamed_addr constant [4 x i8] c"gpu\00", align 1
@.str8 = private unnamed_addr constant [22 x i8] c"Failed to get device\0A\00", align 1
@.str9 = private unnamed_addr constant [9 x i8] c"!(*cl_q)\00", align 1
@_Z5__mod = internal unnamed_addr global %struct._cl_program* null, align 8
@.str10 = private unnamed_addr constant [13 x i8] c"/*OpenCL C*/\00", align 1
@.str11 = private unnamed_addr constant [53 x i8] c"Error: Failed to build program executable! err = %d\0A\00", align 1
@.str12 = private unnamed_addr constant [22 x i8] c"Build Log:\0A %s\0A-----\0A\00", align 1
@.str13 = private unnamed_addr constant [48 x i8] c"clGetProgramBuildInfo failed to get build log!\0A\00", align 1
@.str14 = private unnamed_addr constant [18 x i8] c"err == CL_SUCCESS\00", align 1
@.str15 = private unnamed_addr constant [9 x i8] c"buf->dev\00", align 1
@.str16 = private unnamed_addr constant [22 x i8] c"buf->host && buf->dev\00", align 1
@.str17 = private unnamed_addr constant [53 x i8] c"halide_validate_dev_pointer(user_context, buf, size)\00", align 1
@.str18 = private unnamed_addr constant [2 x i8] c"p\00", align 1
@.str19 = private unnamed_addr constant [5 x i8] c"size\00", align 1

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
  br i1 %tobool, label %if.end5, label %if.then2

if.then2:                                         ; preds = %if.end
  %3 = load i64* %dev, align 8, !tbaa !5
  %4 = inttoptr i64 %3 to i8*
  %call4 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([55 x i8]* @.str, i64 0, i64 0), i8* %4, i32 %call)
  br label %return

if.end5:                                          ; preds = %if.end
  %tobool6 = icmp eq i64 %size, 0
  br i1 %tobool6, label %return, label %if.then7

if.then7:                                         ; preds = %if.end5
  %5 = load i64* %real_size, align 8, !tbaa !10
  %cmp8 = icmp ult i64 %5, %size
  br i1 %cmp8, label %if.then9, label %return

if.then9:                                         ; preds = %if.then7
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([65 x i8]* @.str1, i64 0, i64 0))
  br label %return

return:                                           ; preds = %if.then9, %if.end5, %if.then7, %entry, %if.then2
  %retval.0 = phi i1 [ false, %if.then2 ], [ true, %entry ], [ true, %if.then7 ], [ true, %if.end5 ], [ true, %if.then9 ]
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
  %call = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i64 0)
  br i1 %call, label %if.end2, label %if.then1

if.then1:                                         ; preds = %if.end
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i64 0, i64 0))
  br label %if.end2

if.end2:                                          ; preds = %if.then1, %if.end
  %1 = load i64* %dev, align 8, !tbaa !5
  %2 = inttoptr i64 %1 to %struct._cl_mem*
  %call4 = tail call i32 @clReleaseMemObject(%struct._cl_mem* %2)
  store i64 0, i64* %dev, align 8, !tbaa !5
  br label %return

return:                                           ; preds = %entry, %if.end2
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
  %devices = alloca [4 x %struct._cl_device_id*], align 16
  %deviceCount = alloca i32, align 4
  %properties = alloca [3 x i64], align 16
  %devices63 = alloca [1 x %struct._cl_device_id*], align 8
  %lengths = alloca [1 x i64], align 8
  %sources = alloca [1 x i8*], align 8
  %binaries = alloca [1 x i8*], align 8
  %len = alloca i64, align 8
  %buffer = alloca [2048 x i8], align 16
  %0 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %1 = load %struct._cl_context** %0, align 8, !tbaa !1
  %tobool = icmp eq %struct._cl_context* %1, null
  br i1 %tobool, label %if.then, label %if.else55

if.then:                                          ; preds = %entry
  store i32 0, i32* %platformCount, align 4, !tbaa !11
  %arraydecay = getelementptr inbounds [4 x %struct._cl_platform_id*]* %platforms, i64 0, i64 0
  %call = call i32 @clGetPlatformIDs(i32 4, %struct._cl_platform_id** %arraydecay, i32* %platformCount)
  store i32 %call, i32* %err, align 4, !tbaa !11
  %call1 = call i8* @getenv(i8* getelementptr inbounds ([16 x i8]* @.str3, i64 0, i64 0))
  %cmp = icmp eq i8* %call1, null
  %2 = load i32* %platformCount, align 4, !tbaa !11
  %cmp15 = icmp eq i32 %2, 0
  br i1 %cmp, label %if.else, label %for.cond.preheader

for.cond.preheader:                               ; preds = %if.then
  br i1 %cmp15, label %if.then21, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %3 = getelementptr inbounds [256 x i8]* %platformName, i64 0, i64 0
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %i.0119 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  call void @llvm.lifetime.start(i64 256, i8* %3) #3
  %idxprom = zext i32 %i.0119 to i64
  %arrayidx = getelementptr inbounds [4 x %struct._cl_platform_id*]* %platforms, i64 0, i64 %idxprom
  %4 = load %struct._cl_platform_id** %arrayidx, align 8, !tbaa !1
  %call5 = call i32 @clGetPlatformInfo(%struct._cl_platform_id* %4, i32 2306, i64 256, i8* %3, i64* null)
  store i32 %call5, i32* %err, align 4, !tbaa !11
  %cmp6 = icmp eq i32 %call5, 0
  br i1 %cmp6, label %if.end, label %for.inc

if.end:                                           ; preds = %for.body
  %call9 = call i8* @strstr(i8* %3, i8* %call1)
  %tobool10 = icmp eq i8* %call9, null
  br i1 %tobool10, label %for.inc, label %cleanup

cleanup:                                          ; preds = %if.end
  %5 = load %struct._cl_platform_id** %arrayidx, align 8, !tbaa !1
  call void @llvm.lifetime.end(i64 256, i8* %3) #3
  br label %if.end19

for.inc:                                          ; preds = %for.body, %if.end
  call void @llvm.lifetime.end(i64 256, i8* %3) #3
  %inc = add i32 %i.0119, 1
  %6 = load i32* %platformCount, align 4, !tbaa !11
  %cmp3 = icmp ult i32 %inc, %6
  br i1 %cmp3, label %for.body, label %if.then21

if.else:                                          ; preds = %if.then
  br i1 %cmp15, label %if.then21, label %if.then16

if.then16:                                        ; preds = %if.else
  %7 = load %struct._cl_platform_id** %arraydecay, align 16, !tbaa !1
  br label %if.end19

if.end19:                                         ; preds = %cleanup, %if.then16
  %platform.2 = phi %struct._cl_platform_id* [ %5, %cleanup ], [ %7, %if.then16 ]
  %cmp20 = icmp eq %struct._cl_platform_id* %platform.2, null
  br i1 %cmp20, label %if.then21, label %if.end23

if.then21:                                        ; preds = %for.inc, %for.cond.preheader, %if.else, %if.end19
  %call22 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([32 x i8]* @.str4, i64 0, i64 0))
  br label %if.end96

if.end23:                                         ; preds = %if.end19
  %call24 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str5, i64 0, i64 0))
  %cmp25 = icmp eq i8* %call24, null
  br i1 %cmp25, label %if.end36, label %if.then26

if.then26:                                        ; preds = %if.end23
  %call27 = call i8* @strstr(i8* getelementptr inbounds ([4 x i8]* @.str6, i64 0, i64 0), i8* %call24)
  %tobool28 = icmp eq i8* %call27, null
  %. = select i1 %tobool28, i64 0, i64 2
  %call31 = call i8* @strstr(i8* getelementptr inbounds ([4 x i8]* @.str7, i64 0, i64 0), i8* %call24)
  %tobool32 = icmp eq i8* %call31, null
  %or34 = or i64 %., 4
  %..or34 = select i1 %tobool32, i64 %., i64 %or34
  br label %if.end36

if.end36:                                         ; preds = %if.then26, %if.end23
  %device_type.1 = phi i64 [ 0, %if.end23 ], [ %..or34, %if.then26 ]
  %cmp37 = icmp eq i64 %device_type.1, 0
  %.device_type.1 = select i1 %cmp37, i64 4294967295, i64 %device_type.1
  store i32 0, i32* %deviceCount, align 4, !tbaa !11
  %arraydecay40 = getelementptr inbounds [4 x %struct._cl_device_id*]* %devices, i64 0, i64 0
  %call41 = call i32 @clGetDeviceIDs(%struct._cl_platform_id* %platform.2, i64 %.device_type.1, i32 4, %struct._cl_device_id** %arraydecay40, i32* %deviceCount)
  store i32 %call41, i32* %err, align 4, !tbaa !11
  %8 = load i32* %deviceCount, align 4, !tbaa !11
  %cmp42 = icmp eq i32 %8, 0
  br i1 %cmp42, label %if.then43, label %if.end45

if.then43:                                        ; preds = %if.end36
  %call44 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str8, i64 0, i64 0))
  br label %if.end96

if.end45:                                         ; preds = %if.end36
  %sub = add i32 %8, -1
  %idxprom46 = zext i32 %sub to i64
  %arrayidx47 = getelementptr inbounds [4 x %struct._cl_device_id*]* %devices, i64 0, i64 %idxprom46
  %9 = load %struct._cl_device_id** %arrayidx47, align 8, !tbaa !1
  store %struct._cl_device_id* %9, %struct._cl_device_id** %dev, align 8, !tbaa !1
  %arrayinit.begin = getelementptr inbounds [3 x i64]* %properties, i64 0, i64 0
  store i64 4228, i64* %arrayinit.begin, align 16, !tbaa !10
  %arrayinit.element = getelementptr inbounds [3 x i64]* %properties, i64 0, i64 1
  %10 = ptrtoint %struct._cl_platform_id* %platform.2 to i64
  store i64 %10, i64* %arrayinit.element, align 8, !tbaa !10
  %arrayinit.element48 = getelementptr inbounds [3 x i64]* %properties, i64 0, i64 2
  store i64 0, i64* %arrayinit.element48, align 16, !tbaa !10
  %call50 = call %struct._cl_context* @clCreateContext(i64* %arrayinit.begin, i32 1, %struct._cl_device_id** %dev, void (i8*, i8*, i64, i8*)* null, i8* null, i32* %err)
  %11 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  store %struct._cl_context* %call50, %struct._cl_context** %11, align 8, !tbaa !1
  %12 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %13 = load %struct._cl_command_queue** %12, align 8, !tbaa !1
  %tobool51 = icmp eq %struct._cl_command_queue* %13, null
  br i1 %tobool51, label %if.end53, label %if.then52

if.then52:                                        ; preds = %if.end45
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str9, i64 0, i64 0))
  br label %if.end53

if.end53:                                         ; preds = %if.end45, %if.then52
  %14 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %15 = load %struct._cl_context** %14, align 8, !tbaa !1
  %16 = load %struct._cl_device_id** %dev, align 8, !tbaa !1
  %call54 = call %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context* %15, %struct._cl_device_id* %16, i64 0, i32* %err)
  %17 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  store %struct._cl_command_queue* %call54, %struct._cl_command_queue** %17, align 8, !tbaa !1
  br label %if.end59

if.else55:                                        ; preds = %entry
  %call56 = call i32 @clRetainContext(%struct._cl_context* %1)
  %18 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %19 = load %struct._cl_command_queue** %18, align 8, !tbaa !1
  %call57 = call i32 @clRetainCommandQueue(%struct._cl_command_queue* %19)
  %20 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %21 = load %struct._cl_context** %20, align 8, !tbaa !1
  %22 = bitcast %struct._cl_device_id** %dev to i8*
  %call58 = call i32 @clGetContextInfo(%struct._cl_context* %21, i32 4225, i64 8, i8* %22, i64* null)
  br label %if.end59

if.end59:                                         ; preds = %if.else55, %if.end53
  %23 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %tobool60 = icmp eq %struct._cl_program* %23, null
  %cmp61 = icmp sgt i32 %size, 1
  %or.cond = and i1 %tobool60, %cmp61
  br i1 %or.cond, label %if.then62, label %if.end96

if.then62:                                        ; preds = %if.end59
  %arrayinit.begin64 = getelementptr inbounds [1 x %struct._cl_device_id*]* %devices63, i64 0, i64 0
  %24 = load %struct._cl_device_id** %dev, align 8, !tbaa !1
  store %struct._cl_device_id* %24, %struct._cl_device_id** %arrayinit.begin64, align 8, !tbaa !1
  %arrayinit.begin65 = getelementptr inbounds [1 x i64]* %lengths, i64 0, i64 0
  %conv = sext i32 %size to i64
  store i64 %conv, i64* %arrayinit.begin65, align 8, !tbaa !10
  %call66 = call i8* @strstr(i8* %src, i8* getelementptr inbounds ([13 x i8]* @.str10, i64 0, i64 0))
  %tobool67 = icmp eq i8* %call66, null
  br i1 %tobool67, label %if.else72, label %if.then68

if.then68:                                        ; preds = %if.then62
  %arrayinit.begin69 = getelementptr inbounds [1 x i8*]* %sources, i64 0, i64 0
  store i8* %src, i8** %arrayinit.begin69, align 8, !tbaa !1
  %25 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %26 = load %struct._cl_context** %25, align 8, !tbaa !1
  %call71 = call %struct._cl_program* @clCreateProgramWithSource(%struct._cl_context* %26, i32 1, i8** %arrayinit.begin69, i64* null, i32* %err)
  br label %if.end78

if.else72:                                        ; preds = %if.then62
  %arrayinit.begin73 = getelementptr inbounds [1 x i8*]* %binaries, i64 0, i64 0
  store i8* %src, i8** %arrayinit.begin73, align 8, !tbaa !1
  %27 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %28 = load %struct._cl_context** %27, align 8, !tbaa !1
  %call77 = call %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context* %28, i32 1, %struct._cl_device_id** %arrayinit.begin64, i64* %arrayinit.begin65, i8** %arrayinit.begin73, i32* null, i32* %err)
  br label %if.end78

if.end78:                                         ; preds = %if.else72, %if.then68
  %storemerge = phi %struct._cl_program* [ %call77, %if.else72 ], [ %call71, %if.then68 ]
  store %struct._cl_program* %storemerge, %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %call79 = call i32 @clBuildProgram(%struct._cl_program* %storemerge, i32 1, %struct._cl_device_id** %dev, i8* null, void (%struct._cl_program*, i8*)* null, i8* null)
  store i32 %call79, i32* %err, align 4, !tbaa !11
  %cmp80 = icmp eq i32 %call79, 0
  br i1 %cmp80, label %if.end96, label %if.then81

if.then81:                                        ; preds = %if.end78
  %29 = getelementptr inbounds [2048 x i8]* %buffer, i64 0, i64 0
  call void @llvm.lifetime.start(i64 2048, i8* %29) #3
  %call82 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str11, i64 0, i64 0), i32 %call79)
  %30 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %31 = load %struct._cl_device_id** %dev, align 8, !tbaa !1
  %call84 = call i32 @clGetProgramBuildInfo(%struct._cl_program* %30, %struct._cl_device_id* %31, i32 4483, i64 2048, i8* %29, i64* %len)
  %cmp85 = icmp eq i32 %call84, 0
  br i1 %cmp85, label %if.then86, label %if.else89

if.then86:                                        ; preds = %if.then81
  %call88 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str12, i64 0, i64 0), i8* %29)
  br label %if.end91

if.else89:                                        ; preds = %if.then81
  %call90 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([48 x i8]* @.str13, i64 0, i64 0))
  br label %if.end91

if.end91:                                         ; preds = %if.else89, %if.then86
  %32 = load i32* %err, align 4, !tbaa !11
  %cmp92 = icmp eq i32 %32, 0
  br i1 %cmp92, label %if.end96, label %if.then93

if.then93:                                        ; preds = %if.end91
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([18 x i8]* @.str14, i64 0, i64 0))
  br label %if.end96

if.end96:                                         ; preds = %if.end91, %if.then93, %if.end78, %if.end59, %if.then21, %if.then43
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

declare i32 @clGetDeviceIDs(%struct._cl_platform_id*, i64, i32, %struct._cl_device_id**, i32*) #1

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
  call void @halide_dev_sync(i8* %user_context)
  %0 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %tobool = icmp eq %struct._cl_program* %0, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %call = call i32 @clReleaseProgram(%struct._cl_program* %0)
  store %struct._cl_program* null, %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  store i32 0, i32* %refs, align 4, !tbaa !11
  %1 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %2 = load %struct._cl_context** %1, align 8, !tbaa !1
  %3 = bitcast i32* %refs to i8*
  %call1 = call i32 @clGetContextInfo(%struct._cl_context* %2, i32 4224, i64 4, i8* %3, i64* null)
  %4 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %5 = load %struct._cl_command_queue** %4, align 8, !tbaa !1
  %call2 = call i32 @clReleaseCommandQueue(%struct._cl_command_queue* %5)
  %6 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %7 = load %struct._cl_context** %6, align 8, !tbaa !1
  %call3 = call i32 @clReleaseContext(%struct._cl_context* %7)
  %8 = load i32* %refs, align 4, !tbaa !11
  %dec = add i32 %8, -1
  store i32 %dec, i32* %refs, align 4, !tbaa !11
  %cmp = icmp eq i32 %dec, 0
  br i1 %cmp, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  %9 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  store %struct._cl_context* null, %struct._cl_context** %9, align 8, !tbaa !1
  %10 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  store %struct._cl_command_queue* null, %struct._cl_command_queue** %10, align 8, !tbaa !1
  br label %if.end5

if.end5:                                          ; preds = %if.then4, %if.end
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
  br i1 %call, label %if.end9, label %if.then1

if.then1:                                         ; preds = %if.then
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i64 0, i64 0))
  br label %if.end9

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
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str19, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end2, %if.then6.i
  %10 = bitcast i32* %err.i to i8*
  call void @llvm.lifetime.start(i64 4, i8* %10)
  %11 = load %struct._cl_context*** @_Z6cl_ctx, align 8, !tbaa !1
  %12 = load %struct._cl_context** %11, align 8, !tbaa !1
  %call.i = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %12, i64 1, i64 %conv4.size.0.3.i, i8* null, i32* %err.i)
  %tobool.i16 = icmp eq %struct._cl_mem* %call.i, null
  br i1 %tobool.i16, label %if.then8, label %_Z12__dev_mallocPvm.exit

_Z12__dev_mallocPvm.exit:                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  call void @llvm.lifetime.end(i64 4, i8* %10)
  %13 = ptrtoint %struct._cl_mem* %call.i to i64
  store i64 %13, i64* %dev, align 8, !tbaa !5
  br label %if.end9

if.then8:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([2 x i8]* @.str18, i64 0, i64 0))
  call void @llvm.lifetime.end(i64 4, i8* %10)
  store i64 0, i64* %dev, align 8, !tbaa !5
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([9 x i8]* @.str15, i64 0, i64 0))
  br label %if.end9

if.end9:                                          ; preds = %_Z12__dev_mallocPvm.exit, %if.then, %if.then1, %if.then8
  ret void
}

; Function Attrs: uwtable
define weak void @halide_copy_to_dev(i8* %user_context, %struct.buffer_t* %buf) #0 {
entry:
  %host_dirty = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 6
  %0 = load i8* %host_dirty, align 1, !tbaa !13, !range !14
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.end10, label %if.then

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
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str16, i64 0, i64 0))
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
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str19, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then6.i
  %call4 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i64 0)
  br i1 %call4, label %if.end6, label %if.then5

if.then5:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([47 x i8]* @.str2, i64 0, i64 0))
  br label %if.end6

if.end6:                                          ; preds = %if.then5, %_Z10__buf_sizePvP8buffer_t.exit
  %12 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %13 = load %struct._cl_command_queue** %12, align 8, !tbaa !1
  %dev7 = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %14 = load i64* %dev7, align 8, !tbaa !5
  %15 = inttoptr i64 %14 to %struct._cl_mem*
  %16 = load i8** %host, align 8, !tbaa !15
  %call9 = tail call i32 @clEnqueueWriteBuffer(%struct._cl_command_queue* %13, %struct._cl_mem* %15, i32 1, i64 0, i64 %conv4.size.0.3.i, i8* %16, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  br label %if.end10

if.end10:                                         ; preds = %entry, %if.end6
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
  br i1 %tobool, label %if.end11, label %if.then

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
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([22 x i8]* @.str16, i64 0, i64 0))
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
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([5 x i8]* @.str19, i64 0, i64 0))
  br label %_Z10__buf_sizePvP8buffer_t.exit

_Z10__buf_sizePvP8buffer_t.exit:                  ; preds = %if.end, %if.then6.i
  %call5 = tail call zeroext i1 @halide_validate_dev_pointer(i8* %user_context, %struct.buffer_t* %buf, i64 %conv4.size.0.3.i)
  br i1 %call5, label %if.end7, label %if.then6

if.then6:                                         ; preds = %_Z10__buf_sizePvP8buffer_t.exit
  tail call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([53 x i8]* @.str17, i64 0, i64 0))
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %_Z10__buf_sizePvP8buffer_t.exit
  %14 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %15 = load %struct._cl_command_queue** %14, align 8, !tbaa !1
  %dev8 = getelementptr inbounds %struct.buffer_t* %buf, i64 0, i32 0
  %16 = load i64* %dev8, align 8, !tbaa !5
  %17 = inttoptr i64 %16 to %struct._cl_mem*
  %18 = load i8** %host, align 8, !tbaa !15
  %call10 = tail call i32 @clEnqueueReadBuffer(%struct._cl_command_queue* %15, %struct._cl_mem* %17, i32 1, i64 0, i64 %conv4.size.0.3.i, i8* %18, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  br label %if.end11

if.end11:                                         ; preds = %entry, %if.end7
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
  %1 = load %struct._cl_program** @_Z5__mod, align 8, !tbaa !1
  %call.i = call %struct._cl_kernel* @clCreateKernel(%struct._cl_program* %1, i8* %entry_name, i32* %err.i)
  call void @llvm.lifetime.end(i64 4, i8* %0)
  %arrayinit.begin = getelementptr inbounds [3 x i64]* %global_dim, i64 0, i64 0
  %mul = mul nsw i32 %threadsX, %blocksX
  %conv = sext i32 %mul to i64
  store i64 %conv, i64* %arrayinit.begin, align 16, !tbaa !10
  %arrayinit.element = getelementptr inbounds [3 x i64]* %global_dim, i64 0, i64 1
  %mul1 = mul nsw i32 %threadsY, %blocksY
  %conv2 = sext i32 %mul1 to i64
  store i64 %conv2, i64* %arrayinit.element, align 8, !tbaa !10
  %arrayinit.element3 = getelementptr inbounds [3 x i64]* %global_dim, i64 0, i64 2
  %mul4 = mul nsw i32 %threadsZ, %blocksZ
  %conv5 = sext i32 %mul4 to i64
  store i64 %conv5, i64* %arrayinit.element3, align 16, !tbaa !10
  %arrayinit.begin6 = getelementptr inbounds [3 x i64]* %local_dim, i64 0, i64 0
  %conv7 = sext i32 %threadsX to i64
  store i64 %conv7, i64* %arrayinit.begin6, align 16, !tbaa !10
  %arrayinit.element8 = getelementptr inbounds [3 x i64]* %local_dim, i64 0, i64 1
  %conv9 = sext i32 %threadsY to i64
  store i64 %conv9, i64* %arrayinit.element8, align 8, !tbaa !10
  %arrayinit.element10 = getelementptr inbounds [3 x i64]* %local_dim, i64 0, i64 2
  %conv11 = sext i32 %threadsZ to i64
  store i64 %conv11, i64* %arrayinit.element10, align 16, !tbaa !10
  %2 = load i64* %arg_sizes, align 8, !tbaa !10
  %cmp32 = icmp eq i64 %2, 0
  br i1 %cmp32, label %while.end, label %while.body

while.body:                                       ; preds = %entry, %while.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %while.body ], [ 0, %entry ]
  %3 = phi i64 [ %6, %while.body ], [ %2, %entry ]
  %i.033 = phi i32 [ %inc, %while.body ], [ 0, %entry ]
  %arrayidx15 = getelementptr inbounds i8** %args, i64 %indvars.iv
  %4 = load i8** %arrayidx15, align 8, !tbaa !1
  %5 = trunc i64 %indvars.iv to i32
  %call16 = call i32 @clSetKernelArg(%struct._cl_kernel* %call.i, i32 %5, i64 %3, i8* %4)
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %inc = add nsw i32 %i.033, 1
  %arrayidx = getelementptr inbounds i64* %arg_sizes, i64 %indvars.iv.next
  %6 = load i64* %arrayidx, align 8, !tbaa !10
  %cmp = icmp eq i64 %6, 0
  br i1 %cmp, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %entry
  %i.0.lcssa = phi i32 [ 0, %entry ], [ %inc, %while.body ]
  %cmp17 = icmp slt i32 %shared_mem_bytes, 1
  %7 = sext i32 %shared_mem_bytes to i64
  %conv18 = select i1 %cmp17, i64 1, i64 %7
  %call19 = call i32 @clSetKernelArg(%struct._cl_kernel* %call.i, i32 %i.0.lcssa, i64 %conv18, i8* null)
  %8 = load %struct._cl_command_queue*** @_Z4cl_q, align 8, !tbaa !1
  %9 = load %struct._cl_command_queue** %8, align 8, !tbaa !1
  %call21 = call i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue* %9, %struct._cl_kernel* %call.i, i32 3, i64* null, i64* %arrayinit.begin, i64* %arrayinit.begin6, i32 0, %struct._cl_event** null, %struct._cl_event** null)
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
