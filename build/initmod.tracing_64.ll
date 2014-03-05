; ModuleID = 'src/runtime/tracing.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@halide_custom_trace = weak global i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)* null, align 8
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
define weak void @halide_set_custom_trace(i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)* %t) #0 {
entry:
  store i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)* %t, i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)** @halide_custom_trace, align 8, !tbaa !1
  ret void
}

; Function Attrs: uwtable
define weak i32 @halide_trace(i8* %user_context, i8* %func, i32 %event, i32 %parent_id, i32 %type_code, i32 %bits, i32 %width, i32 %value_idx, i8* %value, i32 %num_int_args, i32* %int_args) #0 {
entry:
  %0 = bitcast i32* %int_args to i8*
  %buffer = alloca [4096 x i8], align 16
  %buf = alloca [256 x i8], align 16
  %1 = load i32 (i8*, i8*, i32, i32, i32, i32, i32, i32, i8*, i32, i32*)** @halide_custom_trace, align 8, !tbaa !1
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
  br i1 %tobool11, label %if.else88, label %if.then12

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
  %conv22 = sext i32 %mul21 to i64
  %conv23 = zext i8 %conv18 to i64
  %mul24 = shl nuw nsw i64 %conv23, 2
  %add = add i64 %conv22, 32
  %add25 = add i64 %add, %mul24
  %6 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 0
  call void @llvm.lifetime.start(i64 4096, i8* %6) #4
  %cmp26 = icmp ult i64 %add25, 4097
  br i1 %cmp26, label %if.end28, label %if.then27

if.then27:                                        ; preds = %while.end
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([50 x i8]* @.str3, i64 0, i64 0))
  br label %if.end28

if.end28:                                         ; preds = %if.then27, %while.end
  %7 = bitcast [4096 x i8]* %buffer to i32*
  store i32 %2, i32* %7, align 16, !tbaa !8
  %arrayidx30 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 4
  %8 = bitcast i8* %arrayidx30 to i32*
  store i32 %parent_id, i32* %8, align 4, !tbaa !8
  %conv31 = trunc i32 %event to i8
  %arrayidx32 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 8
  store i8 %conv31, i8* %arrayidx32, align 8, !tbaa !10
  %conv33 = trunc i32 %type_code to i8
  %arrayidx34 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 9
  store i8 %conv33, i8* %arrayidx34, align 1, !tbaa !10
  %conv35 = trunc i32 %bits to i8
  %arrayidx36 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 10
  store i8 %conv35, i8* %arrayidx36, align 2, !tbaa !10
  %arrayidx37 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 11
  store i8 %conv, i8* %arrayidx37, align 1, !tbaa !10
  %conv38 = trunc i32 %value_idx to i8
  %arrayidx39 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 12
  store i8 %conv38, i8* %arrayidx39, align 4, !tbaa !10
  %arrayidx40 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 13
  store i8 %conv18, i8* %arrayidx40, align 1, !tbaa !10
  br label %for.body

for.cond:                                         ; preds = %for.body
  %9 = trunc i64 %indvars.iv.next592 to i32
  %cmp42 = icmp ult i32 %9, 31
  br i1 %cmp42, label %for.body, label %for.cond53.preheader

for.cond53.preheader:                             ; preds = %for.body, %for.cond
  %i.0.lcssa = phi i32 [ %i.0580, %for.body ], [ %inc, %for.cond ]
  %cmp55578 = icmp ult i32 %i.0.lcssa, 32
  br i1 %cmp55578, label %for.body56.lr.ph, label %for.cond63.preheader

for.body56.lr.ph:                                 ; preds = %for.cond53.preheader
  %10 = sext i32 %i.0.lcssa to i64
  %scevgep590 = getelementptr [4096 x i8]* %buffer, i64 0, i64 %10
  %11 = sub i32 31, %i.0.lcssa
  %12 = zext i32 %11 to i64
  %13 = add i64 %12, 1
  call void @llvm.memset.p0i8.i64(i8* %scevgep590, i8 0, i64 %13, i32 1, i1 false)
  br label %for.cond63.preheader

for.body:                                         ; preds = %if.end28, %for.cond
  %indvars.iv591 = phi i64 [ 14, %if.end28 ], [ %indvars.iv.next592, %for.cond ]
  %i.0580 = phi i32 [ 14, %if.end28 ], [ %inc, %for.cond ]
  %14 = add nsw i64 %indvars.iv591, -14
  %arrayidx44 = getelementptr inbounds i8* %func, i64 %14
  %15 = load i8* %arrayidx44, align 1, !tbaa !10
  %arrayidx46 = getelementptr inbounds [4096 x i8]* %buffer, i64 0, i64 %indvars.iv591
  store i8 %15, i8* %arrayidx46, align 1, !tbaa !10
  %cmp50 = icmp eq i8 %15, 0
  %indvars.iv.next592 = add nuw nsw i64 %indvars.iv591, 1
  %inc = add nsw i32 %i.0580, 1
  br i1 %cmp50, label %for.cond53.preheader, label %for.cond

for.cond63.preheader:                             ; preds = %for.body56.lr.ph, %for.cond53.preheader
  %cmp64576 = icmp eq i32 %mul21, 0
  br i1 %cmp64576, label %for.cond73.preheader, label %for.body65.lr.ph

for.body65.lr.ph:                                 ; preds = %for.cond63.preheader
  %scevgep586 = getelementptr [4096 x i8]* %buffer, i64 0, i64 32
  %16 = icmp ugt i64 %conv22, 1
  %umax587 = select i1 %16, i64 %conv22, i64 1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %scevgep586, i8* %value, i64 %umax587, i32 1, i1 false)
  br label %for.cond73.preheader

for.cond73.preheader:                             ; preds = %for.cond63.preheader, %for.body65.lr.ph
  %cmp74574 = icmp eq i8 %conv18, 0
  br i1 %cmp74574, label %for.end82, label %for.body75.lr.ph

for.body75.lr.ph:                                 ; preds = %for.cond73.preheader
  %scevgep.sum = add i64 %conv22, 32
  %scevgep585 = getelementptr [4096 x i8]* %buffer, i64 0, i64 %scevgep.sum
  %17 = shl nuw nsw i64 %conv23, 2
  %18 = icmp ugt i64 %17, 1
  %umax = select i1 %18, i64 %17, i64 1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %scevgep585, i8* %0, i64 %umax, i32 1, i1 false)
  br label %for.end82

for.end82:                                        ; preds = %for.cond73.preheader, %for.body75.lr.ph
  %19 = load i8** @halide_trace_file, align 8, !tbaa !1
  %call84 = call i64 @fwrite(i8* %6, i64 1, i64 %add25, i8* %19)
  %cmp85 = icmp eq i64 %call84, %add25
  br i1 %cmp85, label %return, label %if.then86

if.then86:                                        ; preds = %for.end82
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([54 x i8]* @.str4, i64 0, i64 0))
  br label %return

if.else88:                                        ; preds = %if.end10
  %20 = getelementptr inbounds [256 x i8]* %buf, i64 0, i64 0
  call void @llvm.lifetime.start(i64 256, i8* %20) #4
  br label %while.cond91

while.cond91:                                     ; preds = %while.cond91, %if.else88
  %print_bits.0 = phi i32 [ 8, %if.else88 ], [ %shl94, %while.cond91 ]
  %cmp92 = icmp slt i32 %print_bits.0, %bits
  %shl94 = shl i32 %print_bits.0, 1
  br i1 %cmp92, label %while.cond91, label %while.end95

while.end95:                                      ; preds = %while.cond91
  %arrayidx90 = getelementptr inbounds [256 x i8]* %buf, i64 0, i64 255
  %cmp96 = icmp slt i32 %print_bits.0, 65
  br i1 %cmp96, label %if.end98, label %if.then97

if.then97:                                        ; preds = %while.end95
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([39 x i8]* @.str5, i64 0, i64 0))
  br label %if.end98

if.end98:                                         ; preds = %if.then97, %while.end95
  %cmp99 = icmp slt i32 %event, 2
  %idxprom102 = zext i32 %event to i64
  %arrayidx103 = getelementptr inbounds [8 x i8*]* @_ZZ12halide_traceE11event_types, i64 0, i64 %idxprom102
  %21 = load i8** %arrayidx103, align 8, !tbaa !1
  %call104 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %20, i64 255, i8* getelementptr inbounds ([10 x i8]* @.str14, i64 0, i64 0), i8* %21, i8* %func, i32 %value_idx)
  %idx.ext = sext i32 %call104 to i64
  %add.ptr = getelementptr inbounds [256 x i8]* %buf, i64 0, i64 %idx.ext
  %cmp106 = icmp sgt i32 %width, 1
  br i1 %cmp106, label %if.then107, label %for.cond116.preheader

if.then107:                                       ; preds = %if.end98
  %22 = sub i64 255, %idx.ext
  %call111 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %add.ptr, i64 %22, i8* getelementptr inbounds ([2 x i8]* @.str15, i64 0, i64 0))
  %idx.ext112 = sext i32 %call111 to i64
  %add.ptr.sum = add i64 %idx.ext112, %idx.ext
  %add.ptr113 = getelementptr inbounds [256 x i8]* %buf, i64 0, i64 %add.ptr.sum
  br label %for.cond116.preheader

for.cond116.preheader:                            ; preds = %if.then107, %if.end98
  %buf_ptr.2.ph = phi i8* [ %add.ptr, %if.end98 ], [ %add.ptr113, %if.then107 ]
  %cmp117567 = icmp sgt i32 %num_int_args, 0
  %cmp118568 = icmp ult i8* %buf_ptr.2.ph, %arrayidx90
  %or.cond569 = and i1 %cmp117567, %cmp118568
  br i1 %or.cond569, label %for.body119.lr.ph, label %for.end150

for.body119.lr.ph:                                ; preds = %for.cond116.preheader
  %sub.ptr.lhs.cast125 = ptrtoint i8* %arrayidx90 to i64
  br i1 %cmp106, label %for.body119.us, label %for.body119

for.body119.us:                                   ; preds = %for.body119.lr.ph, %if.end139.us
  %indvars.iv594 = phi i64 [ %indvars.iv.next595, %if.end139.us ], [ 0, %for.body119.lr.ph ]
  %buf_ptr.2570.us = phi i8* [ %add.ptr147.us, %if.end139.us ], [ %buf_ptr.2.ph, %for.body119.lr.ph ]
  %23 = trunc i64 %indvars.iv594 to i32
  %cmp120.us = icmp sgt i32 %23, 0
  br i1 %cmp120.us, label %land.lhs.true.us, label %if.end139.us

land.lhs.true.us:                                 ; preds = %for.body119.us
  %rem.us = srem i32 %23, %width
  %cmp123.us = icmp eq i32 %rem.us, 0
  %sub.ptr.rhs.cast126.us = ptrtoint i8* %buf_ptr.2570.us to i64
  %sub.ptr.sub127.us = sub i64 %sub.ptr.lhs.cast125, %sub.ptr.rhs.cast126.us
  br i1 %cmp123.us, label %if.then124.us, label %if.else131.us

if.else131.us:                                    ; preds = %land.lhs.true.us
  %call135.us = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.2570.us, i64 %sub.ptr.sub127.us, i8* getelementptr inbounds ([3 x i8]* @.str17, i64 0, i64 0))
  %idx.ext136.us = sext i32 %call135.us to i64
  %add.ptr137.us = getelementptr inbounds i8* %buf_ptr.2570.us, i64 %idx.ext136.us
  br label %if.end139.us

if.then124.us:                                    ; preds = %land.lhs.true.us
  %call128.us = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.2570.us, i64 %sub.ptr.sub127.us, i8* getelementptr inbounds ([5 x i8]* @.str16, i64 0, i64 0))
  %idx.ext129.us = sext i32 %call128.us to i64
  %add.ptr130.us = getelementptr inbounds i8* %buf_ptr.2570.us, i64 %idx.ext129.us
  br label %if.end139.us

if.end139.us:                                     ; preds = %if.then124.us, %if.else131.us, %for.body119.us
  %buf_ptr.3.us = phi i8* [ %add.ptr130.us, %if.then124.us ], [ %add.ptr137.us, %if.else131.us ], [ %buf_ptr.2570.us, %for.body119.us ]
  %sub.ptr.rhs.cast141.us = ptrtoint i8* %buf_ptr.3.us to i64
  %sub.ptr.sub142.us = sub i64 %sub.ptr.lhs.cast125, %sub.ptr.rhs.cast141.us
  %arrayidx144.us = getelementptr inbounds i32* %int_args, i64 %indvars.iv594
  %24 = load i32* %arrayidx144.us, align 4, !tbaa !8
  %call145.us = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.3.us, i64 %sub.ptr.sub142.us, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %24)
  %idx.ext146.us = sext i32 %call145.us to i64
  %add.ptr147.us = getelementptr inbounds i8* %buf_ptr.3.us, i64 %idx.ext146.us
  %indvars.iv.next595 = add nuw nsw i64 %indvars.iv594, 1
  %25 = trunc i64 %indvars.iv.next595 to i32
  %cmp117.us = icmp slt i32 %25, %num_int_args
  %cmp118.us = icmp ult i8* %add.ptr147.us, %arrayidx90
  %or.cond.us = and i1 %cmp117.us, %cmp118.us
  br i1 %or.cond.us, label %for.body119.us, label %for.end150

for.body119:                                      ; preds = %for.body119.lr.ph, %if.end139
  %indvars.iv583 = phi i64 [ %indvars.iv.next584, %if.end139 ], [ 0, %for.body119.lr.ph ]
  %buf_ptr.2570 = phi i8* [ %add.ptr147, %if.end139 ], [ %buf_ptr.2.ph, %for.body119.lr.ph ]
  %26 = trunc i64 %indvars.iv583 to i32
  %cmp120 = icmp sgt i32 %26, 0
  br i1 %cmp120, label %if.else131, label %if.end139

if.else131:                                       ; preds = %for.body119
  %sub.ptr.rhs.cast133 = ptrtoint i8* %buf_ptr.2570 to i64
  %sub.ptr.sub134 = sub i64 %sub.ptr.lhs.cast125, %sub.ptr.rhs.cast133
  %call135 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.2570, i64 %sub.ptr.sub134, i8* getelementptr inbounds ([3 x i8]* @.str17, i64 0, i64 0))
  %idx.ext136 = sext i32 %call135 to i64
  %add.ptr137 = getelementptr inbounds i8* %buf_ptr.2570, i64 %idx.ext136
  br label %if.end139

if.end139:                                        ; preds = %if.else131, %for.body119
  %buf_ptr.3 = phi i8* [ %add.ptr137, %if.else131 ], [ %buf_ptr.2570, %for.body119 ]
  %sub.ptr.rhs.cast141 = ptrtoint i8* %buf_ptr.3 to i64
  %sub.ptr.sub142 = sub i64 %sub.ptr.lhs.cast125, %sub.ptr.rhs.cast141
  %arrayidx144 = getelementptr inbounds i32* %int_args, i64 %indvars.iv583
  %27 = load i32* %arrayidx144, align 4, !tbaa !8
  %call145 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.3, i64 %sub.ptr.sub142, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %27)
  %idx.ext146 = sext i32 %call145 to i64
  %add.ptr147 = getelementptr inbounds i8* %buf_ptr.3, i64 %idx.ext146
  %indvars.iv.next584 = add nuw nsw i64 %indvars.iv583, 1
  %28 = trunc i64 %indvars.iv.next584 to i32
  %cmp117 = icmp slt i32 %28, %num_int_args
  %cmp118 = icmp ult i8* %add.ptr147, %arrayidx90
  %or.cond = and i1 %cmp117, %cmp118
  br i1 %or.cond, label %for.body119, label %for.end150

for.end150:                                       ; preds = %if.end139, %if.end139.us, %for.cond116.preheader
  %cmp118.lcssa = phi i1 [ %cmp118568, %for.cond116.preheader ], [ %cmp118.us, %if.end139.us ], [ %cmp118, %if.end139 ]
  %buf_ptr.2.lcssa = phi i8* [ %buf_ptr.2.ph, %for.cond116.preheader ], [ %add.ptr147.us, %if.end139.us ], [ %add.ptr147, %if.end139 ]
  br i1 %cmp118.lcssa, label %if.then152, label %if.end169

if.then152:                                       ; preds = %for.end150
  %sub.ptr.lhs.cast155 = ptrtoint i8* %arrayidx90 to i64
  %sub.ptr.rhs.cast156 = ptrtoint i8* %buf_ptr.2.lcssa to i64
  %sub.ptr.sub157 = sub i64 %sub.ptr.lhs.cast155, %sub.ptr.rhs.cast156
  br i1 %cmp106, label %if.then154, label %if.else161

if.then154:                                       ; preds = %if.then152
  %call158 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.2.lcssa, i64 %sub.ptr.sub157, i8* getelementptr inbounds ([3 x i8]* @.str19, i64 0, i64 0))
  %idx.ext159 = sext i32 %call158 to i64
  %add.ptr160 = getelementptr inbounds i8* %buf_ptr.2.lcssa, i64 %idx.ext159
  br label %if.end169

if.else161:                                       ; preds = %if.then152
  %call165 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.2.lcssa, i64 %sub.ptr.sub157, i8* getelementptr inbounds ([2 x i8]* @.str20, i64 0, i64 0))
  %idx.ext166 = sext i32 %call165 to i64
  %add.ptr167 = getelementptr inbounds i8* %buf_ptr.2.lcssa, i64 %idx.ext166
  br label %if.end169

if.end169:                                        ; preds = %if.then154, %if.else161, %for.end150
  %buf_ptr.4 = phi i8* [ %add.ptr160, %if.then154 ], [ %add.ptr167, %if.else161 ], [ %buf_ptr.2.lcssa, %for.end150 ]
  br i1 %cmp99, label %if.then171, label %if.end365

if.then171:                                       ; preds = %if.end169
  %cmp172 = icmp ult i8* %buf_ptr.4, %arrayidx90
  br i1 %cmp172, label %if.then173, label %for.cond192.preheader

if.then173:                                       ; preds = %if.then171
  %sub.ptr.lhs.cast176 = ptrtoint i8* %arrayidx90 to i64
  %sub.ptr.rhs.cast177 = ptrtoint i8* %buf_ptr.4 to i64
  %sub.ptr.sub178 = sub i64 %sub.ptr.lhs.cast176, %sub.ptr.rhs.cast177
  br i1 %cmp106, label %if.then175, label %if.else182

if.then175:                                       ; preds = %if.then173
  %call179 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.4, i64 %sub.ptr.sub178, i8* getelementptr inbounds ([5 x i8]* @.str21, i64 0, i64 0))
  %idx.ext180 = sext i32 %call179 to i64
  %add.ptr181 = getelementptr inbounds i8* %buf_ptr.4, i64 %idx.ext180
  br label %for.cond192.preheader

if.else182:                                       ; preds = %if.then173
  %call186 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.4, i64 %sub.ptr.sub178, i8* getelementptr inbounds ([4 x i8]* @.str22, i64 0, i64 0))
  %idx.ext187 = sext i32 %call186 to i64
  %add.ptr188 = getelementptr inbounds i8* %buf_ptr.4, i64 %idx.ext187
  br label %for.cond192.preheader

for.cond192.preheader:                            ; preds = %if.then175, %if.else182, %if.then171
  %buf_ptr.6.ph = phi i8* [ %buf_ptr.4, %if.then171 ], [ %add.ptr188, %if.else182 ], [ %add.ptr181, %if.then175 ]
  %cmp193561 = icmp sgt i32 %width, 0
  %cmp195562 = icmp ult i8* %buf_ptr.6.ph, %arrayidx90
  %or.cond551563 = and i1 %cmp193561, %cmp195562
  br i1 %or.cond551563, label %for.body197.lr.ph, label %for.end353

for.body197.lr.ph:                                ; preds = %for.cond192.preheader
  %sub.ptr.lhs.cast200 = ptrtoint i8* %arrayidx90 to i64
  %cmp233 = icmp eq i32 %print_bits.0, 32
  %29 = bitcast i8* %value to i32*
  %30 = bitcast i8* %value to i64*
  %31 = bitcast i8* %value to i16*
  %cmp312 = icmp sgt i32 %print_bits.0, 31
  %32 = bitcast i8* %value to float*
  %33 = bitcast i8* %value to double*
  %34 = bitcast i8* %value to i8**
  br label %for.body197

for.body197:                                      ; preds = %for.body197.lr.ph, %for.inc351
  %indvars.iv = phi i64 [ 0, %for.body197.lr.ph ], [ %indvars.iv.next, %for.inc351 ]
  %buf_ptr.6564 = phi i8* [ %buf_ptr.6.ph, %for.body197.lr.ph ], [ %buf_ptr.8, %for.inc351 ]
  %35 = trunc i64 %indvars.iv to i32
  %cmp198 = icmp sgt i32 %35, 0
  br i1 %cmp198, label %if.then199, label %if.end206

if.then199:                                       ; preds = %for.body197
  %sub.ptr.rhs.cast201 = ptrtoint i8* %buf_ptr.6564 to i64
  %sub.ptr.sub202 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast201
  %call203 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.6564, i64 %sub.ptr.sub202, i8* getelementptr inbounds ([3 x i8]* @.str17, i64 0, i64 0))
  %idx.ext204 = sext i32 %call203 to i64
  %add.ptr205 = getelementptr inbounds i8* %buf_ptr.6564, i64 %idx.ext204
  br label %if.end206

if.end206:                                        ; preds = %if.then199, %for.body197
  %buf_ptr.7 = phi i8* [ %add.ptr205, %if.then199 ], [ %buf_ptr.6564, %for.body197 ]
  switch i32 %type_code, label %for.inc351 [
    i32 0, label %if.then208
    i32 1, label %if.then258
    i32 2, label %if.then311
    i32 3, label %if.then338
  ]

if.then208:                                       ; preds = %if.end206
  switch i32 %print_bits.0, label %if.else232 [
    i32 8, label %if.then210
    i32 16, label %if.then222
  ]

if.then210:                                       ; preds = %if.then208
  %sub.ptr.rhs.cast212 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub213 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast212
  %arrayidx215 = getelementptr inbounds i8* %value, i64 %indvars.iv
  %36 = load i8* %arrayidx215, align 1, !tbaa !10
  %conv216 = sext i8 %36 to i32
  %call217 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub213, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %conv216)
  %idx.ext218 = sext i32 %call217 to i64
  %add.ptr219 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext218
  br label %for.inc351

if.then222:                                       ; preds = %if.then208
  %sub.ptr.rhs.cast224 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub225 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast224
  %arrayidx227 = getelementptr inbounds i16* %31, i64 %indvars.iv
  %37 = load i16* %arrayidx227, align 2, !tbaa !11
  %conv228 = sext i16 %37 to i32
  %call229 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub225, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %conv228)
  %idx.ext230 = sext i32 %call229 to i64
  %add.ptr231 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext230
  br label %for.inc351

if.else232:                                       ; preds = %if.then208
  %sub.ptr.rhs.cast236 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub237 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast236
  br i1 %cmp233, label %if.then234, label %if.else243

if.then234:                                       ; preds = %if.else232
  %arrayidx239 = getelementptr inbounds i32* %29, i64 %indvars.iv
  %38 = load i32* %arrayidx239, align 4, !tbaa !8
  %call240 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub237, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %38)
  %idx.ext241 = sext i32 %call240 to i64
  %add.ptr242 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext241
  br label %for.inc351

if.else243:                                       ; preds = %if.else232
  %arrayidx248 = getelementptr inbounds i64* %30, i64 %indvars.iv
  %39 = load i64* %arrayidx248, align 8, !tbaa !13
  %conv249 = trunc i64 %39 to i32
  %call250 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub237, i8* getelementptr inbounds ([3 x i8]* @.str18, i64 0, i64 0), i32 %conv249)
  %idx.ext251 = sext i32 %call250 to i64
  %add.ptr252 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext251
  br label %for.inc351

if.then258:                                       ; preds = %if.end206
  switch i32 %print_bits.0, label %if.else285 [
    i32 8, label %if.then260
    i32 16, label %if.then275
  ]

if.then260:                                       ; preds = %if.then258
  %sub.ptr.rhs.cast262 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub263 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast262
  %arrayidx265 = getelementptr inbounds i8* %value, i64 %indvars.iv
  %40 = load i8* %arrayidx265, align 1, !tbaa !10
  %conv266 = zext i8 %40 to i32
  %call267 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub263, i8* getelementptr inbounds ([3 x i8]* @.str23, i64 0, i64 0), i32 %conv266)
  %idx.ext268 = sext i32 %call267 to i64
  %add.ptr269 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext268
  %cmp270 = icmp ugt i8* %add.ptr269, %arrayidx90
  %arrayidx90.add.ptr269 = select i1 %cmp270, i8* %arrayidx90, i8* %add.ptr269
  br label %for.inc351

if.then275:                                       ; preds = %if.then258
  %sub.ptr.rhs.cast277 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub278 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast277
  %arrayidx280 = getelementptr inbounds i16* %31, i64 %indvars.iv
  %41 = load i16* %arrayidx280, align 2, !tbaa !11
  %conv281 = zext i16 %41 to i32
  %call282 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub278, i8* getelementptr inbounds ([3 x i8]* @.str23, i64 0, i64 0), i32 %conv281)
  %idx.ext283 = sext i32 %call282 to i64
  %add.ptr284 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext283
  br label %for.inc351

if.else285:                                       ; preds = %if.then258
  %sub.ptr.rhs.cast289 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub290 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast289
  br i1 %cmp233, label %if.then287, label %if.else296

if.then287:                                       ; preds = %if.else285
  %arrayidx292 = getelementptr inbounds i32* %29, i64 %indvars.iv
  %42 = load i32* %arrayidx292, align 4, !tbaa !8
  %call293 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub290, i8* getelementptr inbounds ([3 x i8]* @.str23, i64 0, i64 0), i32 %42)
  %idx.ext294 = sext i32 %call293 to i64
  %add.ptr295 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext294
  br label %for.inc351

if.else296:                                       ; preds = %if.else285
  %arrayidx301 = getelementptr inbounds i64* %30, i64 %indvars.iv
  %43 = load i64* %arrayidx301, align 8, !tbaa !13
  %conv302 = trunc i64 %43 to i32
  %call303 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub290, i8* getelementptr inbounds ([3 x i8]* @.str23, i64 0, i64 0), i32 %conv302)
  %idx.ext304 = sext i32 %call303 to i64
  %add.ptr305 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext304
  br label %for.inc351

if.then311:                                       ; preds = %if.end206
  br i1 %cmp312, label %if.end314, label %if.end314.thread

if.end314.thread:                                 ; preds = %if.then311
  call void @halide_error(i8* %user_context, i8* getelementptr inbounds ([41 x i8]* @.str24, i64 0, i64 0))
  %sub.ptr.rhs.cast318556 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub319557 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast318556
  br label %if.else326

if.end314:                                        ; preds = %if.then311
  %sub.ptr.rhs.cast318 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub319 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast318
  br i1 %cmp233, label %if.then316, label %if.else326

if.then316:                                       ; preds = %if.end314
  %arrayidx321 = getelementptr inbounds float* %32, i64 %indvars.iv
  %44 = load float* %arrayidx321, align 4, !tbaa !15
  %conv322 = fpext float %44 to double
  %call323 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub319, i8* getelementptr inbounds ([3 x i8]* @.str25, i64 0, i64 0), double %conv322)
  %idx.ext324 = sext i32 %call323 to i64
  %add.ptr325 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext324
  br label %for.inc351

if.else326:                                       ; preds = %if.end314.thread, %if.end314
  %sub.ptr.sub319559 = phi i64 [ %sub.ptr.sub319557, %if.end314.thread ], [ %sub.ptr.sub319, %if.end314 ]
  %arrayidx331 = getelementptr inbounds double* %33, i64 %indvars.iv
  %45 = load double* %arrayidx331, align 8, !tbaa !17
  %call332 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub319559, i8* getelementptr inbounds ([3 x i8]* @.str25, i64 0, i64 0), double %45)
  %idx.ext333 = sext i32 %call332 to i64
  %add.ptr334 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext333
  br label %for.inc351

if.then338:                                       ; preds = %if.end206
  %sub.ptr.rhs.cast340 = ptrtoint i8* %buf_ptr.7 to i64
  %sub.ptr.sub341 = sub i64 %sub.ptr.lhs.cast200, %sub.ptr.rhs.cast340
  %arrayidx343 = getelementptr inbounds i8** %34, i64 %indvars.iv
  %46 = load i8** %arrayidx343, align 8, !tbaa !1
  %call344 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.7, i64 %sub.ptr.sub341, i8* getelementptr inbounds ([3 x i8]* @.str26, i64 0, i64 0), i8* %46)
  %idx.ext345 = sext i32 %call344 to i64
  %add.ptr346 = getelementptr inbounds i8* %buf_ptr.7, i64 %idx.ext345
  br label %for.inc351

for.inc351:                                       ; preds = %if.then260, %if.end206, %if.then222, %if.else243, %if.then234, %if.then210, %if.else326, %if.then316, %if.then338, %if.then287, %if.else296, %if.then275
  %buf_ptr.8 = phi i8* [ %add.ptr219, %if.then210 ], [ %add.ptr231, %if.then222 ], [ %add.ptr242, %if.then234 ], [ %add.ptr252, %if.else243 ], [ %add.ptr284, %if.then275 ], [ %add.ptr295, %if.then287 ], [ %add.ptr305, %if.else296 ], [ %add.ptr325, %if.then316 ], [ %add.ptr334, %if.else326 ], [ %add.ptr346, %if.then338 ], [ %arrayidx90.add.ptr269, %if.then260 ], [ %buf_ptr.7, %if.end206 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %47 = trunc i64 %indvars.iv.next to i32
  %cmp193 = icmp slt i32 %47, %width
  %cmp195 = icmp ult i8* %buf_ptr.8, %arrayidx90
  %or.cond551 = and i1 %cmp193, %cmp195
  br i1 %or.cond551, label %for.body197, label %for.end353

for.end353:                                       ; preds = %for.inc351, %for.cond192.preheader
  %cmp195.lcssa = phi i1 [ %cmp195562, %for.cond192.preheader ], [ %cmp195, %for.inc351 ]
  %buf_ptr.6.lcssa = phi i8* [ %buf_ptr.6.ph, %for.cond192.preheader ], [ %buf_ptr.8, %for.inc351 ]
  %or.cond552 = and i1 %cmp106, %cmp195.lcssa
  br i1 %or.cond552, label %if.then357, label %if.end365

if.then357:                                       ; preds = %for.end353
  %sub.ptr.lhs.cast358 = ptrtoint i8* %arrayidx90 to i64
  %sub.ptr.rhs.cast359 = ptrtoint i8* %buf_ptr.6.lcssa to i64
  %sub.ptr.sub360 = sub i64 %sub.ptr.lhs.cast358, %sub.ptr.rhs.cast359
  %call361 = call i32 (i8*, i64, i8*, ...)* @snprintf(i8* %buf_ptr.6.lcssa, i64 %sub.ptr.sub360, i8* getelementptr inbounds ([2 x i8]* @.str27, i64 0, i64 0))
  br label %if.end365

if.end365:                                        ; preds = %for.end353, %if.then357, %if.end169
  %call367 = call i32 (i8*, i8*, ...)* @halide_printf(i8* %user_context, i8* getelementptr inbounds ([4 x i8]* @.str28, i64 0, i64 0), i8* %20)
  call void @llvm.lifetime.end(i64 256, i8* %20) #4
  br label %return

return:                                           ; preds = %if.end365, %if.then86, %for.end82, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ %2, %for.end82 ], [ %2, %if.then86 ], [ %2, %if.end365 ]
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
!8 = metadata !{metadata !9, metadata !9, i64 0}
!9 = metadata !{metadata !"int", metadata !3, i64 0}
!10 = metadata !{metadata !3, metadata !3, i64 0}
!11 = metadata !{metadata !12, metadata !12, i64 0}
!12 = metadata !{metadata !"short", metadata !3, i64 0}
!13 = metadata !{metadata !14, metadata !14, i64 0}
!14 = metadata !{metadata !"long", metadata !3, i64 0}
!15 = metadata !{metadata !16, metadata !16, i64 0}
!16 = metadata !{metadata !"float", metadata !3, i64 0}
!17 = metadata !{metadata !18, metadata !18, i64 0}
!18 = metadata !{metadata !"double", metadata !3, i64 0}
