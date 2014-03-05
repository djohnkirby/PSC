; ModuleID = 'src/runtime/tracing.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%struct.halide_trace_event = type { i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32* }

@halide_custom_trace = weak global i32 (i8*, %struct.halide_trace_event*)* null, align 4
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

define weak void @halide_set_custom_trace(i32 (i8*, %struct.halide_trace_event*)* %t) #0 {
entry:
  store i32 (i8*, %struct.halide_trace_event*)* %t, i32 (i8*, %struct.halide_trace_event*)** @halide_custom_trace, align 4, !tbaa !1
  ret void
}

define weak i32 @halide_trace(i8* %user_context, %struct.halide_trace_event* %e) #0 {
entry:
  %buffer = alloca [4096 x i8], align 4
  %buf = alloca [256 x i8], align 1
  %0 = load i32 (i8*, %struct.halide_trace_event*)** @halide_custom_trace, align 4, !tbaa !1
  %tobool = icmp eq i32 (i8*, %struct.halide_trace_event*)* %0, null
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %call = call i32 %0(i8* %user_context, %struct.halide_trace_event* %e)
  br label %return

if.else:                                          ; preds = %entry
  %1 = atomicrmw add i32* @_ZZ12halide_traceE3ids, i32 1 seq_cst
  %2 = load i8* @halide_trace_initialized, align 1, !tbaa !5, !range !7
  %tobool1 = icmp eq i8 %2, 0
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
  br i1 %tobool11, label %if.else85, label %if.then12

if.then12:                                        ; preds = %if.then5, %if.end10
  %vector_width = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 5
  %3 = load i32* %vector_width, align 4, !tbaa !8
  %phitmp = trunc i32 %3 to i8
  %dimensions = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 8
  %4 = load i32* %dimensions, align 4, !tbaa !12
  %phitmp543 = trunc i32 %4 to i8
  %bits = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 4
  %5 = load i32* %bits, align 4, !tbaa !13
  br label %while.cond

while.cond:                                       ; preds = %while.cond, %if.then12
  %bytes.0 = phi i32 [ %shl, %while.cond ], [ 1, %if.then12 ]
  %mul = shl nsw i32 %bytes.0, 3
  %cmp21 = icmp slt i32 %mul, %5
  %shl = shl i32 %bytes.0, 1
  br i1 %cmp21, label %while.cond, label %while.end

while.end:                                        ; preds = %while.cond
  %cmp = icmp slt i32 %3, 256
  %phitmp. = select i1 %cmp, i8 %phitmp, i8 -1
  %cmp14 = icmp slt i32 %4, 256
  %cond19 = select i1 %cmp14, i8 %phitmp543, i8 -1
  %conv22 = zext i8 %phitmp. to i32
  %mul23 = mul i32 %bytes.0, %conv22
  %conv24 = zext i8 %cond19 to i32
  %mul25 = shl nuw nsw i32 %conv24, 2
  %add = add i32 %mul23, 32
  %add26 = add i32 %add, %mul25
  %6 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 0
  call void @llvm.lifetime.start(i64 4096, i8* %6) #3
  %cmp27 = icmp ult i32 %add26, 4097
  br i1 %cmp27, label %if.end29, label %if.then28

if.then28:                                        ; preds = %while.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([50 x i8]* @.str3, i32 0, i32 0))
  %.pre = load i32* %bits, align 4, !tbaa !13
  br label %if.end29

if.end29:                                         ; preds = %if.then28, %while.end
  %7 = phi i32 [ %.pre, %if.then28 ], [ %5, %while.end ]
  %8 = bitcast [4096 x i8]* %buffer to i32*
  store i32 %1, i32* %8, align 4, !tbaa !14
  %parent_id = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 2
  %9 = load i32* %parent_id, align 4, !tbaa !15
  %arrayidx31 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 4
  %10 = bitcast i8* %arrayidx31 to i32*
  store i32 %9, i32* %10, align 4, !tbaa !14
  %event = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 1
  %11 = load i32* %event, align 4, !tbaa !16
  %conv32 = trunc i32 %11 to i8
  %arrayidx33 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 8
  store i8 %conv32, i8* %arrayidx33, align 4, !tbaa !17
  %type_code = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 3
  %12 = load i32* %type_code, align 4, !tbaa !18
  %conv34 = trunc i32 %12 to i8
  %arrayidx35 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 9
  store i8 %conv34, i8* %arrayidx35, align 1, !tbaa !17
  %conv37 = trunc i32 %7 to i8
  %arrayidx38 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 10
  store i8 %conv37, i8* %arrayidx38, align 2, !tbaa !17
  %arrayidx39 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 11
  store i8 %phitmp., i8* %arrayidx39, align 1, !tbaa !17
  %value_index = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 6
  %13 = load i32* %value_index, align 4, !tbaa !19
  %conv40 = trunc i32 %13 to i8
  %arrayidx41 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 12
  store i8 %conv40, i8* %arrayidx41, align 4, !tbaa !17
  %arrayidx42 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 13
  store i8 %cond19, i8* %arrayidx42, align 1, !tbaa !17
  %func = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 0
  %14 = load i8** %func, align 4, !tbaa !20
  br label %for.body

for.cond:                                         ; preds = %for.body
  %cmp43 = icmp ult i32 %inc, 31
  br i1 %cmp43, label %for.body, label %for.cond52.preheader

for.cond52.preheader:                             ; preds = %for.body, %for.cond
  %i.0.lcssa = phi i32 [ %i.0574, %for.body ], [ %inc, %for.cond ]
  %cmp53572 = icmp ult i32 %i.0.lcssa, 32
  br i1 %cmp53572, label %for.body54.lr.ph, label %for.cond60.preheader

for.body54.lr.ph:                                 ; preds = %for.cond52.preheader
  %scevgep580 = getelementptr [4096 x i8]* %buffer, i32 0, i32 %i.0.lcssa
  %15 = sub i32 32, %i.0.lcssa
  call void @llvm.memset.p0i8.i32(i8* %scevgep580, i8 0, i32 %15, i32 1, i1 false)
  br label %for.cond60.preheader

for.body:                                         ; preds = %if.end29, %for.cond
  %i.0574 = phi i32 [ 14, %if.end29 ], [ %inc, %for.cond ]
  %sub44 = add nsw i32 %i.0574, -14
  %arrayidx45 = getelementptr inbounds i8* %14, i32 %sub44
  %16 = load i8* %arrayidx45, align 1, !tbaa !17
  %arrayidx46 = getelementptr inbounds [4096 x i8]* %buffer, i32 0, i32 %i.0574
  store i8 %16, i8* %arrayidx46, align 1, !tbaa !17
  %cmp49 = icmp eq i8 %16, 0
  %inc = add nsw i32 %i.0574, 1
  br i1 %cmp49, label %for.cond52.preheader, label %for.cond

for.cond60.preheader:                             ; preds = %for.body54.lr.ph, %for.cond52.preheader
  %cmp61570 = icmp eq i32 %mul23, 0
  br i1 %cmp61570, label %for.cond70.preheader, label %for.body62.lr.ph

for.body62.lr.ph:                                 ; preds = %for.cond60.preheader
  %value = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 7
  %17 = load i8** %value, align 4, !tbaa !21
  %scevgep579 = getelementptr [4096 x i8]* %buffer, i32 0, i32 32
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %scevgep579, i8* %17, i32 %mul23, i32 1, i1 false)
  br label %for.cond70.preheader

for.cond70.preheader:                             ; preds = %for.cond60.preheader, %for.body62.lr.ph
  %cmp71568 = icmp eq i8 %cond19, 0
  br i1 %cmp71568, label %for.end79, label %for.body72.lr.ph

for.body72.lr.ph:                                 ; preds = %for.cond70.preheader
  %coordinates = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 9
  %18 = load i32** %coordinates, align 4, !tbaa !22
  %19 = bitcast i32* %18 to i8*
  %scevgep.sum = add i32 %mul23, 32
  %scevgep578 = getelementptr [4096 x i8]* %buffer, i32 0, i32 %scevgep.sum
  %20 = shl nuw nsw i32 %conv24, 2
  %21 = icmp ugt i32 %20, 1
  %umax = select i1 %21, i32 %20, i32 1
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %scevgep578, i8* %19, i32 %umax, i32 1, i1 false)
  br label %for.end79

for.end79:                                        ; preds = %for.cond70.preheader, %for.body72.lr.ph
  %22 = load i8** @halide_trace_file, align 4, !tbaa !1
  %call81 = call i32 @fwrite(i8* %6, i32 1, i32 %add26, i8* %22)
  %cmp82 = icmp eq i32 %call81, %add26
  br i1 %cmp82, label %return, label %if.then83

if.then83:                                        ; preds = %for.end79
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([54 x i8]* @.str4, i32 0, i32 0))
  br label %return

if.else85:                                        ; preds = %if.end10
  %23 = getelementptr inbounds [256 x i8]* %buf, i32 0, i32 0
  call void @llvm.lifetime.start(i64 256, i8* %23) #3
  %bits89 = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 4
  %24 = load i32* %bits89, align 4, !tbaa !13
  br label %while.cond88

while.cond88:                                     ; preds = %while.cond88, %if.else85
  %print_bits.0 = phi i32 [ 8, %if.else85 ], [ %shl92, %while.cond88 ]
  %cmp90 = icmp slt i32 %print_bits.0, %24
  %shl92 = shl i32 %print_bits.0, 1
  br i1 %cmp90, label %while.cond88, label %while.end93

while.end93:                                      ; preds = %while.cond88
  %arrayidx87 = getelementptr inbounds [256 x i8]* %buf, i32 0, i32 255
  %cmp94 = icmp slt i32 %print_bits.0, 65
  br i1 %cmp94, label %if.end96, label %if.then95

if.then95:                                        ; preds = %while.end93
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([39 x i8]* @.str5, i32 0, i32 0))
  br label %if.end96

if.end96:                                         ; preds = %if.then95, %while.end93
  %event97 = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 1
  %25 = load i32* %event97, align 4, !tbaa !16
  %cmp98 = icmp slt i32 %25, 2
  %arrayidx102 = getelementptr inbounds [8 x i8*]* @_ZZ12halide_traceE11event_types, i32 0, i32 %25
  %26 = load i8** %arrayidx102, align 4, !tbaa !1
  %func103 = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 0
  %27 = load i8** %func103, align 4, !tbaa !20
  %value_index104 = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 6
  %28 = load i32* %value_index104, align 4, !tbaa !19
  %call105 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %23, i32 255, i8* getelementptr inbounds ([10 x i8]* @.str14, i32 0, i32 0), i8* %26, i8* %27, i32 %28)
  %add.ptr = getelementptr inbounds [256 x i8]* %buf, i32 0, i32 %call105
  %vector_width107 = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 5
  %29 = load i32* %vector_width107, align 4, !tbaa !8
  %cmp108 = icmp sgt i32 %29, 1
  br i1 %cmp108, label %if.then109, label %for.cond117.preheader

if.then109:                                       ; preds = %if.end96
  %30 = sub i32 255, %call105
  %call113 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %add.ptr, i32 %30, i8* getelementptr inbounds ([2 x i8]* @.str15, i32 0, i32 0))
  %add.ptr.sum = add i32 %call113, %call105
  %add.ptr114 = getelementptr inbounds [256 x i8]* %buf, i32 0, i32 %add.ptr.sum
  br label %for.cond117.preheader

for.cond117.preheader:                            ; preds = %if.then109, %if.end96
  %buf_ptr.2.ph = phi i8* [ %add.ptr, %if.end96 ], [ %add.ptr114, %if.then109 ]
  %dimensions118 = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 8
  %31 = load i32* %dimensions118, align 4, !tbaa !12
  %cmp119561 = icmp sgt i32 %31, 0
  %cmp120562 = icmp ult i8* %buf_ptr.2.ph, %arrayidx87
  %or.cond563 = and i1 %cmp119561, %cmp120562
  br i1 %or.cond563, label %for.body121.lr.ph, label %for.end151

for.body121.lr.ph:                                ; preds = %for.cond117.preheader
  %sub.ptr.lhs.cast129 = ptrtoint i8* %arrayidx87 to i32
  %coordinates145 = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 9
  br label %for.body121

for.body121:                                      ; preds = %for.body121.lr.ph, %if.end141
  %i116.0565 = phi i32 [ 0, %for.body121.lr.ph ], [ %inc150, %if.end141 ]
  %buf_ptr.2564 = phi i8* [ %buf_ptr.2.ph, %for.body121.lr.ph ], [ %add.ptr148, %if.end141 ]
  %cmp122 = icmp sgt i32 %i116.0565, 0
  br i1 %cmp122, label %if.then123, label %if.end141

if.then123:                                       ; preds = %for.body121
  %32 = load i32* %vector_width107, align 4, !tbaa !8
  %cmp125 = icmp sgt i32 %32, 1
  br i1 %cmp125, label %land.lhs.true, label %if.else134

land.lhs.true:                                    ; preds = %if.then123
  %rem = srem i32 %i116.0565, %32
  %cmp127 = icmp eq i32 %rem, 0
  br i1 %cmp127, label %if.then128, label %if.else134

if.then128:                                       ; preds = %land.lhs.true
  %sub.ptr.rhs.cast130 = ptrtoint i8* %buf_ptr.2564 to i32
  %sub.ptr.sub131 = sub i32 %sub.ptr.lhs.cast129, %sub.ptr.rhs.cast130
  %call132 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.2564, i32 %sub.ptr.sub131, i8* getelementptr inbounds ([5 x i8]* @.str16, i32 0, i32 0))
  %add.ptr133 = getelementptr inbounds i8* %buf_ptr.2564, i32 %call132
  br label %if.end141

if.else134:                                       ; preds = %land.lhs.true, %if.then123
  %sub.ptr.rhs.cast136 = ptrtoint i8* %buf_ptr.2564 to i32
  %sub.ptr.sub137 = sub i32 %sub.ptr.lhs.cast129, %sub.ptr.rhs.cast136
  %call138 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.2564, i32 %sub.ptr.sub137, i8* getelementptr inbounds ([3 x i8]* @.str17, i32 0, i32 0))
  %add.ptr139 = getelementptr inbounds i8* %buf_ptr.2564, i32 %call138
  br label %if.end141

if.end141:                                        ; preds = %if.then128, %if.else134, %for.body121
  %buf_ptr.3 = phi i8* [ %add.ptr133, %if.then128 ], [ %add.ptr139, %if.else134 ], [ %buf_ptr.2564, %for.body121 ]
  %sub.ptr.rhs.cast143 = ptrtoint i8* %buf_ptr.3 to i32
  %sub.ptr.sub144 = sub i32 %sub.ptr.lhs.cast129, %sub.ptr.rhs.cast143
  %33 = load i32** %coordinates145, align 4, !tbaa !22
  %arrayidx146 = getelementptr inbounds i32* %33, i32 %i116.0565
  %34 = load i32* %arrayidx146, align 4, !tbaa !14
  %call147 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.3, i32 %sub.ptr.sub144, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %34)
  %add.ptr148 = getelementptr inbounds i8* %buf_ptr.3, i32 %call147
  %inc150 = add nsw i32 %i116.0565, 1
  %35 = load i32* %dimensions118, align 4, !tbaa !12
  %cmp119 = icmp slt i32 %inc150, %35
  %cmp120 = icmp ult i8* %add.ptr148, %arrayidx87
  %or.cond = and i1 %cmp119, %cmp120
  br i1 %or.cond, label %for.body121, label %for.end151

for.end151:                                       ; preds = %if.end141, %for.cond117.preheader
  %cmp120.lcssa = phi i1 [ %cmp120562, %for.cond117.preheader ], [ %cmp120, %if.end141 ]
  %buf_ptr.2.lcssa = phi i8* [ %buf_ptr.2.ph, %for.cond117.preheader ], [ %add.ptr148, %if.end141 ]
  br i1 %cmp120.lcssa, label %if.then153, label %if.end169

if.then153:                                       ; preds = %for.end151
  %36 = load i32* %vector_width107, align 4, !tbaa !8
  %cmp155 = icmp sgt i32 %36, 1
  %sub.ptr.lhs.cast157 = ptrtoint i8* %arrayidx87 to i32
  %sub.ptr.rhs.cast158 = ptrtoint i8* %buf_ptr.2.lcssa to i32
  %sub.ptr.sub159 = sub i32 %sub.ptr.lhs.cast157, %sub.ptr.rhs.cast158
  br i1 %cmp155, label %if.then156, label %if.else162

if.then156:                                       ; preds = %if.then153
  %call160 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.2.lcssa, i32 %sub.ptr.sub159, i8* getelementptr inbounds ([3 x i8]* @.str19, i32 0, i32 0))
  %add.ptr161 = getelementptr inbounds i8* %buf_ptr.2.lcssa, i32 %call160
  br label %if.end169

if.else162:                                       ; preds = %if.then153
  %call166 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.2.lcssa, i32 %sub.ptr.sub159, i8* getelementptr inbounds ([2 x i8]* @.str20, i32 0, i32 0))
  %add.ptr167 = getelementptr inbounds i8* %buf_ptr.2.lcssa, i32 %call166
  br label %if.end169

if.end169:                                        ; preds = %if.then156, %if.else162, %for.end151
  %buf_ptr.4 = phi i8* [ %add.ptr161, %if.then156 ], [ %add.ptr167, %if.else162 ], [ %buf_ptr.2.lcssa, %for.end151 ]
  br i1 %cmp98, label %if.then171, label %if.end357

if.then171:                                       ; preds = %if.end169
  %cmp172 = icmp ult i8* %buf_ptr.4, %arrayidx87
  br i1 %cmp172, label %if.then173, label %for.cond191.preheader

if.then173:                                       ; preds = %if.then171
  %37 = load i32* %vector_width107, align 4, !tbaa !8
  %cmp175 = icmp sgt i32 %37, 1
  %sub.ptr.lhs.cast177 = ptrtoint i8* %arrayidx87 to i32
  %sub.ptr.rhs.cast178 = ptrtoint i8* %buf_ptr.4 to i32
  %sub.ptr.sub179 = sub i32 %sub.ptr.lhs.cast177, %sub.ptr.rhs.cast178
  br i1 %cmp175, label %if.then176, label %if.else182

if.then176:                                       ; preds = %if.then173
  %call180 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.4, i32 %sub.ptr.sub179, i8* getelementptr inbounds ([5 x i8]* @.str21, i32 0, i32 0))
  %add.ptr181 = getelementptr inbounds i8* %buf_ptr.4, i32 %call180
  br label %for.cond191.preheader

if.else182:                                       ; preds = %if.then173
  %call186 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.4, i32 %sub.ptr.sub179, i8* getelementptr inbounds ([4 x i8]* @.str22, i32 0, i32 0))
  %add.ptr187 = getelementptr inbounds i8* %buf_ptr.4, i32 %call186
  br label %for.cond191.preheader

for.cond191.preheader:                            ; preds = %if.then176, %if.else182, %if.then171
  %buf_ptr.6.ph = phi i8* [ %buf_ptr.4, %if.then171 ], [ %add.ptr187, %if.else182 ], [ %add.ptr181, %if.then176 ]
  %38 = load i32* %vector_width107, align 4, !tbaa !8
  %cmp193553 = icmp sgt i32 %38, 0
  %cmp195554 = icmp ult i8* %buf_ptr.6.ph, %arrayidx87
  %or.cond544555 = and i1 %cmp193553, %cmp195554
  br i1 %or.cond544555, label %for.body197.lr.ph, label %for.end345

for.body197.lr.ph:                                ; preds = %for.cond191.preheader
  %sub.ptr.lhs.cast200 = ptrtoint i8* %arrayidx87 to i32
  %type_code206 = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 3
  %cmp231 = icmp eq i32 %print_bits.0, 32
  %value236 = getelementptr inbounds %struct.halide_trace_event* %e, i32 0, i32 7
  %cmp306 = icmp sgt i32 %print_bits.0, 31
  br label %for.body197

for.body197:                                      ; preds = %for.body197.lr.ph, %for.inc343
  %i190.0557 = phi i32 [ 0, %for.body197.lr.ph ], [ %inc344, %for.inc343 ]
  %buf_ptr.6556 = phi i8* [ %buf_ptr.6.ph, %for.body197.lr.ph ], [ %buf_ptr.8, %for.inc343 ]
  %cmp198 = icmp sgt i32 %i190.0557, 0
  br i1 %cmp198, label %if.then199, label %if.end205

if.then199:                                       ; preds = %for.body197
  %sub.ptr.rhs.cast201 = ptrtoint i8* %buf_ptr.6556 to i32
  %sub.ptr.sub202 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast201
  %call203 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.6556, i32 %sub.ptr.sub202, i8* getelementptr inbounds ([3 x i8]* @.str17, i32 0, i32 0))
  %add.ptr204 = getelementptr inbounds i8* %buf_ptr.6556, i32 %call203
  br label %if.end205

if.end205:                                        ; preds = %if.then199, %for.body197
  %buf_ptr.7 = phi i8* [ %add.ptr204, %if.then199 ], [ %buf_ptr.6556, %for.body197 ]
  %39 = load i32* %type_code206, align 4, !tbaa !18
  switch i32 %39, label %for.inc343 [
    i32 0, label %if.then208
    i32 1, label %if.then255
    i32 2, label %if.then305
    i32 3, label %if.then331
  ]

if.then208:                                       ; preds = %if.end205
  switch i32 %print_bits.0, label %if.else230 [
    i32 8, label %if.then210
    i32 16, label %if.then221
  ]

if.then210:                                       ; preds = %if.then208
  %sub.ptr.rhs.cast212 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub213 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast212
  %40 = load i8** %value236, align 4, !tbaa !21
  %arrayidx215 = getelementptr inbounds i8* %40, i32 %i190.0557
  %41 = load i8* %arrayidx215, align 1, !tbaa !17
  %conv216 = sext i8 %41 to i32
  %call217 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub213, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %conv216)
  %add.ptr218 = getelementptr inbounds i8* %buf_ptr.7, i32 %call217
  br label %for.inc343

if.then221:                                       ; preds = %if.then208
  %sub.ptr.rhs.cast223 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub224 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast223
  %42 = load i8** %value236, align 4, !tbaa !21
  %43 = bitcast i8* %42 to i16*
  %arrayidx226 = getelementptr inbounds i16* %43, i32 %i190.0557
  %44 = load i16* %arrayidx226, align 2, !tbaa !23
  %conv227 = sext i16 %44 to i32
  %call228 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub224, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %conv227)
  %add.ptr229 = getelementptr inbounds i8* %buf_ptr.7, i32 %call228
  br label %for.inc343

if.else230:                                       ; preds = %if.then208
  %sub.ptr.rhs.cast234 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub235 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast234
  %45 = load i8** %value236, align 4, !tbaa !21
  br i1 %cmp231, label %if.then232, label %if.else240

if.then232:                                       ; preds = %if.else230
  %46 = bitcast i8* %45 to i32*
  %arrayidx237 = getelementptr inbounds i32* %46, i32 %i190.0557
  %47 = load i32* %arrayidx237, align 4, !tbaa !14
  %call238 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub235, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %47)
  %add.ptr239 = getelementptr inbounds i8* %buf_ptr.7, i32 %call238
  br label %for.inc343

if.else240:                                       ; preds = %if.else230
  %48 = bitcast i8* %45 to i64*
  %arrayidx245 = getelementptr inbounds i64* %48, i32 %i190.0557
  %49 = load i64* %arrayidx245, align 4, !tbaa !25
  %conv246 = trunc i64 %49 to i32
  %call247 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub235, i8* getelementptr inbounds ([3 x i8]* @.str18, i32 0, i32 0), i32 %conv246)
  %add.ptr248 = getelementptr inbounds i8* %buf_ptr.7, i32 %call247
  br label %for.inc343

if.then255:                                       ; preds = %if.end205
  switch i32 %print_bits.0, label %if.else280 [
    i32 8, label %if.then257
    i32 16, label %if.then271
  ]

if.then257:                                       ; preds = %if.then255
  %sub.ptr.rhs.cast259 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub260 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast259
  %50 = load i8** %value236, align 4, !tbaa !21
  %arrayidx262 = getelementptr inbounds i8* %50, i32 %i190.0557
  %51 = load i8* %arrayidx262, align 1, !tbaa !17
  %conv263 = zext i8 %51 to i32
  %call264 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub260, i8* getelementptr inbounds ([3 x i8]* @.str23, i32 0, i32 0), i32 %conv263)
  %add.ptr265 = getelementptr inbounds i8* %buf_ptr.7, i32 %call264
  %cmp266 = icmp ugt i8* %add.ptr265, %arrayidx87
  %arrayidx87.add.ptr265 = select i1 %cmp266, i8* %arrayidx87, i8* %add.ptr265
  br label %for.inc343

if.then271:                                       ; preds = %if.then255
  %sub.ptr.rhs.cast273 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub274 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast273
  %52 = load i8** %value236, align 4, !tbaa !21
  %53 = bitcast i8* %52 to i16*
  %arrayidx276 = getelementptr inbounds i16* %53, i32 %i190.0557
  %54 = load i16* %arrayidx276, align 2, !tbaa !23
  %conv277 = zext i16 %54 to i32
  %call278 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub274, i8* getelementptr inbounds ([3 x i8]* @.str23, i32 0, i32 0), i32 %conv277)
  %add.ptr279 = getelementptr inbounds i8* %buf_ptr.7, i32 %call278
  br label %for.inc343

if.else280:                                       ; preds = %if.then255
  %sub.ptr.rhs.cast284 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub285 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast284
  %55 = load i8** %value236, align 4, !tbaa !21
  br i1 %cmp231, label %if.then282, label %if.else290

if.then282:                                       ; preds = %if.else280
  %56 = bitcast i8* %55 to i32*
  %arrayidx287 = getelementptr inbounds i32* %56, i32 %i190.0557
  %57 = load i32* %arrayidx287, align 4, !tbaa !14
  %call288 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub285, i8* getelementptr inbounds ([3 x i8]* @.str23, i32 0, i32 0), i32 %57)
  %add.ptr289 = getelementptr inbounds i8* %buf_ptr.7, i32 %call288
  br label %for.inc343

if.else290:                                       ; preds = %if.else280
  %58 = bitcast i8* %55 to i64*
  %arrayidx295 = getelementptr inbounds i64* %58, i32 %i190.0557
  %59 = load i64* %arrayidx295, align 4, !tbaa !25
  %conv296 = trunc i64 %59 to i32
  %call297 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub285, i8* getelementptr inbounds ([3 x i8]* @.str23, i32 0, i32 0), i32 %conv296)
  %add.ptr298 = getelementptr inbounds i8* %buf_ptr.7, i32 %call297
  br label %for.inc343

if.then305:                                       ; preds = %if.end205
  br i1 %cmp306, label %if.end308, label %if.end308.thread

if.end308.thread:                                 ; preds = %if.then305
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([41 x i8]* @.str24, i32 0, i32 0))
  %sub.ptr.rhs.cast312549 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub313550 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast312549
  %60 = load i8** %value236, align 4, !tbaa !21
  br label %if.else319

if.end308:                                        ; preds = %if.then305
  %sub.ptr.rhs.cast312 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub313 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast312
  %61 = load i8** %value236, align 4, !tbaa !21
  br i1 %cmp231, label %if.then310, label %if.else319

if.then310:                                       ; preds = %if.end308
  %62 = bitcast i8* %61 to float*
  %arrayidx315 = getelementptr inbounds float* %62, i32 %i190.0557
  %63 = load float* %arrayidx315, align 4, !tbaa !27
  %conv316 = fpext float %63 to double
  %call317 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub313, i8* getelementptr inbounds ([3 x i8]* @.str25, i32 0, i32 0), double %conv316)
  %add.ptr318 = getelementptr inbounds i8* %buf_ptr.7, i32 %call317
  br label %for.inc343

if.else319:                                       ; preds = %if.end308.thread, %if.end308
  %64 = phi i8* [ %60, %if.end308.thread ], [ %61, %if.end308 ]
  %sub.ptr.sub313552 = phi i32 [ %sub.ptr.sub313550, %if.end308.thread ], [ %sub.ptr.sub313, %if.end308 ]
  %65 = bitcast i8* %64 to double*
  %arrayidx324 = getelementptr inbounds double* %65, i32 %i190.0557
  %66 = load double* %arrayidx324, align 4, !tbaa !29
  %call325 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub313552, i8* getelementptr inbounds ([3 x i8]* @.str25, i32 0, i32 0), double %66)
  %add.ptr326 = getelementptr inbounds i8* %buf_ptr.7, i32 %call325
  br label %for.inc343

if.then331:                                       ; preds = %if.end205
  %sub.ptr.rhs.cast333 = ptrtoint i8* %buf_ptr.7 to i32
  %sub.ptr.sub334 = sub i32 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast333
  %67 = load i8** %value236, align 4, !tbaa !21
  %68 = bitcast i8* %67 to i8**
  %arrayidx336 = getelementptr inbounds i8** %68, i32 %i190.0557
  %69 = load i8** %arrayidx336, align 4, !tbaa !1
  %call337 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.7, i32 %sub.ptr.sub334, i8* getelementptr inbounds ([3 x i8]* @.str26, i32 0, i32 0), i8* %69)
  %add.ptr338 = getelementptr inbounds i8* %buf_ptr.7, i32 %call337
  br label %for.inc343

for.inc343:                                       ; preds = %if.then257, %if.end205, %if.then221, %if.else240, %if.then232, %if.then210, %if.else319, %if.then310, %if.then331, %if.then282, %if.else290, %if.then271
  %buf_ptr.8 = phi i8* [ %add.ptr218, %if.then210 ], [ %add.ptr229, %if.then221 ], [ %add.ptr239, %if.then232 ], [ %add.ptr248, %if.else240 ], [ %add.ptr279, %if.then271 ], [ %add.ptr289, %if.then282 ], [ %add.ptr298, %if.else290 ], [ %add.ptr318, %if.then310 ], [ %add.ptr326, %if.else319 ], [ %add.ptr338, %if.then331 ], [ %arrayidx87.add.ptr265, %if.then257 ], [ %buf_ptr.7, %if.end205 ]
  %inc344 = add nsw i32 %i190.0557, 1
  %70 = load i32* %vector_width107, align 4, !tbaa !8
  %cmp193 = icmp slt i32 %inc344, %70
  %cmp195 = icmp ult i8* %buf_ptr.8, %arrayidx87
  %or.cond544 = and i1 %cmp193, %cmp195
  br i1 %or.cond544, label %for.body197, label %for.end345

for.end345:                                       ; preds = %for.inc343, %for.cond191.preheader
  %cmp195.lcssa = phi i1 [ %cmp195554, %for.cond191.preheader ], [ %cmp195, %for.inc343 ]
  %.lcssa = phi i32 [ %38, %for.cond191.preheader ], [ %70, %for.inc343 ]
  %buf_ptr.6.lcssa = phi i8* [ %buf_ptr.6.ph, %for.cond191.preheader ], [ %buf_ptr.8, %for.inc343 ]
  %cmp347 = icmp sgt i32 %.lcssa, 1
  %or.cond545 = and i1 %cmp347, %cmp195.lcssa
  br i1 %or.cond545, label %if.then350, label %if.end357

if.then350:                                       ; preds = %for.end345
  %sub.ptr.lhs.cast351 = ptrtoint i8* %arrayidx87 to i32
  %sub.ptr.rhs.cast352 = ptrtoint i8* %buf_ptr.6.lcssa to i32
  %sub.ptr.sub353 = sub i32 %sub.ptr.lhs.cast351, %sub.ptr.rhs.cast352
  %call354 = call i32 (i8*, i32, i8*, ...)* @snprintf(i8* %buf_ptr.6.lcssa, i32 %sub.ptr.sub353, i8* getelementptr inbounds ([2 x i8]* @.str27, i32 0, i32 0))
  br label %if.end357

if.end357:                                        ; preds = %for.end345, %if.then350, %if.end169
  %call359 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([4 x i8]* @.str28, i32 0, i32 0), i8* %23)
  call void @llvm.lifetime.end(i64 256, i8* %23) #3
  br label %return

return:                                           ; preds = %if.end357, %if.then83, %for.end79, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ %1, %for.end79 ], [ %1, %if.then83 ], [ %1, %if.end357 ]
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
!8 = metadata !{metadata !9, metadata !11, i64 20}
!9 = metadata !{metadata !"_ZTS18halide_trace_event", metadata !2, i64 0, metadata !10, i64 4, metadata !11, i64 8, metadata !11, i64 12, metadata !11, i64 16, metadata !11, i64 20, metadata !11, i64 24, metadata !2, i64 28, metadata !11, i64 32, metadata !2, i64 36}
!10 = metadata !{metadata !"_ZTS23halide_trace_event_code", metadata !3, i64 0}
!11 = metadata !{metadata !"int", metadata !3, i64 0}
!12 = metadata !{metadata !9, metadata !11, i64 32}
!13 = metadata !{metadata !9, metadata !11, i64 16}
!14 = metadata !{metadata !11, metadata !11, i64 0}
!15 = metadata !{metadata !9, metadata !11, i64 8}
!16 = metadata !{metadata !9, metadata !10, i64 4}
!17 = metadata !{metadata !3, metadata !3, i64 0}
!18 = metadata !{metadata !9, metadata !11, i64 12}
!19 = metadata !{metadata !9, metadata !11, i64 24}
!20 = metadata !{metadata !9, metadata !2, i64 0}
!21 = metadata !{metadata !9, metadata !2, i64 28}
!22 = metadata !{metadata !9, metadata !2, i64 36}
!23 = metadata !{metadata !24, metadata !24, i64 0}
!24 = metadata !{metadata !"short", metadata !3, i64 0}
!25 = metadata !{metadata !26, metadata !26, i64 0}
!26 = metadata !{metadata !"long long", metadata !3, i64 0}
!27 = metadata !{metadata !28, metadata !28, i64 0}
!28 = metadata !{metadata !"float", metadata !3, i64 0}
!29 = metadata !{metadata !30, metadata !30, i64 0}
!30 = metadata !{metadata !"double", metadata !3, i64 0}
