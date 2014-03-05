; ModuleID = 'src/runtime/tracing.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

@halide_custom_trace = weak global i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)* null, align 4
@halide_trace_file = weak global i8* null, align 4
@halide_trace_initialized = weak global i8 0, align 1
@_ZZ12halide_traceE3ids = internal global i32 1, align 4
@.str = private unnamed_addr constant [14 x i8] c"HL_TRACE_FILE\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"ab\00", align 1
@.str2 = private unnamed_addr constant [51 x i8] c"halide_trace_file && \22Failed to open trace file\5Cn\22\00", align 1
@.str3 = private unnamed_addr constant [50 x i8] c"total_bytes <= 4096 && \22Tracing packet too large\22\00", align 1
@.str4 = private unnamed_addr constant [54 x i8] c"written == total_bytes && \22Can't write to trace file\22\00", align 1
@.str5 = private unnamed_addr constant [39 x i8] c"print_bits <= 64 && \22Tracing bad type\22\00", align 1
@.str6 = private unnamed_addr constant [5 x i8] c"Load\00", align 1
@.str7 = private unnamed_addr constant [6 x i8] c"Store\00", align 1
@.str8 = private unnamed_addr constant [18 x i8] c"Begin realization\00", align 1
@.str9 = private unnamed_addr constant [16 x i8] c"End realization\00", align 1
@.str10 = private unnamed_addr constant [8 x i8] c"Produce\00", align 1
@.str11 = private unnamed_addr constant [7 x i8] c"Update\00", align 1
@.str12 = private unnamed_addr constant [8 x i8] c"Consume\00", align 1
@.str13 = private unnamed_addr constant [12 x i8] c"End consume\00", align 1
@_ZZ12halide_traceE11event_types = private unnamed_addr constant [8 x i8*] [i8* getelementptr inbounds ([5 x i8]* @.str6, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8]* @.str7, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8]* @.str8, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8]* @.str9, i32 0, i32 0), i8* getelementptr inbounds ([8 x i8]* @.str10, i32 0, i32 0), i8* getelementptr inbounds ([7 x i8]* @.str11, i32 0, i32 0), i8* getelementptr inbounds ([8 x i8]* @.str12, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8]* @.str13, i32 0, i32 0)], align 4
@.str14 = private unnamed_addr constant [10 x i8] c"%s %s.%d[\00", align 1
@.str15 = private unnamed_addr constant [2 x i8] c"<\00", align 1
@.str16 = private unnamed_addr constant [5 x i8] c">, <\00", align 1
@.str17 = private unnamed_addr constant [3 x i8] c", \00", align 1
@.str18 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str19 = private unnamed_addr constant [3 x i8] c">]\00", align 1
@.str20 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@.str21 = private unnamed_addr constant [5 x i8] c" = <\00", align 1
@.str22 = private unnamed_addr constant [4 x i8] c" = \00", align 1
@.str23 = private unnamed_addr constant [3 x i8] c"%u\00", align 1
@.str24 = private unnamed_addr constant [41 x i8] c"print_bits >= 32 && \22Tracing a bad type\22\00", align 1
@.str25 = private unnamed_addr constant [3 x i8] c"%f\00", align 1
@.str26 = private unnamed_addr constant [3 x i8] c"%p\00", align 1
@.str27 = private unnamed_addr constant [2 x i8] c">\00", align 1
@.str28 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

define weak void @halide_set_custom_trace(i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)* %t) #0 {
entry:
  store i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)* %t, i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)** @halide_custom_trace, align 4, !tbaa !1
  ret void
}

define weak i32 @halide_trace(i8* %user_context, i8* %func, i32 %event, i32 %parent_id, i32 %type_code, i32 %bits, i32 %width, i32 %value_idx, i8* %value, i32 %num_int_args, i32* %int_args) #0 {
entry:
  %0 = bitcast i32* %int_args to i8*
  %buffer = alloca [4096 x i8], align 4
  %buf = alloca [256 x i8], align 1
  %1 = load i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)** @halide_custom_trace, align 4, !tbaa !1
  %tobool = icmp eq i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)* %1, null
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %call = call i32 %1(i8* %user_context, i8* %func, i32 %event, i32 %parent_id, i32 %type_code, i32 %bits, i32 %width, i32 %value_idx, i8* %value, i32 %num_int_args, i32* %int_args)
  br label %return

if.else:                                          ; preds = %entry
  %2 = atomicrmw add i32* @_ZZ12halide_traceE3ids, i32 1 seq_cst
  %3 = load i8* @halide_trace_initialized, align 1, !tbaa !5, !range !7
  %tobool1 = icmp eq i8 %3, 0
  br i1 %tobool1, label %if.then2, label %if.end10

if.then2:                                         ; preds = %if.else
  %call3 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str, i32 0, i32 0))
  store i8 1, i8* @halide_trace_initialized, align 1, !tbaa !5
  %tobool4 = icmp eq i8* %call3, null
  br i1 %tobool4, label %if.end10, label %if.then5

if.then5:                                         ; preds = %if.then2
  %call6 = call i8* @fopen(i8* %call3, i8* getelementptr inbounds ([3 x i8]* @.str1, i32 0, i32 0))
  store i8* %call6, i8** @halide_trace_file, align 4, !tbaa !1
  %tobool7 = icmp eq i8* %call6, null
  br i1 %tobool7, label %if.then8, label %if.then12

if.then8:                                         ; preds = %if.then5
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([51 x i8]* @.str2, i32 0, i32 0))
  br label %if.end10

if.end10:                                         ; preds = %if.then2, %if.else, %if.then8
  %.pr = load i8** @halide_trace_file, align 4, !tbaa !1
  %tobool11 = icmp eq i8* %.pr, null
  br i1 %tobool11, label %if.else82, label %if.then12

if.then12:                                        ; preds = %if.then5, %if.end10
  %cmp = icmp sgt i32 %width, 255
  %4 = trunc i32 %width to i8
  %conv = select i1 %cmp, i8 -1, i8 %4
  %5 = trunc i32 %num_int_args to i8
  br label %while.cond

while.cond:                                       ; preds = %while.cond, %if.then12
  %bytes.0 = phi i32 [ 1, %if.then12 ], [ %shl, %while.cond ]
  %mul = shl nsw i32 %bytes.0, 3
  %cmp19 = icmp slt i32 %mul, %bits
  %shl = shl i32 %bytes.0, 1
  br i1 %cmp19, label %while.cond, label %while.end

while.end:                                        ; preds = %while.cond
  %cmp13 = icmp sgt i32 %num_int_args, 255
  %conv18 = select i1 %cmp13, i8 -1, i8 %5
  %conv20 = zext i8 %conv to i32
  %mul21 = mul i32 %bytes.0, %conv20
  %conv22 = zext i8 %conv18 to i32
  %mul23 = shl nuw nsw i32 %conv22, 2
  %add = add i32 %mul21, 32
  %add24 = add i32 %add, %mul23
  %6 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 0
  call void @llvm.lifetime.start(i64 4096, i8* %6) #3
  %cmp25 = icmp ult i32 %add24, 4097
  br i1 %cmp25, label %if.end27, label %if.then26

if.then26:                                        ; preds = %while.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([50 x i8]* @.str3, i32 0, i32 0))
  br label %if.end27

if.end27:                                         ; preds = %if.then26, %while.end
  %7 = bitcast [4096 x i8]* %buffer to i32*
  store i32 %2, i32* %7, align 4, !tbaa !8
  %arrayidx29 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 4
  %8 = bitcast i8* %arrayidx29 to i32*
  store i32 %parent_id, i32* %8, align 4, !tbaa !8
  %conv30 = trunc i32 %event to i8
  %arrayidx31 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 8
  store i8 %conv30, i8* %arrayidx31, align 4, !tbaa !10
  %conv32 = trunc i32 %type_code to i8
  %arrayidx33 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 9
  store i8 %conv32, i8* %arrayidx33, align 1, !tbaa !10
  %conv34 = trunc i32 %bits to i8
  %arrayidx35 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 10
  store i8 %conv34, i8* %arrayidx35, align 2, !tbaa !10
  %arrayidx36 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 11
  store i8 %conv, i8* %arrayidx36, align 1, !tbaa !10
  %conv37 = trunc i32 %value_idx to i8
  %arrayidx38 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 12
  store i8 %conv37, i8* %arrayidx38, align 4, !tbaa !10
  %arrayidx39 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 13
  store i8 %conv18, i8* %arrayidx39, align 1, !tbaa !10
  br label %for.body

for.cond:                                         ; preds = %for.body
  %cmp40 = icmp ult i32 %inc, 31
  br i1 %cmp40, label %for.body, label %for.cond49.preheader

for.cond49.preheader:                             ; preds = %for.body, %for.cond
  %i.0.lcssa = phi i32 [ %i.0539, %for.body ], [ %inc, %for.cond ]
  %cmp50537 = icmp ult i32 %i.0.lcssa, 32
  br i1 %cmp50537, label %for.body51.lr.ph, label %for.cond57.preheader

for.body51.lr.ph:                                 ; preds = %for.cond49.preheader
  %scevgep544 = getelementptr [4096 x i8]* %buffer, i32 0, i32 %i.0.lcssa
  %9 = sub i32 32, %i.0.lcssa
  call void @llvm.memset.p0i8.i32(i8* %scevgep544, i8 0, i32 %9, i32 1, i1 false)
  br label %for.cond57.preheader

for.body:                                         ; preds = %if.end27, %for.cond
  %i.0539 = phi i32 [ 14, %if.end27 ], [ %inc, %for.cond ]
  %sub41 = add nsw i32 %i.0539, -14
  %arrayidx42 = getelementptr inbounds i8* %func, i32 %sub41
  %10 = load i8* %arrayidx42, align 1, !tbaa !10
  %arrayidx43 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 %i.0539
  store i8 %10, i8* %arrayidx43, align 1, !tbaa !10
  %cmp46 = icmp eq i8 %10, 0
  %inc = add nsw i32 %i.0539, 1
  br i1 %cmp46, label %for.cond49.preheader, label %for.cond

for.cond57.preheader:                             ; preds = %for.body51.lr.ph, %for.cond49.preheader
  %cmp58535 = icmp eq i32 %mul21, 0
  br i1 %cmp58535, label %for.cond67.preheader, label %for.body59.lr.ph

for.body59.lr.ph:                                 ; preds = %for.cond57.preheader
  %scevgep543 = getelementptr [4096 x i8]* %buffer, i32 0, i32 32
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %scevgep543, i8* %value, i32 %mul21, i32 1, i1 false)
  br label %for.cond67.preheader

for.cond67.preheader:                             ; preds = %for.cond57.preheader, %for.body59.lr.ph
  %cmp68533 = icmp eq i8 %conv18, 0
  br i1 %cmp68533, label %for.end76, label %for.body69.lr.ph

for.body69.lr.ph:                                 ; preds = %for.cond67.preheader
  %scevgep.sum = add i32 %mul21, 32
  %scevgep542 = getelementptr [4096 x i8]* %buffer, i32 0, i32 %scevgep.sum
  %11 = shl nuw nsw i32 %conv22, 2
  %12 = icmp ugt i32 %11, 1
  %umax = select i1 %12, i32 %11, i32 1
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %scevgep542, i8* %0, i32 %umax, i32 1, i1 false)
  br label %for.end76

for.end76:                                        ; preds = %for.cond67.preheader, %for.body69.lr.ph
  %13 = load i8** @halide_trace_file, align 4, !tbaa !1
  %call78 = call i32 @fwrite(i8* %6, i32 1, i32 %add24, i8* %13)
  %cmp79 = icmp eq i32 %call78, %add24
  br i1 %cmp79, label %return, label %if.then80

if.then80:                                        ; preds = %for.end76
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([54 x i8]* @.str4, i32 0, i32 0))
  br label %return

if.else82:                                        ; preds = %if.end10
  %14 = getelementptr inbounds [256 x i8]* %buf, i32 0, i32 0
  call void @llvm.lifetime.start(i64 256, i8* %14) #3
  br label %while.cond85

while.cond85:                                     ; preds = %while.cond85, %if.else82
  %print_bits.0 = phi i32 [ 8, %if.else82 ], [ %shl88, %while.cond85 ]
  %cmp86 = icmp slt i32 %print_bits.0, %bits
  %shl88 = shl i32 %print_bits.0, 1
  br i1 %cmp86, label %while.cond85, label %while.end89

while.end89:                                      ; preds = %while.cond85
  %arrayidx84 = getelementptr inbounds [256 x i8]* %buf, i32 0, i32 255
  %cmp90 = icmp slt i32 %print_bits.0, 65
  br i1 %cmp90, label %if.end92, label %if.then91

if.then91:                                        ; preds = %while.end89
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([39 x i8]* @.str5, i32 0, i32 0))
  br label %if.end92

if.end92:                                         ; preds = %if.then91, %while.end89
  %cmp93 = icmp slt i32 %event, 2
  %arrayidx96 = getelementptr inbounds [8 x i8*]* @_ZZ12halide_traceE11event_types, i32 0, i32 %event
  %15 = load i8** %arrayidx96, align 4, !tbaa !1
  %call97 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %14, i32 255, i8* getelementptr inbounds ([10 x i8]* @.str14, i32 0, i32 0), i8* %15, i8* %func, i32 %value_idx)
  %add.ptr = getelementptr inbounds [256 x i8]* %buf, i32 0, i32 %call97
  %cmp99 = icmp sgt i32 %width, 1
  br i1 %cmp99, label %if.then100, label %for.cond108.preheader

if.then100:                                       ; preds = %if.end92
  %16 = sub i32 255, %call97
  %call104 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %add.ptr, i32 %16, i8* getelementptr inbounds ([2 x i8]* @.str15, i32 0, i32 0))
  %add.ptr.sum = add i32 %call104, %call97
  %add.ptr105 = getelementptr inbounds [256 x i8]* %buf, i32 0, i32 %add.ptr.sum
  br label %for.cond108.preheader

for.cond108.preheader:                            ; preds = %if.then100, %if.end92
  %buf_ptr.2.ph = phi i8* [ %add.ptr, %if.end92 ], [ %add.ptr105, %if.then100 ]
  %cmp109526 = icmp sgt i32 %num_int_args, 0
  %cmp110527 = icmp ult i8* %buf_ptr.2.ph, %arrayidx84
  %or.cond528 = and i1 %cmp109526, %cmp110527
  br i1 %or.cond528, label %for.body111.lr.ph, label %for.end138

for.body111.lr.ph:                                ; preds = %for.cond108.preheader
  %sub.ptr.lhs.cast117 = ptrtoint i8* %arrayidx84 to i32
  br i1 %cmp99, label %for.body111.us, label %for.body111

for.body111.us:                                   ; preds = %for.body111.lr.ph, %if.end129.us
  %i107.0530.us = phi i32 [ %inc137.us, %if.end129.us ], [ 0, %for.body111.lr.ph ]
  %buf_ptr.2529.us = phi i8* [ %add.ptr135.us, %if.end129.us ], [ %buf_ptr.2.ph, %for.body111.lr.ph ]
  %cmp112.us = icmp sgt i32 %i107.0530.us, 0
  br i1 %cmp112.us, label %land.lhs.true.us, label %if.end129.us

land.lhs.true.us:                                 ; preds = %for.body111.us
  %rem.us = srem i32 %i107.0530.us, %width
  %cmp115.us = icmp eq i32 %rem.us, 0
  %sub.ptr.rhs.cast118.us = ptrtoint i8* %buf_ptr.2529.us to i32
  %sub.ptr.sub119.us = sub i32 %sub.ptr.lhs.cast117, %sub.ptr.rhs.cast118.us
  br i1 %cmp115.us, label %if.then116.us, label %if.else122.us

if.else122.us:                                    ; preds = %land.lhs.true.us
  %call126.us = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.2529.us, i32 %sub.ptr.sub119.us, i8* getelementptr inbounds ([3 x i8]* @.str17, i32 0, i32 0))
  %add.ptr127.us = getelementptr inbounds i8* %buf_ptr.2529.us, i32 %call126.us
  br label %if.end129.us

if.then116.us:                                    ; preds = %land.lhs.true.us
  %call120.us = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.2529.us, i32 %sub.ptr.sub119.us, i8* getelementptr inbounds ([5 x i8]* @.str16, i32 0, i32 0))
  %add.ptr121.us = getelementptr inbounds i8* %buf_ptr.2529.us, i32 %call120.us
  br label %if.end129.us

if.end129.us:                                     ; preds = %if.then116.us, %if.else122.us, %for.body111.us
  %buf_ptr.3.us = phi i8* [ %add.ptr121.us, %if.then116.us ], [ %add.ptr127.us, %if.else122.us ], [ %buf_ptr.2529.us, %for.body111.us ]
  %sub.ptr.rhs.cast131.us = ptrtoint i8* %buf_ptr.3.us to i32
  %sub.ptr.sub132.us = sub i32 %sub.ptr.lhs.cast117, %sub.ptr.rhs.cast131.us
  %arrayidx133.us = getelementptr inbounds i32* %int_args, i32 %i107.0530.us
  %17 = load i32* %arrayidx133.us, align 4, !tbaa !8
  %call134.us = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.3.us, i32 %sub.ptr.sub132.us, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %17)
  %add.ptr135.us = getelementptr inbounds i8* %buf_ptr.3.us, i32 %call134.us
  %inc137.us = add nsw i32 %i107.0530.us, 1
  %cmp109.us = icmp slt i32 %inc137.us, %num_int_args
  %cmp110.us = icmp ult i8* %add.ptr135.us, %arrayidx84
  %or.cond.us = and i1 %cmp109.us, %cmp110.us
  br i1 %or.cond.us, label %for.body111.us, label %for.end138

for.body111:                                      ; preds = %for.body111.lr.ph, %if.end129
  %i107.0530 = phi i32 [ %inc137, %if.end129 ], [ 0, %for.body111.lr.ph ]
  %buf_ptr.2529 = phi i8* [ %add.ptr135, %if.end129 ], [ %buf_ptr.2.ph, %for.body111.lr.ph ]
  %cmp112 = icmp sgt i32 %i107.0530, 0
  br i1 %cmp112, label %if.else122, label %if.end129

if.else122:                                       ; preds = %for.body111
  %sub.ptr.rhs.cast124 = ptrtoint i8* %buf_ptr.2529 to i32
  %sub.ptr.sub125 = sub i32 %sub.ptr.lhs.cast117, %sub.ptr.rhs.cast124
  %call126 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.2529, i32 %sub.ptr.sub125, i8* getelementptr inbounds ([3 x i8]* @.str17, i32 0, i32 0))
  %add.ptr127 = getelementptr inbounds i8* %buf_ptr.2529, i32 %call126
  br label %if.end129

if.end129:                                        ; preds = %if.else122, %for.body111
  %buf_ptr.3 = phi i8* [ %add.ptr127, %if.else122 ], [ %buf_ptr.2529, %for.body111 ]
  %sub.ptr.rhs.cast131 = ptrtoint i8* %buf_ptr.3 to i32
  %sub.ptr.sub132 = sub i32 %sub.ptr.lhs.cast117, %sub.ptr.rhs.cast131
  %arrayidx133 = getelementptr inbounds i32* %int_args, i32 %i107.0530
  %18 = load i32* %arrayidx133, align 4, !tbaa !8
  %call134 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.3, i32 %sub.ptr.sub132, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %18)
  %add.ptr135 = getelementptr inbounds i8* %buf_ptr.3, i32 %call134
  %inc137 = add nsw i32 %i107.0530, 1
  %cmp109 = icmp slt i32 %inc137, %num_int_args
  %cmp110 = icmp ult i8* %add.ptr135, %arrayidx84
  %or.cond = and i1 %cmp109, %cmp110
  br i1 %or.cond, label %for.body111, label %for.end138

for.end138:                                       ; preds = %if.end129, %if.end129.us, %for.cond108.preheader
  %cmp110.lcssa = phi i1 [ %cmp110527, %for.cond108.preheader ], [ %cmp110.us, %if.end129.us ], [ %cmp110, %if.end129 ]
  %buf_ptr.2.lcssa = phi i8* [ %buf_ptr.2.ph, %for.cond108.preheader ], [ %add.ptr135.us, %if.end129.us ], [ %add.ptr135, %if.end129 ]
  br i1 %cmp110.lcssa, label %if.then140, label %if.end155

if.then140:                                       ; preds = %for.end138
  %sub.ptr.lhs.cast143 = ptrtoint i8* %arrayidx84 to i32
  %sub.ptr.rhs.cast144 = ptrtoint i8* %buf_ptr.2.lcssa to i32
  %sub.ptr.sub145 = sub i32 %sub.ptr.lhs.cast143, %sub.ptr.rhs.cast144
  br i1 %cmp99, label %if.then142, label %if.else148

if.then142:                                       ; preds = %if.then140
  %call146 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.2.lcssa, i32 %sub.ptr.sub145, i8* getelementptr inbounds ([3 x i8]* @.str19, i32 0, i32 0))
  %add.ptr147 = getelementptr inbounds i8* %buf_ptr.2.lcssa, i32 %call146
  br label %if.end155

if.else148:                                       ; preds = %if.then140
  %call152 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.2.lcssa, i32 %sub.ptr.sub145, i8* getelementptr inbounds ([2 x i8]* @.str20, i32 0, i32 0))
  %add.ptr153 = getelementptr inbounds i8* %buf_ptr.2.lcssa, i32 %call152
  br label %if.end155

if.end155:                                        ; preds = %if.then142, %if.else148, %for.end138
  %buf_ptr.4 = phi i8* [ %add.ptr147, %if.then142 ], [ %add.ptr153, %if.else148 ], [ %buf_ptr.2.lcssa, %for.end138 ]
  br i1 %cmp93, label %if.then157, label %if.end325

if.then157:                                       ; preds = %if.end155
  %cmp158 = icmp ult i8* %buf_ptr.4, %arrayidx84
  br i1 %cmp158, label %if.then159, label %for.cond176.preheader

if.then159:                                       ; preds = %if.then157
  %sub.ptr.lhs.cast162 = ptrtoint i8* %arrayidx84 to i32
  %sub.ptr.rhs.cast163 = ptrtoint i8* %buf_ptr.4 to i32
  %sub.ptr.sub164 = sub i32 %sub.ptr.lhs.cast162, %sub.ptr.rhs.cast163
  br i1 %cmp99, label %if.then161, label %if.else167

if.then161:                                       ; preds = %if.then159
  %call165 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.4, i32 %sub.ptr.sub164, i8* getelementptr inbounds ([5 x i8]* @.str21, i32 0, i32 0))
  %add.ptr166 = getelementptr inbounds i8* %buf_ptr.4, i32 %call165
  br label %for.cond176.preheader

if.else167:                                       ; preds = %if.then159
  %call171 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.4, i32 %sub.ptr.sub164, i8* getelementptr inbounds ([4 x i8]* @.str22, i32 0, i32 0))
  %add.ptr172 = getelementptr inbounds i8* %buf_ptr.4, i32 %call171
  br label %for.cond176.preheader

for.cond176.preheader:                            ; preds = %if.then161, %if.else167, %if.then157
  %buf_ptr.6.ph = phi i8* [ %buf_ptr.4, %if.then157 ], [ %add.ptr172, %if.else167 ], [ %add.ptr166, %if.then161 ]
  %cmp177519 = icmp sgt i32 %width, 0
  %cmp179520 = icmp ult i8* %buf_ptr.6.ph, %arrayidx84
  %or.cond511521 = and i1 %cmp177519, %cmp179520
  br i1 %or.cond511521, label %for.body181.lr.ph, label %for.end314

for.body181.lr.ph:                                ; preds = %for.cond176.preheader
  %sub.ptr.lhs.cast184 = ptrtoint i8* %arrayidx84 to i32
  %cmp212 = icmp eq i32 %print_bits.0, 32
  %19 = bitcast i8* %value to i32*
  %20 = bitcast i8* %value to i64*
  %21 = bitcast i8* %value to i16*
  %cmp279 = icmp sgt i32 %print_bits.0, 31
  %22 = bitcast i8* %value to float*
  %23 = bitcast i8* %value to double*
  %24 = bitcast i8* %value to i8**
  br label %for.body181

for.body181:                                      ; preds = %for.body181.lr.ph, %for.inc312
  %i175.0523 = phi i32 [ 0, %for.body181.lr.ph ], [ %inc313, %for.inc312 ]
  %buf_ptr.6522 = phi i8* [ %buf_ptr.6.ph, %for.body181.lr.ph ], [ %buf_ptr.8, %for.inc312 ]
  %cmp182 = icmp sgt i32 %i175.0523, 0
  br i1 %cmp182, label %if.then183, label %if.end189

if.then183:                                       ; preds = %for.body181
  %sub.ptr.rhs.cast185 = ptrtoint i8* %buf_ptr.6522 to i32
  %sub.ptr.sub186 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast185
  %call187 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.6522, i32 %sub.ptr.sub186, i8* getelementptr inbounds ([3 x i8]* @.str17, i32 0, i32 0))
  %add.ptr188 = getelementptr inbounds i8* %buf_ptr.6522, i32 %call187
  br label %if.end189

if.end189:                                        ; preds = %if.then183, %for.body181
  %buf_ptr.7 = phi i8* [ %add.ptr188, %if.then183 ], [ %buf_ptr.6522, %for.body181 ]
  switch i32 %type_code, label %for.inc312 [
    i32 0, label %if.then191
    i32 1, label %if.then233
    i32 2, label %if.then278
    i32 3, label %if.then301
  ]

if.then191:                                       ; preds = %if.end189
  switch i32 %print_bits.0, label %if.else211 [
    i32 8, label %if.then193
    i32 16, label %if.then203
  ]

if.then193:                                       ; preds = %if.then191
  %sub.ptr.rhs.cast195 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub196 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast195
  %arrayidx197 = getelementptr inbounds i8* %value, i32 %i175.0523
  %25 = load i8* %arrayidx197, align 1, !tbaa !10
  %conv198 = sext i8 %25 to i32
  %call199 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub196, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %conv198)
  %add.ptr200 = getelementptr inbounds i8* %buf_ptr.7, i32 %call199
  br label %for.inc312

if.then203:                                       ; preds = %if.then191
  %sub.ptr.rhs.cast205 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub206 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast205
  %arrayidx207 = getelementptr inbounds i16* %21, i32 %i175.0523
  %26 = load i16* %arrayidx207, align 2, !tbaa !11
  %conv208 = sext i16 %26 to i32
  %call209 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub206, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %conv208)
  %add.ptr210 = getelementptr inbounds i8* %buf_ptr.7, i32 %call209
  br label %for.inc312

if.else211:                                       ; preds = %if.then191
  %sub.ptr.rhs.cast215 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub216 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast215
  br i1 %cmp212, label %if.then213, label %if.else220

if.then213:                                       ; preds = %if.else211
  %arrayidx217 = getelementptr inbounds i32* %19, i32 %i175.0523
  %27 = load i32* %arrayidx217, align 4, !tbaa !8
  %call218 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub216, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %27)
  %add.ptr219 = getelementptr inbounds i8* %buf_ptr.7, i32 %call218
  br label %for.inc312

if.else220:                                       ; preds = %if.else211
  %arrayidx224 = getelementptr inbounds i64* %20, i32 %i175.0523
  %28 = load i64* %arrayidx224, align 4, !tbaa !13
  %conv225 = trunc i64 %28 to i32
  %call226 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub216, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %conv225)
  %add.ptr227 = getelementptr inbounds i8* %buf_ptr.7, i32 %call226
  br label %for.inc312

if.then233:                                       ; preds = %if.end189
  switch i32 %print_bits.0, label %if.else256 [
    i32 8, label %if.then235
    i32 16, label %if.then248
  ]

if.then235:                                       ; preds = %if.then233
  %sub.ptr.rhs.cast237 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub238 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast237
  %arrayidx239 = getelementptr inbounds i8* %value, i32 %i175.0523
  %29 = load i8* %arrayidx239, align 1, !tbaa !10
  %conv240 = zext i8 %29 to i32
  %call241 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub238, i8* getelementptr inbounds ([3 x i8]* @.str23, i32 0, i32 0), i32 %conv240)
  %add.ptr242 = getelementptr inbounds i8* %buf_ptr.7, i32 %call241
  %cmp243 = icmp ugt i8* %add.ptr242, %arrayidx84
  %arrayidx84.add.ptr242 = select i1 %cmp243, i8* %arrayidx84, i8* %add.ptr242
  br label %for.inc312

if.then248:                                       ; preds = %if.then233
  %sub.ptr.rhs.cast250 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub251 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast250
  %arrayidx252 = getelementptr inbounds i16* %21, i32 %i175.0523
  %30 = load i16* %arrayidx252, align 2, !tbaa !11
  %conv253 = zext i16 %30 to i32
  %call254 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub251, i8* getelementptr inbounds ([3 x i8]* @.str23, i32 0, i32 0), i32 %conv253)
  %add.ptr255 = getelementptr inbounds i8* %buf_ptr.7, i32 %call254
  br label %for.inc312

if.else256:                                       ; preds = %if.then233
  %sub.ptr.rhs.cast260 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub261 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast260
  br i1 %cmp212, label %if.then258, label %if.else265

if.then258:                                       ; preds = %if.else256
  %arrayidx262 = getelementptr inbounds i32* %19, i32 %i175.0523
  %31 = load i32* %arrayidx262, align 4, !tbaa !8
  %call263 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub261, i8* getelementptr inbounds ([3 x i8]* @.str23, i32 0, i32 0), i32 %31)
  %add.ptr264 = getelementptr inbounds i8* %buf_ptr.7, i32 %call263
  br label %for.inc312

if.else265:                                       ; preds = %if.else256
  %arrayidx269 = getelementptr inbounds i64* %20, i32 %i175.0523
  %32 = load i64* %arrayidx269, align 4, !tbaa !13
  %conv270 = trunc i64 %32 to i32
  %call271 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub261, i8* getelementptr inbounds ([3 x i8]* @.str23, i32 0, i32 0), i32 %conv270)
  %add.ptr272 = getelementptr inbounds i8* %buf_ptr.7, i32 %call271
  br label %for.inc312

if.then278:                                       ; preds = %if.end189
  br i1 %cmp279, label %if.end281, label %if.end281.thread

if.end281.thread:                                 ; preds = %if.then278
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([41 x i8]* @.str24, i32 0, i32 0))
  %sub.ptr.rhs.cast285516 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub286517 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast285516
  br label %if.else291

if.end281:                                        ; preds = %if.then278
  %sub.ptr.rhs.cast285 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub286 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast285
  br i1 %cmp212, label %if.then283, label %if.else291

if.then283:                                       ; preds = %if.end281
  %arrayidx287 = getelementptr inbounds float* %22, i32 %i175.0523
  %33 = load float* %arrayidx287, align 4, !tbaa !15
  %conv288 = fpext float %33 to double
  %call289 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub286, i8* getelementptr inbounds ([3 x i8]* @.str25, i32 0, i32 0), double %conv288)
  %add.ptr290 = getelementptr inbounds i8* %buf_ptr.7, i32 %call289
  br label %for.inc312

if.else291:                                       ; preds = %if.end281.thread, %if.end281
  %sub.ptr.sub286518 = phi i32 [ %sub.ptr.sub286517, %if.end281.thread ], [ %sub.ptr.sub286, %if.end281 ]
  %arrayidx295 = getelementptr inbounds double* %23, i32 %i175.0523
  %34 = load double* %arrayidx295, align 4, !tbaa !17
  %call296 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub286518, i8* getelementptr inbounds ([3 x i8]* @.str25, i32 0, i32 0), double %34)
  %add.ptr297 = getelementptr inbounds i8* %buf_ptr.7, i32 %call296
  br label %for.inc312

if.then301:                                       ; preds = %if.end189
  %sub.ptr.rhs.cast303 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub304 = sub i32 %sub.ptr.lhs.cast184, %sub.ptr.rhs.cast303
  %arrayidx305 = getelementptr inbounds i8** %24, i32 %i175.0523
  %35 = load i8** %arrayidx305, align 4, !tbaa !1
  %call306 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub304, i8* getelementptr inbounds ([3 x i8]* @.str26, i32 0, i32 0), i8* %35)
  %add.ptr307 = getelementptr inbounds i8* %buf_ptr.7, i32 %call306
  br label %for.inc312

for.inc312:                                       ; preds = %if.then235, %if.end189, %if.then203, %if.else220, %if.then213, %if.then193, %if.else291, %if.then283, %if.then301, %if.then258, %if.else265, %if.then248
  %buf_ptr.8 = phi i8* [ %add.ptr200, %if.then193 ], [ %add.ptr210, %if.then203 ], [ %add.ptr219, %if.then213 ], [ %add.ptr227, %if.else220 ], [ %add.ptr255, %if.then248 ], [ %add.ptr264, %if.then258 ], [ %add.ptr272, %if.else265 ], [ %add.ptr290, %if.then283 ], [ %add.ptr297, %if.else291 ], [ %add.ptr307, %if.then301 ], [ %arrayidx84.add.ptr242, %if.then235 ], [ %buf_ptr.7, %if.end189 ]
  %inc313 = add nsw i32 %i175.0523, 1
  %cmp177 = icmp slt i32 %inc313, %width
  %cmp179 = icmp ult i8* %buf_ptr.8, %arrayidx84
  %or.cond511 = and i1 %cmp177, %cmp179
  br i1 %or.cond511, label %for.body181, label %for.end314

for.end314:                                       ; preds = %for.inc312, %for.cond176.preheader
  %cmp179.lcssa = phi i1 [ %cmp179520, %for.cond176.preheader ], [ %cmp179, %for.inc312 ]
  %buf_ptr.6.lcssa = phi i8* [ %buf_ptr.6.ph, %for.cond176.preheader ], [ %buf_ptr.8, %for.inc312 ]
  %or.cond512 = and i1 %cmp99, %cmp179.lcssa
  br i1 %or.cond512, label %if.then318, label %if.end325

if.then318:                                       ; preds = %for.end314
  %sub.ptr.lhs.cast319 = ptrtoint i8* %arrayidx84 to i32
  %sub.ptr.rhs.cast320 = ptrtoint i8* %buf_ptr.6.lcssa to i32
  %sub.ptr.sub321 = sub i32 %sub.ptr.lhs.cast319, %sub.ptr.rhs.cast320
  %call322 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.6.lcssa, i32 %sub.ptr.sub321, i8* getelementptr inbounds ([2 x i8]* @.str27, i32 0, i32 0))
  br label %if.end325

if.end325:                                        ; preds = %for.end314, %if.then318, %if.end155
  %call327 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([4 x i8]* @.str28, i32 0, i32 0), i8* %14)
  call void @llvm.lifetime.end(i64 256, i8* %14) #3
  br label %return

return:                                           ; preds = %if.end325, %if.then80, %for.end76, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ %2, %for.end76 ], [ %2, %if.then80 ], [ %2, %if.end325 ]
  ret i32 %retval.0
}

; Function Attrs: nounwind readonly
declare i8* @getenv(i8* nocapture) #1

; Function Attrs: nounwind
declare noalias i8* @fopen(i8* nocapture readonly, i8* nocapture readonly) #2

declare void @halide_error(i8*, i8*) #0

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #3

; Function Attrs: nounwind
declare i32 @fwrite(i8* nocapture, i32, i32, i8* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #3

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture readonly, i32, i32, i1) #3

; Function Attrs: nounwind
declare i32 @snprintf(i8* nocapture, i32, i8* nocapture readonly, ...) #2

declare i32 @halide_printf(i8*, i8*, ...) #0

define weak i32 @halide_shutdown_trace() #0 {
entry:
  %0 = load i8** @halide_trace_file, align 4, !tbaa !1
  %tobool = icmp eq i8* %0, null
  br i1 %tobool, label %return, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call i32 @fclose(i8* %0)
  store i8* null, i8** @halide_trace_file, align 4, !tbaa !1
  store i8 0, i8* @halide_trace_initialized, align 1, !tbaa !5
  br label %return

return:                                           ; preds = %entry, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ 0, %entry ]
  ret i32 %retval.0
}

; Function Attrs: nounwind
declare i32 @fclose(i8* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) #3

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"bool", metadata !3, i64 0}
!7 = metadata !{i8 0, i8 2}
!8 = metadata !{metadata !9, metadata !9, i64 0}
!9 = metadata !{metadata !"int", metadata !3, i64 0}
!10 = metadata !{metadata !3, metadata !3, i64 0}
!11 = metadata !{metadata !12, metadata !12, i64 0}
!12 = metadata !{metadata !"short", metadata !3, i64 0}
!13 = metadata !{metadata !14, metadata !14, i64 0}
!14 = metadata !{metadata !"long long", metadata !3, i64 0}
!15 = metadata !{metadata !16, metadata !16, i64 0}
!16 = metadata !{metadata !"float", metadata !3, i64 0}
!17 = metadata !{metadata !18, metadata !18, i64 0}
!18 = metadata !{metadata !"double", metadata !3, i64 0}
