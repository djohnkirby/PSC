; ModuleID = 'src/runtime/write_debug_image.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"struct.<anonymous namespace>::halide_tiff_header" = type <{ i16, i16, i32, i16, [15 x %"struct.<anonymous namespace>::tiff_tag"], i32, [2 x i32], [2 x i32] }>
%"struct.<anonymous namespace>::tiff_tag" = type <{ i16, i16, i32, %union.anon }>
%union.anon = type <{ i32 }>

@.str = private unnamed_addr constant [3 x i8] c"wb\00", align 1
@_ZN12_GLOBAL__N_130pixel_type_to_tiff_sample_typeE = internal unnamed_addr constant [10 x i16] [i16 3, i16 3, i16 1, i16 2, i16 1, i16 2, i16 1, i16 2, i16 1, i16 2], align 16

; Function Attrs: uwtable
define weak i32 @halide_debug_to_file(i8* %user_context, i8* %filename, i8* %data, i32 %s0, i32 %s1, i32 %s2, i32 %s3, i32 %type_code, i32 %bytes_per_element) #0 {
entry:
  %header = alloca %"struct.<anonymous namespace>::halide_tiff_header", align 2
  %offset = alloca i32, align 4
  %count = alloca i32, align 4
  %header86 = alloca [5 x i32], align 16
  %call = call i8* @fopen(i8* %filename, i8* getelementptr inbounds ([3 x i8]* @.str, i64 0, i64 0))
  %tobool = icmp eq i8* %call, null
  br i1 %tobool, label %return, label %if.end

if.end:                                           ; preds = %entry
  %mul = mul nsw i32 %s2, %s1
  %mul1 = mul nsw i32 %mul, %s3
  %conv2 = sext i32 %mul1 to i64
  br label %while.cond.i

while.cond.i:                                     ; preds = %while.cond.i, %if.end
  %f.0.i = phi i8* [ %filename, %if.end ], [ %incdec.ptr.i, %while.cond.i ]
  %0 = load i8* %f.0.i, align 1, !tbaa !1
  %cmp.i = icmp eq i8 %0, 0
  %incdec.ptr.i = getelementptr inbounds i8* %f.0.i, i64 1
  br i1 %cmp.i, label %while.cond1.preheader.i, label %while.cond.i

while.cond1.preheader.i:                          ; preds = %while.cond.i
  %conv = sext i32 %s0 to i64
  %mul3 = mul i64 %conv2, %conv
  %cmp272.i = icmp eq i8* %f.0.i, %filename
  br i1 %cmp272.i, label %if.else85, label %land.rhs.i

while.cond1.i:                                    ; preds = %land.rhs.i
  %cmp2.i = icmp eq i8* %incdec.ptr6.i, %filename
  %.pr.i = load i8* %incdec.ptr6.i, align 1, !tbaa !1
  %cmp9.i = icmp eq i8 %.pr.i, 46
  br i1 %cmp2.i, label %while.end7.i, label %land.rhs.i

land.rhs.i:                                       ; preds = %while.cond1.preheader.i, %while.cond1.i
  %cmp976.i = phi i1 [ %cmp9.i, %while.cond1.i ], [ false, %while.cond1.preheader.i ]
  %f.175.i = phi i8* [ %incdec.ptr6.i, %while.cond1.i ], [ %f.0.i, %while.cond1.preheader.i ]
  %incdec.ptr6.i = getelementptr inbounds i8* %f.175.i, i64 -1
  br i1 %cmp976.i, label %if.end.i, label %while.cond1.i

while.end7.i:                                     ; preds = %while.cond1.i
  br i1 %cmp9.i, label %if.end.i, label %if.else85

if.end.i:                                         ; preds = %land.rhs.i, %while.end7.i
  %f.170.i = phi i8* [ %filename, %while.end7.i ], [ %f.175.i, %land.rhs.i ]
  %incdec.ptr10.i = getelementptr inbounds i8* %f.170.i, i64 1
  %1 = load i8* %incdec.ptr10.i, align 1, !tbaa !1
  switch i8 %1, label %if.else85 [
    i8 116, label %if.end16.i
    i8 84, label %if.end16.i
  ]

if.end16.i:                                       ; preds = %if.end.i, %if.end.i
  %incdec.ptr17.i = getelementptr inbounds i8* %f.170.i, i64 2
  %2 = load i8* %incdec.ptr17.i, align 1, !tbaa !1
  switch i8 %2, label %if.else85 [
    i8 105, label %if.end24.i
    i8 73, label %if.end24.i
  ]

if.end24.i:                                       ; preds = %if.end16.i, %if.end16.i
  %incdec.ptr25.i = getelementptr inbounds i8* %f.170.i, i64 3
  %3 = load i8* %incdec.ptr25.i, align 1, !tbaa !1
  switch i8 %3, label %if.else85 [
    i8 102, label %if.end32.i
    i8 70, label %if.end32.i
  ]

if.end32.i:                                       ; preds = %if.end24.i, %if.end24.i
  %incdec.ptr33.i = getelementptr inbounds i8* %f.170.i, i64 4
  %4 = load i8* %incdec.ptr33.i, align 1, !tbaa !1
  switch i8 %4, label %if.else85 [
    i8 0, label %if.then5
    i8 102, label %_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit
    i8 70, label %_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit
  ]

_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit:   ; preds = %if.end32.i, %if.end32.i
  %incdec.ptr45.i = getelementptr inbounds i8* %f.170.i, i64 5
  %5 = load i8* %incdec.ptr45.i, align 1, !tbaa !1
  %cmp47.i = icmp eq i8 %5, 0
  br i1 %cmp47.i, label %if.then5, label %if.else85

if.then5:                                         ; preds = %if.end32.i, %_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit
  %6 = icmp ult i32 %s3, 2
  %cmp7 = icmp slt i32 %s2, 5
  %or.cond = and i1 %6, %cmp7
  %channels.0 = select i1 %or.cond, i32 %s2, i32 %s3
  %depth.0 = select i1 %or.cond, i32 1, i32 %s2
  %7 = bitcast %"struct.<anonymous namespace>::halide_tiff_header"* %header to i8*
  call void @llvm.lifetime.start(i64 210, i8* %7) #2
  %byte_order_marker = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 0
  store i16 18761, i16* %byte_order_marker, align 2, !tbaa !4
  %version = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 1
  store i16 42, i16* %version, align 2, !tbaa !8
  %ifd0_offset = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 2
  store i32 8, i32* %ifd0_offset, align 2, !tbaa !9
  %entry_count = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 3
  store i16 15, i16* %entry_count, align 2, !tbaa !10
  %tag_code2.i225 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 0, i32 0
  store i16 256, i16* %tag_code2.i225, align 2, !tbaa !11
  %type_code.i226 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 0, i32 1
  store i16 4, i16* %type_code.i226, align 2, !tbaa !13
  %count3.i227 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 0, i32 2
  store i32 1, i32* %count3.i227, align 2, !tbaa !14
  %i32.i228 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 0, i32 3, i32 0
  store i32 %s0, i32* %i32.i228, align 2, !tbaa !15
  %tag_code2.i221 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 1, i32 0
  store i16 257, i16* %tag_code2.i221, align 2, !tbaa !11
  %type_code.i222 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 1, i32 1
  store i16 4, i16* %type_code.i222, align 2, !tbaa !13
  %count3.i223 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 1, i32 2
  store i32 1, i32* %count3.i223, align 2, !tbaa !14
  %i32.i224 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 1, i32 3, i32 0
  store i32 %s1, i32* %i32.i224, align 2, !tbaa !15
  %mul17 = shl nsw i32 %bytes_per_element, 3
  %conv18 = trunc i32 %mul17 to i16
  %tag_code2.i216 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 2, i32 0
  store i16 258, i16* %tag_code2.i216, align 2, !tbaa !11
  %type_code.i217 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 2, i32 1
  store i16 3, i16* %type_code.i217, align 2, !tbaa !13
  %count3.i218 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 2, i32 2
  store i32 1, i32* %count3.i218, align 2, !tbaa !14
  %value4.i219 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 2, i32 3
  %i16.i220 = bitcast %union.anon* %value4.i219 to i16*
  store i16 %conv18, i16* %i16.i220, align 2, !tbaa !16
  %tag_code2.i211 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 3, i32 0
  store i16 259, i16* %tag_code2.i211, align 2, !tbaa !11
  %type_code.i212 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 3, i32 1
  store i16 3, i16* %type_code.i212, align 2, !tbaa !13
  %count3.i213 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 3, i32 2
  store i32 1, i32* %count3.i213, align 2, !tbaa !14
  %value4.i214 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 3, i32 3
  %i16.i215 = bitcast %union.anon* %value4.i214 to i16*
  store i16 1, i16* %i16.i215, align 2, !tbaa !16
  %cmp21 = icmp sgt i32 %channels.0, 2
  %conv22 = select i1 %cmp21, i16 2, i16 1
  %tag_code2.i206 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 4, i32 0
  store i16 262, i16* %tag_code2.i206, align 2, !tbaa !11
  %type_code.i207 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 4, i32 1
  store i16 3, i16* %type_code.i207, align 2, !tbaa !13
  %count3.i208 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 4, i32 2
  store i32 1, i32* %count3.i208, align 2, !tbaa !14
  %value4.i209 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 4, i32 3
  %i16.i210 = bitcast %union.anon* %value4.i209 to i16*
  store i16 %conv22, i16* %i16.i210, align 2, !tbaa !16
  %tag_code2.i202 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 5, i32 0
  store i16 273, i16* %tag_code2.i202, align 2, !tbaa !11
  %type_code.i203 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 5, i32 1
  store i16 4, i16* %type_code.i203, align 2, !tbaa !13
  %count3.i204 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 5, i32 2
  store i32 %channels.0, i32* %count3.i204, align 2, !tbaa !14
  %i32.i205 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 5, i32 3, i32 0
  store i32 210, i32* %i32.i205, align 2, !tbaa !15
  %conv25 = trunc i32 %channels.0 to i16
  %tag_code2.i197 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 6, i32 0
  store i16 277, i16* %tag_code2.i197, align 2, !tbaa !11
  %type_code.i198 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 6, i32 1
  store i16 3, i16* %type_code.i198, align 2, !tbaa !13
  %count3.i199 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 6, i32 2
  store i32 1, i32* %count3.i199, align 2, !tbaa !14
  %value4.i200 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 6, i32 3
  %i16.i201 = bitcast %union.anon* %value4.i200 to i16*
  store i16 %conv25, i16* %i16.i201, align 2, !tbaa !16
  %tag_code2.i193 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 7, i32 0
  store i16 278, i16* %tag_code2.i193, align 2, !tbaa !11
  %type_code.i194 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 7, i32 1
  store i16 4, i16* %type_code.i194, align 2, !tbaa !13
  %count3.i195 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 7, i32 2
  store i32 1, i32* %count3.i195, align 2, !tbaa !14
  %i32.i196 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 7, i32 3, i32 0
  store i32 %s1, i32* %i32.i196, align 2, !tbaa !15
  %cmp28 = icmp eq i32 %channels.0, 1
  br i1 %cmp28, label %cond.true, label %cond.false

cond.true:                                        ; preds = %if.then5
  %conv29 = sext i32 %bytes_per_element to i64
  %mul30 = mul i64 %mul3, %conv29
  br label %cond.end

cond.false:                                       ; preds = %if.then5
  %conv31 = sext i32 %channels.0 to i64
  %mul32 = shl nsw i64 %conv31, 2
  %add = add i64 %mul32, 210
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond33 = phi i64 [ %mul30, %cond.true ], [ %add, %cond.false ]
  %conv34 = trunc i64 %cond33 to i32
  %tag_code2.i189 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 8, i32 0
  store i16 279, i16* %tag_code2.i189, align 2, !tbaa !11
  %type_code.i190 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 8, i32 1
  store i16 4, i16* %type_code.i190, align 2, !tbaa !13
  %count3.i191 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 8, i32 2
  store i32 %channels.0, i32* %count3.i191, align 2, !tbaa !14
  %i32.i192 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 8, i32 3, i32 0
  store i32 %conv34, i32* %i32.i192, align 2, !tbaa !15
  %tag_code2.i185 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 9, i32 0
  store i16 282, i16* %tag_code2.i185, align 2, !tbaa !11
  %type_code3.i186 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 9, i32 1
  store i16 5, i16* %type_code3.i186, align 2, !tbaa !13
  %count4.i187 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 9, i32 2
  store i32 1, i32* %count4.i187, align 2, !tbaa !14
  %i32.i188 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 9, i32 3, i32 0
  store i32 194, i32* %i32.i188, align 2, !tbaa !15
  %tag_code2.i183 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 10, i32 0
  store i16 283, i16* %tag_code2.i183, align 2, !tbaa !11
  %type_code3.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 10, i32 1
  store i16 5, i16* %type_code3.i, align 2, !tbaa !13
  %count4.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 10, i32 2
  store i32 1, i32* %count4.i, align 2, !tbaa !14
  %i32.i184 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 10, i32 3, i32 0
  store i32 202, i32* %i32.i184, align 2, !tbaa !15
  %tag_code2.i178 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 11, i32 0
  store i16 284, i16* %tag_code2.i178, align 2, !tbaa !11
  %type_code.i179 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 11, i32 1
  store i16 3, i16* %type_code.i179, align 2, !tbaa !13
  %count3.i180 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 11, i32 2
  store i32 1, i32* %count3.i180, align 2, !tbaa !14
  %value4.i181 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 11, i32 3
  %i16.i182 = bitcast %union.anon* %value4.i181 to i16*
  store i16 2, i16* %i16.i182, align 2, !tbaa !16
  %tag_code2.i173 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 12, i32 0
  store i16 296, i16* %tag_code2.i173, align 2, !tbaa !11
  %type_code.i174 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 12, i32 1
  store i16 3, i16* %type_code.i174, align 2, !tbaa !13
  %count3.i175 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 12, i32 2
  store i32 1, i32* %count3.i175, align 2, !tbaa !14
  %value4.i176 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 12, i32 3
  %i16.i177 = bitcast %union.anon* %value4.i176 to i16*
  store i16 1, i16* %i16.i177, align 2, !tbaa !16
  %idxprom = sext i32 %type_code to i64
  %arrayidx40 = getelementptr inbounds [10 x i16]* @_ZN12_GLOBAL__N_130pixel_type_to_tiff_sample_typeE, i64 0, i64 %idxprom
  %8 = load i16* %arrayidx40, align 2, !tbaa !16
  %tag_code2.i170 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 13, i32 0
  store i16 339, i16* %tag_code2.i170, align 2, !tbaa !11
  %type_code.i171 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 13, i32 1
  store i16 3, i16* %type_code.i171, align 2, !tbaa !13
  %count3.i172 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 13, i32 2
  store i32 1, i32* %count3.i172, align 2, !tbaa !14
  %value4.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 13, i32 3
  %i16.i = bitcast %union.anon* %value4.i to i16*
  store i16 %8, i16* %i16.i, align 2, !tbaa !16
  %tag_code2.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 14, i32 0
  store i16 -32539, i16* %tag_code2.i, align 2, !tbaa !11
  %type_code.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 14, i32 1
  store i16 4, i16* %type_code.i, align 2, !tbaa !13
  %count3.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 14, i32 2
  store i32 1, i32* %count3.i, align 2, !tbaa !14
  %i32.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 4, i64 14, i32 3, i32 0
  store i32 %depth.0, i32* %i32.i, align 2, !tbaa !15
  %ifd0_end = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 5
  store i32 0, i32* %ifd0_end, align 2, !tbaa !17
  %arrayidx42 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 6, i64 0
  store i32 1, i32* %arrayidx42, align 2, !tbaa !15
  %arrayidx44 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 6, i64 1
  store i32 1, i32* %arrayidx44, align 2, !tbaa !15
  %arrayidx45 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 7, i64 0
  store i32 1, i32* %arrayidx45, align 2, !tbaa !15
  %arrayidx47 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i64 0, i32 7, i64 1
  store i32 1, i32* %arrayidx47, align 2, !tbaa !15
  %call48 = call i64 @fwrite(i8* %7, i64 210, i64 1, i8* %call)
  %tobool49 = icmp eq i64 %call48, 0
  br i1 %tobool49, label %if.then50, label %if.end52

if.then50:                                        ; preds = %cond.end
  %call51 = call i32 @fclose(i8* %call)
  call void @llvm.lifetime.end(i64 210, i8* %7) #2
  br label %return

if.end52:                                         ; preds = %cond.end
  %cmp53 = icmp sgt i32 %channels.0, 1
  br i1 %cmp53, label %for.body.lr.ph, label %if.end96

for.body.lr.ph:                                   ; preds = %if.end52
  %mul57 = shl i32 %channels.0, 3
  %add58 = add i32 %mul57, 210
  store i32 %add58, i32* %offset, align 4, !tbaa !15
  %9 = bitcast i32* %offset to i8*
  %mul66 = mul nsw i32 %s1, %s0
  %mul67 = mul i32 %mul66, %bytes_per_element
  %mul68 = mul i32 %mul67, %depth.0
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %if.end65
  %i.0233 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %if.end65 ]
  %call61 = call i64 @fwrite(i8* %9, i64 4, i64 1, i8* %call)
  %tobool62 = icmp eq i64 %call61, 0
  br i1 %tobool62, label %if.then63, label %if.end65

if.then63:                                        ; preds = %for.body
  %call64 = call i32 @fclose(i8* %call)
  call void @llvm.lifetime.end(i64 210, i8* %7) #2
  br label %return

if.end65:                                         ; preds = %for.body
  %10 = load i32* %offset, align 4, !tbaa !15
  %add69 = add nsw i32 %10, %mul68
  store i32 %add69, i32* %offset, align 4, !tbaa !15
  %inc = add nsw i32 %i.0233, 1
  %cmp60 = icmp slt i32 %inc, %channels.0
  br i1 %cmp60, label %for.body, label %for.end

for.end:                                          ; preds = %if.end65
  %mul71 = mul nsw i32 %mul66, %depth.0
  store i32 %mul71, i32* %count, align 4, !tbaa !15
  %11 = bitcast i32* %count to i8*
  br label %for.body75

for.cond73:                                       ; preds = %for.body75
  %cmp74 = icmp slt i32 %inc82, %channels.0
  br i1 %cmp74, label %for.body75, label %if.end96

for.body75:                                       ; preds = %for.end, %for.cond73
  %i72.0231 = phi i32 [ 0, %for.end ], [ %inc82, %for.cond73 ]
  %call76 = call i64 @fwrite(i8* %11, i64 4, i64 1, i8* %call)
  %tobool77 = icmp eq i64 %call76, 0
  %inc82 = add nsw i32 %i72.0231, 1
  br i1 %tobool77, label %if.then78, label %for.cond73

if.then78:                                        ; preds = %for.body75
  %call79 = call i32 @fclose(i8* %call)
  call void @llvm.lifetime.end(i64 210, i8* %7) #2
  br label %return

if.else85:                                        ; preds = %if.end32.i, %while.cond1.preheader.i, %if.end24.i, %if.end16.i, %if.end.i, %while.end7.i, %_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit
  %arrayinit.begin = getelementptr inbounds [5 x i32]* %header86, i64 0, i64 0
  store i32 %s0, i32* %arrayinit.begin, align 16, !tbaa !15
  %arrayinit.element = getelementptr inbounds [5 x i32]* %header86, i64 0, i64 1
  store i32 %s1, i32* %arrayinit.element, align 4, !tbaa !15
  %arrayinit.element87 = getelementptr inbounds [5 x i32]* %header86, i64 0, i64 2
  store i32 %s2, i32* %arrayinit.element87, align 8, !tbaa !15
  %arrayinit.element88 = getelementptr inbounds [5 x i32]* %header86, i64 0, i64 3
  store i32 %s3, i32* %arrayinit.element88, align 4, !tbaa !15
  %arrayinit.element89 = getelementptr inbounds [5 x i32]* %header86, i64 0, i64 4
  store i32 %type_code, i32* %arrayinit.element89, align 16, !tbaa !15
  %12 = bitcast [5 x i32]* %header86 to i8*
  %call91 = call i64 @fwrite(i8* %12, i64 20, i64 1, i8* %call)
  %tobool92 = icmp eq i64 %call91, 0
  br i1 %tobool92, label %if.then93, label %if.end96

if.then93:                                        ; preds = %if.else85
  %call94 = call i32 @fclose(i8* %call)
  br label %return

if.end96:                                         ; preds = %for.cond73, %if.end52, %if.else85
  %conv97 = sext i32 %bytes_per_element to i64
  %mul98 = mul i64 %conv97, %mul3
  %call99 = call i64 @fwrite(i8* %data, i64 %mul98, i64 1, i8* %call)
  %tobool100 = icmp eq i64 %call99, 0
  %call102 = call i32 @fclose(i8* %call)
  %. = sext i1 %tobool100 to i32
  br label %return

return:                                           ; preds = %if.end96, %if.then50, %if.then78, %if.then63, %entry, %if.then93
  %retval.1 = phi i32 [ -2, %if.then93 ], [ -1, %entry ], [ -2, %if.then63 ], [ -2, %if.then78 ], [ -2, %if.then50 ], [ %., %if.end96 ]
  ret i32 %retval.1
}

; Function Attrs: nounwind
declare noalias i8* @fopen(i8* nocapture readonly, i8* nocapture readonly) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare i64 @fwrite(i8* nocapture, i64, i64, i8* nocapture) #1

; Function Attrs: nounwind
declare i32 @fclose(i8* nocapture) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #2

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"omnipotent char", metadata !3, i64 0}
!3 = metadata !{metadata !"Simple C/C++ TBAA"}
!4 = metadata !{metadata !5, metadata !6, i64 0}
!5 = metadata !{metadata !"_ZTSN12_GLOBAL__N_118halide_tiff_headerE", metadata !6, i64 0, metadata !6, i64 2, metadata !7, i64 4, metadata !6, i64 8, metadata !2, i64 10, metadata !7, i64 190, metadata !2, i64 194, metadata !2, i64 202}
!6 = metadata !{metadata !"short", metadata !2, i64 0}
!7 = metadata !{metadata !"int", metadata !2, i64 0}
!8 = metadata !{metadata !5, metadata !6, i64 2}
!9 = metadata !{metadata !5, metadata !7, i64 4}
!10 = metadata !{metadata !5, metadata !6, i64 8}
!11 = metadata !{metadata !12, metadata !6, i64 0}
!12 = metadata !{metadata !"_ZTSN12_GLOBAL__N_18tiff_tagE", metadata !6, i64 0, metadata !6, i64 2, metadata !7, i64 4, metadata !2, i64 8}
!13 = metadata !{metadata !12, metadata !6, i64 2}
!14 = metadata !{metadata !12, metadata !7, i64 4}
!15 = metadata !{metadata !7, metadata !7, i64 0}
!16 = metadata !{metadata !6, metadata !6, i64 0}
!17 = metadata !{metadata !5, metadata !7, i64 190}
