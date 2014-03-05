; ModuleID = 'src/runtime/tracing.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.halide_trace_event = type { i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32* }

@halide_custom_trace = weak global i32 (i8*, %struct.halide_trace_event*)* null, align 8
@halide_trace_file = weak global i8* null, align 8
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
@_ZZ12halide_traceE11event_types = private unnamed_addr constant [8 x i8*] [i8* getelementptr inbounds ([5 x i8]* @.str6, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8]* @.str7, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8]* @.str8, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8]* @.str9, i32 0, i32 0), i8* getelementptr inbounds ([8 x i8]* @.str10, i32 0, i32 0), i8* getelementptr inbounds ([7 x i8]* @.str11, i32 0, i32 0), i8* getelementptr inbounds ([8 x i8]* @.str12, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8]* @.str13, i32 0, i32 0)], align 16
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

; Function Attrs: uwtable
define weak void @halide_set_custom_trace(i32 (i8*, %struct.halide_trace_event*)* %t) #0 {
entry:
  store i32 (i8*, %struct.halide_trace_event*)* %t, i32 (i8*, %struct.halide_trace_event*)** @halide_custom_trace, align 8, !tbaa !1
  ret void
}

; Function Attrs: uwtable
define weak i32 @halide_trace(i8* %user_context, %struct.halide_trace_event* %e) #0 {
entry:
  %buffer = alloca [4096 x i8], align 16
  %buf = alloca [256 x i8], align 16
  %0 = load i32 (i8*, %struct.halide_trace_event*)** @halide_custom_trace, align 8, !tbaa !1
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
  %call3 = call i8* @getenv(i8* getelementptr inbounds ([14 x i8]* @.str, i64 0, i64 0))
  store i8 1, i8* @halide_trace_initialized, align 1, !tbaa !5
  %tobool4 = icmp eq i8* %call3, null
  br i1 %tobool4, label %if.end10, label %if.then5

if.then5:                                         ; preds = %if.then2
  %call6 = call i8* @fopen(i8* %call3, i8* getelementptr inbounds ([3 x i8]* @.str1, i64 0, i64 0))
  store i8* %call6, i8** @halide_trace_file, align 8, !tbaa !1
  %tobool7 = icmp eq i8* %call6, null
  br i1 %tobool7, label %if.then8, label %if.then12

if.then8:                                         ; preds = %if.then5
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([51 x i8]* @.str2, i64 0, i64 0))
  br label %if.end10

if.end10:                                         ; preds = %if.then2, %if.else, %if.then8
  %.pr = load i8** @halide_trace_file, align 8, !tbaa !1
  %tobool11 = icmp eq i8* %.pr, null
  br i1 %tobool11, label %if.else91, label %if.then12

if.then12:                                        ; preds = %if.then5, %if.end10
  %vector_width = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 5
  %3 = load i32* %vector_width, align 4, !tbaa !8
  %phitmp = trunc i32 %3 to i8
  %dimensions = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 8
  %4 = load i32* %dimensions, align 4, !tbaa !12
  %phitmp583 = trunc i32 %4 to i8
  %bits = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 4
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
  %cond19 = select i1 %cmp14, i8 %phitmp583, i8 -1
  %conv22 = zext i8 %phitmp. to i32
  %mul23 = mul i32 %bytes.0, %conv22
  %conv24 = sext i32 %mul23 to i64
  %conv25 = zext i8 %cond19 to i64
  %mul26 = shl nuw nsw i64 %conv25, 2
  %add = add i64 %conv24, 32
  %add27 = add i64 %add, %mul26
  %6 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 0
  call void @llvm.lifetime.start(i64 4096, i8* %6) #4
  %cmp28 = icmp ult i64 %add27, 4097
  br i1 %cmp28, label %if.end30, label %if.then29

if.then29:                                        ; preds = %while.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([50 x i8]* @.str3, i64 0, i64 0))
  %.pre = load i32* %bits, align 4, !tbaa !13
  br label %if.end30

if.end30:                                         ; preds = %if.then29, %while.end
  %7 = phi i32 [ %.pre, %if.then29 ], [ %5, %while.end ]
  %8 = bitcast [4096 x i8]* %buffer to i32*
  store i32 %1, i32* %8, align 16, !tbaa !14
  %parent_id = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 2
  %9 = load i32* %parent_id, align 4, !tbaa !15
  %arrayidx32 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 4
  %10 = bitcast i8* %arrayidx32 to i32*
  store i32 %9, i32* %10, align 4, !tbaa !14
  %event = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 1
  %11 = load i32* %event, align 4, !tbaa !16
  %conv33 = trunc i32 %11 to i8
  %arrayidx34 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 8
  store i8 %conv33, i8* %arrayidx34, align 8, !tbaa !17
  %type_code = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 3
  %12 = load i32* %type_code, align 4, !tbaa !18
  %conv35 = trunc i32 %12 to i8
  %arrayidx36 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 9
  store i8 %conv35, i8* %arrayidx36, align 1, !tbaa !17
  %conv38 = trunc i32 %7 to i8
  %arrayidx39 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 10
  store i8 %conv38, i8* %arrayidx39, align 2, !tbaa !17
  %arrayidx40 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 11
  store i8 %phitmp., i8* %arrayidx40, align 1, !tbaa !17
  %value_index = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 6
  %13 = load i32* %value_index, align 4, !tbaa !19
  %conv41 = trunc i32 %13 to i8
  %arrayidx42 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 12
  store i8 %conv41, i8* %arrayidx42, align 4, !tbaa !17
  %arrayidx43 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 13
  store i8 %cond19, i8* %arrayidx43, align 1, !tbaa !17
  %func = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 0
  %14 = load i8** %func, align 8, !tbaa !20
  br label %for.body

for.cond:                                         ; preds = %for.body
  %15 = trunc i64 %indvars.iv.next621 to i32
  %cmp45 = icmp ult i32 %15, 31
  br i1 %cmp45, label %for.body, label %for.cond56.preheader

for.cond56.preheader:                             ; preds = %for.body, %for.cond
  %i.0.lcssa = phi i32 [ %i.0608, %for.body ], [ %inc, %for.cond ]
  %cmp58606 = icmp ult i32 %i.0.lcssa, 32
  br i1 %cmp58606, label %for.body59.lr.ph, label %for.cond66.preheader

for.body59.lr.ph:                                 ; preds = %for.cond56.preheader
  %16 = sext i32 %i.0.lcssa to i64
  %scevgep619 = getelementptr [4096 x i8]* %buffer, i64 0, i64 %16
  %17 = sub i32 31, %i.0.lcssa
  %18 = zext i32 %17 to i64
  %19 = add i64 %18, 1
  call void @llvm.memset.p0i8.i64(i8* %scevgep619, i8 0, i64 %19, i32 1, i1 false)
  br label %for.cond66.preheader

for.body:                                         ; preds = %if.end30, %for.cond
  %indvars.iv620 = phi i64 [ 14, %if.end30 ], [ %indvars.iv.next621, %for.cond ]
  %i.0608 = phi i32 [ 14, %if.end30 ], [ %inc, %for.cond ]
  %20 = add nsw i64 %indvars.iv620, -14
  %arrayidx47 = getelementptr inbounds i8* %14, i64 %20
  %21 = load i8* %arrayidx47, align 1, !tbaa !17
  %arrayidx49 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 %indvars.iv620
  store i8 %21, i8* %arrayidx49, align 1, !tbaa !17
  %cmp53 = icmp eq i8 %21, 0
  %indvars.iv.next621 = add nuw nsw i64 %indvars.iv620, 1
  %inc = add nsw i32 %i.0608, 1
  br i1 %cmp53, label %for.cond56.preheader, label %for.cond

for.cond66.preheader:                             ; preds = %for.body59.lr.ph, %for.cond56.preheader
  %cmp67604 = icmp eq i32 %mul23, 0
  br i1 %cmp67604, label %for.cond76.preheader, label %for.body68.lr.ph

for.body68.lr.ph:                                 ; preds = %for.cond66.preheader
  %value = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 7
  %22 = load i8** %value, align 8, !tbaa !21
  %scevgep615 = getelementptr [4096 x i8]* %buffer, i64 0, i64 32
  %23 = icmp ugt i64 %conv24, 1
  %umax616 = select i1 %23, i64 %conv24, i64 1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %scevgep615, i8* %22, i64 %umax616, i32 1, i1 false)
  br label %for.cond76.preheader

for.cond76.preheader:                             ; preds = %for.cond66.preheader, %for.body68.lr.ph
  %cmp77602 = icmp eq i8 %cond19, 0
  br i1 %cmp77602, label %for.end85, label %for.body78.lr.ph

for.body78.lr.ph:                                 ; preds = %for.cond76.preheader
  %coordinates = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 9
  %24 = load i32** %coordinates, align 8, !tbaa !22
  %25 = bitcast i32* %24 to i8*
  %scevgep.sum = add i64 %conv24, 32
  %scevgep614 = getelementptr [4096 x i8]* %buffer, i64 0, i64 %scevgep.sum
  %26 = shl nuw nsw i64 %conv25, 2
  %27 = icmp ugt i64 %26, 1
  %umax = select i1 %27, i64 %26, i64 1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %scevgep614, i8* %25, i64 %umax, i32 1, i1 false)
  br label %for.end85

for.end85:                                        ; preds = %for.cond76.preheader, %for.body78.lr.ph
  %28 = load i8** @halide_trace_file, align 8, !tbaa !1
  %call87 = call i64 @fwrite(i8* %6, i64 1, i64 %add27, i8* %28)
  %cmp88 = icmp eq i64 %call87, %add27
  br i1 %cmp88, label %return, label %if.then89

if.then89:                                        ; preds = %for.end85
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([54 x i8]* @.str4, i64 0, i64 0))
  br label %return

if.else91:                                        ; preds = %if.end10
  %29 = getelementptr inbounds [256 x i8]* %buf, i64 0, i64 0
  call void @llvm.lifetime.start(i64 256, i8* %29) #4
  %bits95 = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 4
  %30 = load i32* %bits95, align 4, !tbaa !13
  br label %while.cond94

while.cond94:                                     ; preds = %while.cond94, %if.else91
  %print_bits.0 = phi i32 [ 8, %if.else91 ], [ %shl98, %while.cond94 ]
  %cmp96 = icmp slt i32 %print_bits.0, %30
  %shl98 = shl i32 %print_bits.0, 1
  br i1 %cmp96, label %while.cond94, label %while.end99

while.end99:                                      ; preds = %while.cond94
  %arrayidx93 = getelementptr inbounds [256 x i8]* %buf, i64 0, i64 255
  %cmp100 = icmp slt i32 %print_bits.0, 65
  br i1 %cmp100, label %if.end102, label %if.then101

if.then101:                                       ; preds = %while.end99
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([39 x i8]* @.str5, i64 0, i64 0))
  br label %if.end102

if.end102:                                        ; preds = %if.then101, %while.end99
  %event103 = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 1
  %31 = load i32* %event103, align 4, !tbaa !16
  %cmp104 = icmp slt i32 %31, 2
  %idxprom108 = zext i32 %31 to i64
  %arrayidx109 = getelementptr inbounds [8 x i8*]* @_ZZ12halide_traceE11event_types, i64 0, i64 %idxprom108
  %32 = load i8** %arrayidx109, align 8, !tbaa !1
  %func110 = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 0
  %33 = load i8** %func110, align 8, !tbaa !20
  %value_index111 = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 6
  %34 = load i32* %value_index111, align 4, !tbaa !19
  %call112 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %29, i64 255, i8* getelementptr inbounds ([10 x i8]* @.str14, i64 0, i64 0), i8* %32, i8* %33, i32 %34)
  %idx.ext = sext i32 %call112 to i64
  %add.ptr = getelementptr inbounds [256 x i8]* %buf, i64 0, i64 %idx.ext
  %vector_width114 = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 5
  %35 = load i32* %vector_width114, align 4, !tbaa !8
  %cmp115 = icmp sgt i32 %35, 1
  br i1 %cmp115, label %if.then116, label %for.cond125.preheader

if.then116:                                       ; preds = %if.end102
  %36 = sub i64 255, %idx.ext
  %call120 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %add.ptr, i64 %36, i8* getelementptr inbounds ([2 x i8]* @.str15, i64 0, i64 0))
  %idx.ext121 = sext i32 %call120 to i64
  %add.ptr.sum = add i64 %idx.ext121, %idx.ext
  %add.ptr122 = getelementptr inbounds [256 x i8]* %buf, i64 0, i64 %add.ptr.sum
  br label %for.cond125.preheader

for.cond125.preheader:                            ; preds = %if.then116, %if.end102
  %buf_ptr.2.ph = phi i8* [ %add.ptr, %if.end102 ], [ %add.ptr122, %if.then116 ]
  %dimensions126 = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 8
  %37 = load i32* %dimensions126, align 4, !tbaa !12
  %cmp127595 = icmp sgt i32 %37, 0
  %cmp128596 = icmp ult i8* %buf_ptr.2.ph, %arrayidx93
  %or.cond597 = and i1 %cmp127595, %cmp128596
  br i1 %or.cond597, label %for.body129.lr.ph, label %for.end163

for.body129.lr.ph:                                ; preds = %for.cond125.preheader
  %sub.ptr.lhs.cast137 = ptrtoint i8* %arrayidx93 to i64
  %coordinates156 = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 9
  br label %for.body129

for.body129:                                      ; preds = %for.body129.lr.ph, %if.end151
  %indvars.iv612 = phi i64 [ 0, %for.body129.lr.ph ], [ %indvars.iv.next613, %if.end151 ]
  %buf_ptr.2598 = phi i8* [ %buf_ptr.2.ph, %for.body129.lr.ph ], [ %add.ptr160, %if.end151 ]
  %38 = trunc i64 %indvars.iv612 to i32
  %cmp130 = icmp sgt i32 %38, 0
  br i1 %cmp130, label %if.then131, label %if.end151

if.then131:                                       ; preds = %for.body129
  %39 = load i32* %vector_width114, align 4, !tbaa !8
  %cmp133 = icmp sgt i32 %39, 1
  br i1 %cmp133, label %land.lhs.true, label %if.else143

land.lhs.true:                                    ; preds = %if.then131
  %rem = srem i32 %38, %39
  %cmp135 = icmp eq i32 %rem, 0
  br i1 %cmp135, label %if.then136, label %if.else143

if.then136:                                       ; preds = %land.lhs.true
  %sub.ptr.rhs.cast138 = ptrtoint i8* %buf_ptr.2598 to i64
  %sub.ptr.sub139 = sub i64 %sub.ptr.lhs.cast137, %sub.ptr.rhs.cast138
  %call140 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.2598, i64 %sub.ptr.sub139, i8* getelementptr inbounds ([5 x i8]* @.str16, i64 0, i64 0))
  %idx.ext141 = sext i32 %call140 to i64
  %add.ptr142 = getelementptr inbounds i8* %buf_ptr.2598, i64 %idx.ext141
  br label %if.end151

if.else143:                                       ; preds = %land.lhs.true, %if.then131
  %sub.ptr.rhs.cast145 = ptrtoint i8* %buf_ptr.2598 to i64
  %sub.ptr.sub146 = sub i64 %sub.ptr.lhs.cast137, %sub.ptr.rhs.cast145
  %call147 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.2598, i64 %sub.ptr.sub146, i8* getelementptr inbounds ([3 x i8]* @.str17, i64 0, i64 0))
  %idx.ext148 = sext i32 %call147 to i64
  %add.ptr149 = getelementptr inbounds i8* %buf_ptr.2598, i64 %idx.ext148
  br label %if.end151

if.end151:                                        ; preds = %if.then136, %if.else143, %for.body129
  %buf_ptr.3 = phi i8* [ %add.ptr142, %if.then136 ], [ %add.ptr149, %if.else143 ], [ %buf_ptr.2598, %for.body129 ]
  %sub.ptr.rhs.cast153 = ptrtoint i8* %buf_ptr.3 to i64
  %sub.ptr.sub154 = sub i64 %sub.ptr.lhs.cast137, %sub.ptr.rhs.cast153
  %40 = load i32** %coordinates156, align 8, !tbaa !22
  %arrayidx157 = getelementptr inbounds i32* %40, i64 %indvars.iv612
  %41 = load i32* %arrayidx157, align 4, !tbaa !14
  %call158 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.3, i64 %sub.ptr.sub154, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %41)
  %idx.ext159 = sext i32 %call158 to i64
  %add.ptr160 = getelementptr inbounds i8* %buf_ptr.3, i64 %idx.ext159
  %indvars.iv.next613 = add nuw nsw i64 %indvars.iv612, 1
  %42 = load i32* %dimensions126, align 4, !tbaa !12
  %43 = trunc i64 %indvars.iv.next613 to i32
  %cmp127 = icmp slt i32 %43, %42
  %cmp128 = icmp ult i8* %add.ptr160, %arrayidx93
  %or.cond = and i1 %cmp127, %cmp128
  br i1 %or.cond, label %for.body129, label %for.end163

for.end163:                                       ; preds = %if.end151, %for.cond125.preheader
  %cmp128.lcssa = phi i1 [ %cmp128596, %for.cond125.preheader ], [ %cmp128, %if.end151 ]
  %buf_ptr.2.lcssa = phi i8* [ %buf_ptr.2.ph, %for.cond125.preheader ], [ %add.ptr160, %if.end151 ]
  br i1 %cmp128.lcssa, label %if.then165, label %if.end183

if.then165:                                       ; preds = %for.end163
  %44 = load i32* %vector_width114, align 4, !tbaa !8
  %cmp167 = icmp sgt i32 %44, 1
  %sub.ptr.lhs.cast169 = ptrtoint i8* %arrayidx93 to i64
  %sub.ptr.rhs.cast170 = ptrtoint i8* %buf_ptr.2.lcssa to i64
  %sub.ptr.sub171 = sub i64 %sub.ptr.lhs.cast169, %sub.ptr.rhs.cast170
  br i1 %cmp167, label %if.then168, label %if.else175

if.then168:                                       ; preds = %if.then165
  %call172 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.2.lcssa, i64 %sub.ptr.sub171, i8* getelementptr inbounds ([3 x i8]* @.str19, i64 0, i64 0))
  %idx.ext173 = sext i32 %call172 to i64
  %add.ptr174 = getelementptr inbounds i8* %buf_ptr.2.lcssa, i64 %idx.ext173
  br label %if.end183

if.else175:                                       ; preds = %if.then165
  %call179 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.2.lcssa, i64 %sub.ptr.sub171, i8* getelementptr inbounds ([2 x i8]* @.str20, i64 0, i64 0))
  %idx.ext180 = sext i32 %call179 to i64
  %add.ptr181 = getelementptr inbounds i8* %buf_ptr.2.lcssa, i64 %idx.ext180
  br label %if.end183

if.end183:                                        ; preds = %if.then168, %if.else175, %for.end163
  %buf_ptr.4 = phi i8* [ %add.ptr174, %if.then168 ], [ %add.ptr181, %if.else175 ], [ %buf_ptr.2.lcssa, %for.end163 ]
  br i1 %cmp104, label %if.then185, label %if.end397

if.then185:                                       ; preds = %if.end183
  %cmp186 = icmp ult i8* %buf_ptr.4, %arrayidx93
  br i1 %cmp186, label %if.then187, label %for.cond207.preheader

if.then187:                                       ; preds = %if.then185
  %45 = load i32* %vector_width114, align 4, !tbaa !8
  %cmp189 = icmp sgt i32 %45, 1
  %sub.ptr.lhs.cast191 = ptrtoint i8* %arrayidx93 to i64
  %sub.ptr.rhs.cast192 = ptrtoint i8* %buf_ptr.4 to i64
  %sub.ptr.sub193 = sub i64 %sub.ptr.lhs.cast191, %sub.ptr.rhs.cast192
  br i1 %cmp189, label %if.then190, label %if.else197

if.then190:                                       ; preds = %if.then187
  %call194 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.4, i64 %sub.ptr.sub193, i8* getelementptr inbounds ([5 x i8]* @.str21, i64 0, i64 0))
  %idx.ext195 = sext i32 %call194 to i64
  %add.ptr196 = getelementptr inbounds i8* %buf_ptr.4, i64 %idx.ext195
  br label %for.cond207.preheader

if.else197:                                       ; preds = %if.then187
  %call201 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.4, i64 %sub.ptr.sub193, i8* getelementptr inbounds ([4 x i8]* @.str22, i64 0, i64 0))
  %idx.ext202 = sext i32 %call201 to i64
  %add.ptr203 = getelementptr inbounds i8* %buf_ptr.4, i64 %idx.ext202
  br label %for.cond207.preheader

for.cond207.preheader:                            ; preds = %if.then190, %if.else197, %if.then185
  %buf_ptr.6.ph = phi i8* [ %buf_ptr.4, %if.then185 ], [ %add.ptr203, %if.else197 ], [ %add.ptr196, %if.then190 ]
  %46 = load i32* %vector_width114, align 4, !tbaa !8
  %cmp209587 = icmp sgt i32 %46, 0
  %cmp211588 = icmp ult i8* %buf_ptr.6.ph, %arrayidx93
  %or.cond584589 = and i1 %cmp209587, %cmp211588
  br i1 %or.cond584589, label %for.body213.lr.ph, label %for.end384

for.body213.lr.ph:                                ; preds = %for.cond207.preheader
  %sub.ptr.lhs.cast216 = ptrtoint i8* %arrayidx93 to i64
  %type_code223 = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 3
  %cmp252 = icmp eq i32 %print_bits.0, 32
  %value258 = getelementptr inbounds %struct.halide_trace_event* %e, i64 0, i32 7
  %cmp339 = icmp sgt i32 %print_bits.0, 31
  br label %for.body213

for.body213:                                      ; preds = %for.body213.lr.ph, %for.inc382
  %indvars.iv = phi i64 [ 0, %for.body213.lr.ph ], [ %indvars.iv.next, %for.inc382 ]
  %buf_ptr.6590 = phi i8* [ %buf_ptr.6.ph, %for.body213.lr.ph ], [ %buf_ptr.8, %for.inc382 ]
  %47 = trunc i64 %indvars.iv to i32
  %cmp214 = icmp sgt i32 %47, 0
  br i1 %cmp214, label %if.then215, label %if.end222

if.then215:                                       ; preds = %for.body213
  %sub.ptr.rhs.cast217 = ptrtoint i8* %buf_ptr.6590 to i64
  %sub.ptr.sub218 = sub i64 %sub.ptr.lhs.cast216, %sub.ptr.rhs.cast217
  %call219 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.6590, i64 %sub.ptr.sub218, i8* getelementptr inbounds ([3 x i8]* @.str17, i64 0, i64 0))
  %idx.ext220 = sext i32 %call219 to i64
  %add.ptr221 = getelementptr inbounds i8* %buf_ptr.6590, i64 %idx.ext220
  br label %if.end222

if.end222:                                        ; preds = %if.then215, %for.body213
  %buf_ptr.7 = phi i8* [ %add.ptr221, %if.then215 ], [ %buf_ptr.6590, %for.body213 ]
  %48 = load i32* %type_code223, align 4, !tbaa !18
  switch i32 %48, label %for.inc382 [
    i32 0, label %if.then225
    i32 1, label %if.then280
    i32 2, label %if.then338
    i32 3, label %if.then368
  ]

if.then225:                                       ; preds = %if.end222
  switch i32 %print_bits.0, label %if.else251 [
    i32 8, label %if.then227
    i32 16, label %if.then240
  ]

if.then227:                                       ; preds = %if.then225
  %sub.ptr.rhs.cast229 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub230 = sub i64 %sub.ptr.lhs.cast216, %sub.ptr.rhs.cast229
  %49 = load i8** %value258, align 8, !tbaa !21
  %arrayidx233 = getelementptr inbounds i8* %49, i64 %indvars.iv
  %50 = load i8* %arrayidx233, align 1, !tbaa !17
  %conv234 = sext i8 %50 to i32
  %call235 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub230, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %conv234)
  %idx.ext236 = sext i32 %call235 to i64
  %add.ptr237 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext236
  br label %for.inc382

if.then240:                                       ; preds = %if.then225
  %sub.ptr.rhs.cast242 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub243 = sub i64 %sub.ptr.lhs.cast216, %sub.ptr.rhs.cast242
  %51 = load i8** %value258, align 8, !tbaa !21
  %52 = bitcast i8* %51 to i16*
  %arrayidx246 = getelementptr inbounds i16* %52, i64 %indvars.iv
  %53 = load i16* %arrayidx246, align 2, !tbaa !23
  %conv247 = sext i16 %53 to i32
  %call248 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub243, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %conv247)
  %idx.ext249 = sext i32 %call248 to i64
  %add.ptr250 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext249
  br label %for.inc382

if.else251:                                       ; preds = %if.then225
  %sub.ptr.rhs.cast255 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub256 = sub i64 %sub.ptr.lhs.cast216, %sub.ptr.rhs.cast255
  %54 = load i8** %value258, align 8, !tbaa !21
  br i1 %cmp252, label %if.then253, label %if.else263

if.then253:                                       ; preds = %if.else251
  %55 = bitcast i8* %54 to i32*
  %arrayidx259 = getelementptr inbounds i32* %55, i64 %indvars.iv
  %56 = load i32* %arrayidx259, align 4, !tbaa !14
  %call260 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub256, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %56)
  %idx.ext261 = sext i32 %call260 to i64
  %add.ptr262 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext261
  br label %for.inc382

if.else263:                                       ; preds = %if.else251
  %57 = bitcast i8* %54 to i64*
  %arrayidx269 = getelementptr inbounds i64* %57, i64 %indvars.iv
  %58 = load i64* %arrayidx269, align 8, !tbaa !25
  %conv270 = trunc i64 %58 to i32
  %call271 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub256, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %conv270)
  %idx.ext272 = sext i32 %call271 to i64
  %add.ptr273 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext272
  br label %for.inc382

if.then280:                                       ; preds = %if.end222
  switch i32 %print_bits.0, label %if.else309 [
    i32 8, label %if.then282
    i32 16, label %if.then298
  ]

if.then282:                                       ; preds = %if.then280
  %sub.ptr.rhs.cast284 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub285 = sub i64 %sub.ptr.lhs.cast216, %sub.ptr.rhs.cast284
  %59 = load i8** %value258, align 8, !tbaa !21
  %arrayidx288 = getelementptr inbounds i8* %59, i64 %indvars.iv
  %60 = load i8* %arrayidx288, align 1, !tbaa !17
  %conv289 = zext i8 %60 to i32
  %call290 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub285, i8* getelementptr inbounds ([3 x i8]* @.str23, i64 0, i64 0), i32 %conv289)
  %idx.ext291 = sext i32 %call290 to i64
  %add.ptr292 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext291
  %cmp293 = icmp ugt i8* %add.ptr292, %arrayidx93
  %arrayidx93.add.ptr292 = select i1 %cmp293, i8* %arrayidx93, i8* %add.ptr292
  br label %for.inc382

if.then298:                                       ; preds = %if.then280
  %sub.ptr.rhs.cast300 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub301 = sub i64 %sub.ptr.lhs.cast216, %sub.ptr.rhs.cast300
  %61 = load i8** %value258, align 8, !tbaa !21
  %62 = bitcast i8* %61 to i16*
  %arrayidx304 = getelementptr inbounds i16* %62, i64 %indvars.iv
  %63 = load i16* %arrayidx304, align 2, !tbaa !23
  %conv305 = zext i16 %63 to i32
  %call306 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub301, i8* getelementptr inbounds ([3 x i8]* @.str23, i64 0, i64 0), i32 %conv305)
  %idx.ext307 = sext i32 %call306 to i64
  %add.ptr308 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext307
  br label %for.inc382

if.else309:                                       ; preds = %if.then280
  %sub.ptr.rhs.cast313 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub314 = sub i64 %sub.ptr.lhs.cast216, %sub.ptr.rhs.cast313
  %64 = load i8** %value258, align 8, !tbaa !21
  br i1 %cmp252, label %if.then311, label %if.else321

if.then311:                                       ; preds = %if.else309
  %65 = bitcast i8* %64 to i32*
  %arrayidx317 = getelementptr inbounds i32* %65, i64 %indvars.iv
  %66 = load i32* %arrayidx317, align 4, !tbaa !14
  %call318 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub314, i8* getelementptr inbounds ([3 x i8]* @.str23, i64 0, i64 0), i32 %66)
  %idx.ext319 = sext i32 %call318 to i64
  %add.ptr320 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext319
  br label %for.inc382

if.else321:                                       ; preds = %if.else309
  %67 = bitcast i8* %64 to i64*
  %arrayidx327 = getelementptr inbounds i64* %67, i64 %indvars.iv
  %68 = load i64* %arrayidx327, align 8, !tbaa !25
  %conv328 = trunc i64 %68 to i32
  %call329 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub314, i8* getelementptr inbounds ([3 x i8]* @.str23, i64 0, i64 0), i32 %conv328)
  %idx.ext330 = sext i32 %call329 to i64
  %add.ptr331 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext330
  br label %for.inc382

if.then338:                                       ; preds = %if.end222
  br i1 %cmp339, label %if.end341, label %if.then340

if.then340:                                       ; preds = %if.then338
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([41 x i8]* @.str24, i64 0, i64 0))
  br label %if.end341

if.end341:                                        ; preds = %if.then340, %if.then338
  %sub.ptr.rhs.cast345 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub346 = sub i64 %sub.ptr.lhs.cast216, %sub.ptr.rhs.cast345
  %69 = load i8** %value258, align 8, !tbaa !21
  br i1 %cmp252, label %if.then343, label %if.else354

if.then343:                                       ; preds = %if.end341
  %70 = bitcast i8* %69 to float*
  %arrayidx349 = getelementptr inbounds float* %70, i64 %indvars.iv
  %71 = load float* %arrayidx349, align 4, !tbaa !27
  %conv350 = fpext float %71 to double
  %call351 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub346, i8* getelementptr inbounds ([3 x i8]* @.str25, i64 0, i64 0), double %conv350)
  %idx.ext352 = sext i32 %call351 to i64
  %add.ptr353 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext352
  br label %for.inc382

if.else354:                                       ; preds = %if.end341
  %72 = bitcast i8* %69 to double*
  %arrayidx360 = getelementptr inbounds double* %72, i64 %indvars.iv
  %73 = load double* %arrayidx360, align 8, !tbaa !29
  %call361 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub346, i8* getelementptr inbounds ([3 x i8]* @.str25, i64 0, i64 0), double %73)
  %idx.ext362 = sext i32 %call361 to i64
  %add.ptr363 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext362
  br label %for.inc382

if.then368:                                       ; preds = %if.end222
  %sub.ptr.rhs.cast370 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub371 = sub i64 %sub.ptr.lhs.cast216, %sub.ptr.rhs.cast370
  %74 = load i8** %value258, align 8, !tbaa !21
  %75 = bitcast i8* %74 to i8**
  %arrayidx374 = getelementptr inbounds i8** %75, i64 %indvars.iv
  %76 = load i8** %arrayidx374, align 8, !tbaa !1
  %call375 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub371, i8* getelementptr inbounds ([3 x i8]* @.str26, i64 0, i64 0), i8* %76)
  %idx.ext376 = sext i32 %call375 to i64
  %add.ptr377 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext376
  br label %for.inc382

for.inc382:                                       ; preds = %if.then282, %if.end222, %if.then240, %if.else263, %if.then253, %if.then227, %if.else354, %if.then343, %if.then368, %if.then311, %if.else321, %if.then298
  %buf_ptr.8 = phi i8* [ %add.ptr237, %if.then227 ], [ %add.ptr250, %if.then240 ], [ %add.ptr262, %if.then253 ], [ %add.ptr273, %if.else263 ], [ %add.ptr308, %if.then298 ], [ %add.ptr320, %if.then311 ], [ %add.ptr331, %if.else321 ], [ %add.ptr353, %if.then343 ], [ %add.ptr363, %if.else354 ], [ %add.ptr377, %if.then368 ], [ %arrayidx93.add.ptr292, %if.then282 ], [ %buf_ptr.7, %if.end222 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %77 = load i32* %vector_width114, align 4, !tbaa !8
  %78 = trunc i64 %indvars.iv.next to i32
  %cmp209 = icmp slt i32 %78, %77
  %cmp211 = icmp ult i8* %buf_ptr.8, %arrayidx93
  %or.cond584 = and i1 %cmp209, %cmp211
  br i1 %or.cond584, label %for.body213, label %for.end384

for.end384:                                       ; preds = %for.inc382, %for.cond207.preheader
  %cmp211.lcssa = phi i1 [ %cmp211588, %for.cond207.preheader ], [ %cmp211, %for.inc382 ]
  %.lcssa = phi i32 [ %46, %for.cond207.preheader ], [ %77, %for.inc382 ]
  %buf_ptr.6.lcssa = phi i8* [ %buf_ptr.6.ph, %for.cond207.preheader ], [ %buf_ptr.8, %for.inc382 ]
  %cmp386 = icmp sgt i32 %.lcssa, 1
  %or.cond585 = and i1 %cmp386, %cmp211.lcssa
  br i1 %or.cond585, label %if.then389, label %if.end397

if.then389:                                       ; preds = %for.end384
  %sub.ptr.lhs.cast390 = ptrtoint i8* %arrayidx93 to i64
  %sub.ptr.rhs.cast391 = ptrtoint i8* %buf_ptr.6.lcssa to i64
  %sub.ptr.sub392 = sub i64 %sub.ptr.lhs.cast390, %sub.ptr.rhs.cast391
  %call393 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.6.lcssa, i64 %sub.ptr.sub392, i8* getelementptr inbounds ([2 x i8]* @.str27, i64 0, i64 0))
  br label %if.end397

if.end397:                                        ; preds = %for.end384, %if.then389, %if.end183
  %call399 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([4 x i8]* @.str28, i64 0, i64 0), i8* %29)
  call void @llvm.lifetime.end(i64 256, i8* %29) #4
  br label %return

return:                                           ; preds = %if.end397, %if.then89, %for.end85, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ %1, %for.end85 ], [ %1, %if.then89 ], [ %1, %if.end397 ]
  ret i32 %retval.0
}

; Function Attrs: nounwind readonly
declare i8* @getenv(i8* nocapture) #1

; Function Attrs: nounwind
declare noalias i8* @fopen(i8* nocapture readonly, i8* nocapture readonly) #2

declare void @halide_error(i8*, i8*) #3

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #4

; Function Attrs: nounwind
declare i64 @fwrite(i8* nocapture, i64, i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #4

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #4

; Function Attrs: nounwind
declare i32 @snprintf(i8* nocapture, i64, i8* nocapture readonly, ...) #2

declare i32 @halide_printf(i8*, i8*, ...) #3

; Function Attrs: uwtable
define weak i32 @halide_shutdown_trace() #0 {
entry:
  %0 = load i8** @halide_trace_file, align 8, !tbaa !1
  %tobool = icmp eq i8* %0, null
  br i1 %tobool, label %return, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call i32 @fclose(i8* %0)
  store i8* null, i8** @halide_trace_file, align 8, !tbaa !1
  store i8 0, i8* @halide_trace_initialized, align 1, !tbaa !5
  br label %return

return:                                           ; preds = %entry, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ 0, %entry ]
  ret i32 %retval.0
}

; Function Attrs: nounwind
declare i32 @fclose(i8* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) #4

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"bool", metadata !3, i64 0}
!7 = metadata !{i8 0, i8 2}
!8 = metadata !{metadata !9, metadata !11, i64 24}
!9 = metadata !{metadata !"_ZTS18halide_trace_event", metadata !2, i64 0, metadata !10, i64 8, metadata !11, i64 12, metadata !11, i64 16, metadata !11, i64 20, metadata !11, i64 24, metadata !11, i64 28, metadata !2, i64 32, metadata !11, i64 40, metadata !2, i64 48}
!10 = metadata !{metadata !"_ZTS23halide_trace_event_code", metadata !3, i64 0}
!11 = metadata !{metadata !"int", metadata !3, i64 0}
!12 = metadata !{metadata !9, metadata !11, i64 40}
!13 = metadata !{metadata !9, metadata !11, i64 20}
!14 = metadata !{metadata !11, metadata !11, i64 0}
!15 = metadata !{metadata !9, metadata !11, i64 12}
!16 = metadata !{metadata !9, metadata !10, i64 8}
!17 = metadata !{metadata !3, metadata !3, i64 0}
!18 = metadata !{metadata !9, metadata !11, i64 16}
!19 = metadata !{metadata !9, metadata !11, i64 28}
!20 = metadata !{metadata !9, metadata !2, i64 0}
!21 = metadata !{metadata !9, metadata !2, i64 32}
!22 = metadata !{metadata !9, metadata !2, i64 48}
!23 = metadata !{metadata !24, metadata !24, i64 0}
!24 = metadata !{metadata !"short", metadata !3, i64 0}
!25 = metadata !{metadata !26, metadata !26, i64 0}
!26 = metadata !{metadata !"long long", metadata !3, i64 0}
!27 = metadata !{metadata !28, metadata !28, i64 0}
!28 = metadata !{metadata !"float", metadata !3, i64 0}
!29 = metadata !{metadata !30, metadata !30, i64 0}
!30 = metadata !{metadata !"double", metadata !3, i64 0}
