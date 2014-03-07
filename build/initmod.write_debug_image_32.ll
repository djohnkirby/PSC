; ModuleID = 'src/runtime/write_debug_image.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%"struct.<anonymous namespace>::halide_tiff_header" = type <{ i16, i16, i32, i16, [15 x %"struct.<anonymous namespace>::tiff_tag"], i32, [2 x i32], [2 x i32] }>
%"struct.<anonymous namespace>::tiff_tag" = type <{ i16, i16, i32, %union.anon }>
%union.anon = type <{ i32 }>

@.str = private unnamed_addr constant [3 x i8] c"wb\00", align 1
@_ZN12_GLOBAL__N_130pixel_type_to_tiff_sample_typeE = internal unnamed_addr constant [10 x i16] [i16 3, i16 3, i16 1, i16 2, i16 1, i16 2, i16 1, i16 2, i16 1, i16 2], align 2

define weak i32 @halide_debug_to_file(i8* %user_context, i8* %filename, i8* %data, i32 %s0, i32 %s1, i32 %s2, i32 %s3, i32 %type_code, i32 %bytes_per_element) #0 {
entry:
  %header = alloca %"struct.<anonymous namespace>::halide_tiff_header", align 2
  %offset = alloca i32, align 4
  %count = alloca i32, align 4
  %header79 = alloca [5 x i32], align 4
  %call = call i8* @fopen(i8* %filename, i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0))
  %tobool = icmp eq i8* %call, null
  br i1 %tobool, label %return, label %if.end

if.end:                                           ; preds = %entry
  %mul = mul i32 %s1, %s0
  %mul1 = mul i32 %mul, %s2
  br label %while.cond.i

while.cond.i:                                     ; preds = %while.cond.i, %if.end
  %f.0.i = phi i8* [ %filename, %if.end ], [ %incdec.ptr.i, %while.cond.i ]
  %0 = load i8* %f.0.i, align 1, !tbaa !1
  %cmp.i = icmp eq i8 %0, 0
  %incdec.ptr.i = getelementptr inbounds i8* %f.0.i, i32 1
  br i1 %cmp.i, label %while.cond1.preheader.i, label %while.cond.i

while.cond1.preheader.i:                          ; preds = %while.cond.i
  %mul2 = mul i32 %mul1, %s3
  %cmp272.i = icmp eq i8* %f.0.i, %filename
  br i1 %cmp272.i, label %if.else78, label %land.rhs.i

while.cond1.i:                                    ; preds = %land.rhs.i
  %cmp2.i = icmp eq i8* %incdec.ptr6.i, %filename
  %.pr.i = load i8* %incdec.ptr6.i, align 1, !tbaa !1
  %cmp9.i = icmp eq i8 %.pr.i, 46
  br i1 %cmp2.i, label %while.end7.i, label %land.rhs.i

land.rhs.i:                                       ; preds = %while.cond1.preheader.i, %while.cond1.i
  %cmp976.i = phi i1 [ %cmp9.i, %while.cond1.i ], [ false, %while.cond1.preheader.i ]
  %f.175.i = phi i8* [ %incdec.ptr6.i, %while.cond1.i ], [ %f.0.i, %while.cond1.preheader.i ]
  %incdec.ptr6.i = getelementptr inbounds i8* %f.175.i, i32 -1
  br i1 %cmp976.i, label %if.end.i, label %while.cond1.i

while.end7.i:                                     ; preds = %while.cond1.i
  br i1 %cmp9.i, label %if.end.i, label %if.else78

if.end.i:                                         ; preds = %land.rhs.i, %while.end7.i
  %f.170.i = phi i8* [ %filename, %while.end7.i ], [ %f.175.i, %land.rhs.i ]
  %incdec.ptr10.i = getelementptr inbounds i8* %f.170.i, i32 1
  %1 = load i8* %incdec.ptr10.i, align 1, !tbaa !1
  switch i8 %1, label %if.else78 [
    i8 116, label %if.end16.i
    i8 84, label %if.end16.i
  ]

if.end16.i:                                       ; preds = %if.end.i, %if.end.i
  %incdec.ptr17.i = getelementptr inbounds i8* %f.170.i, i32 2
  %2 = load i8* %incdec.ptr17.i, align 1, !tbaa !1
  switch i8 %2, label %if.else78 [
    i8 105, label %if.end24.i
    i8 73, label %if.end24.i
  ]

if.end24.i:                                       ; preds = %if.end16.i, %if.end16.i
  %incdec.ptr25.i = getelementptr inbounds i8* %f.170.i, i32 3
  %3 = load i8* %incdec.ptr25.i, align 1, !tbaa !1
  switch i8 %3, label %if.else78 [
    i8 102, label %if.end32.i
    i8 70, label %if.end32.i
  ]

if.end32.i:                                       ; preds = %if.end24.i, %if.end24.i
  %incdec.ptr33.i = getelementptr inbounds i8* %f.170.i, i32 4
  %4 = load i8* %incdec.ptr33.i, align 1, !tbaa !1
  switch i8 %4, label %if.else78 [
    i8 0, label %if.then4
    i8 102, label %_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit
    i8 70, label %_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit
  ]

_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit:   ; preds = %if.end32.i, %if.end32.i
  %incdec.ptr45.i = getelementptr inbounds i8* %f.170.i, i32 5
  %5 = load i8* %incdec.ptr45.i, align 1, !tbaa !1
  %cmp47.i = icmp eq i8 %5, 0
  br i1 %cmp47.i, label %if.then4, label %if.else78

if.then4:                                         ; preds = %if.end32.i, %_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit
  %6 = icmp ult i32 %s3, 2
  %cmp6 = icmp slt i32 %s2, 5
  %or.cond = and i1 %6, %cmp6
  %channels.0 = select i1 %or.cond, i32 %s2, i32 %s3
  %depth.0 = select i1 %or.cond, i32 1, i32 %s2
  %7 = bitcast %"struct.<anonymous namespace>::halide_tiff_header"* %header to i8*
  call void @llvm.lifetime.start(i64 210, i8* %7) #2
  %byte_order_marker = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 0
  store i16 18761, i16* %byte_order_marker, align 2, !tbaa !4
  %version = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 1
  store i16 42, i16* %version, align 2, !tbaa !8
  %ifd0_offset = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 2
  store i32 8, i32* %ifd0_offset, align 2, !tbaa !9
  %entry_count = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 3
  store i16 15, i16* %entry_count, align 2, !tbaa !10
  %tag_code2.i217 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 0, i32 0
  store i16 256, i16* %tag_code2.i217, align 2, !tbaa !11
  %type_code.i218 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 0, i32 1
  store i16 4, i16* %type_code.i218, align 2, !tbaa !13
  %count3.i219 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 0, i32 2
  store i32 1, i32* %count3.i219, align 2, !tbaa !14
  %i32.i220 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 0, i32 3, i32 0
  store i32 %s0, i32* %i32.i220, align 2, !tbaa !15
  %tag_code2.i213 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 1, i32 0
  store i16 257, i16* %tag_code2.i213, align 2, !tbaa !11
  %type_code.i214 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 1, i32 1
  store i16 4, i16* %type_code.i214, align 2, !tbaa !13
  %count3.i215 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 1, i32 2
  store i32 1, i32* %count3.i215, align 2, !tbaa !14
  %i32.i216 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 1, i32 3, i32 0
  store i32 %s1, i32* %i32.i216, align 2, !tbaa !15
  %mul15 = shl nsw i32 %bytes_per_element, 3
  %conv16 = trunc i32 %mul15 to i16
  %tag_code2.i208 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 2, i32 0
  store i16 258, i16* %tag_code2.i208, align 2, !tbaa !11
  %type_code.i209 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 2, i32 1
  store i16 3, i16* %type_code.i209, align 2, !tbaa !13
  %count3.i210 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 2, i32 2
  store i32 1, i32* %count3.i210, align 2, !tbaa !14
  %value4.i211 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 2, i32 3
  %i16.i212 = bitcast %union.anon* %value4.i211 to i16*
  store i16 %conv16, i16* %i16.i212, align 2, !tbaa !16
  %tag_code2.i203 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 3, i32 0
  store i16 259, i16* %tag_code2.i203, align 2, !tbaa !11
  %type_code.i204 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 3, i32 1
  store i16 3, i16* %type_code.i204, align 2, !tbaa !13
  %count3.i205 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 3, i32 2
  store i32 1, i32* %count3.i205, align 2, !tbaa !14
  %value4.i206 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 3, i32 3
  %i16.i207 = bitcast %union.anon* %value4.i206 to i16*
  store i16 1, i16* %i16.i207, align 2, !tbaa !16
  %cmp19 = icmp sgt i32 %channels.0, 2
  %conv20 = select i1 %cmp19, i16 2, i16 1
  %tag_code2.i198 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 4, i32 0
  store i16 262, i16* %tag_code2.i198, align 2, !tbaa !11
  %type_code.i199 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 4, i32 1
  store i16 3, i16* %type_code.i199, align 2, !tbaa !13
  %count3.i200 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 4, i32 2
  store i32 1, i32* %count3.i200, align 2, !tbaa !14
  %value4.i201 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 4, i32 3
  %i16.i202 = bitcast %union.anon* %value4.i201 to i16*
  store i16 %conv20, i16* %i16.i202, align 2, !tbaa !16
  %tag_code2.i194 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 5, i32 0
  store i16 273, i16* %tag_code2.i194, align 2, !tbaa !11
  %type_code.i195 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 5, i32 1
  store i16 4, i16* %type_code.i195, align 2, !tbaa !13
  %count3.i196 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 5, i32 2
  store i32 %channels.0, i32* %count3.i196, align 2, !tbaa !14
  %i32.i197 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 5, i32 3, i32 0
  store i32 210, i32* %i32.i197, align 2, !tbaa !15
  %conv23 = trunc i32 %channels.0 to i16
  %tag_code2.i189 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 6, i32 0
  store i16 277, i16* %tag_code2.i189, align 2, !tbaa !11
  %type_code.i190 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 6, i32 1
  store i16 3, i16* %type_code.i190, align 2, !tbaa !13
  %count3.i191 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 6, i32 2
  store i32 1, i32* %count3.i191, align 2, !tbaa !14
  %value4.i192 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 6, i32 3
  %i16.i193 = bitcast %union.anon* %value4.i192 to i16*
  store i16 %conv23, i16* %i16.i193, align 2, !tbaa !16
  %tag_code2.i185 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 7, i32 0
  store i16 278, i16* %tag_code2.i185, align 2, !tbaa !11
  %type_code.i186 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 7, i32 1
  store i16 4, i16* %type_code.i186, align 2, !tbaa !13
  %count3.i187 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 7, i32 2
  store i32 1, i32* %count3.i187, align 2, !tbaa !14
  %i32.i188 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 7, i32 3, i32 0
  store i32 %s1, i32* %i32.i188, align 2, !tbaa !15
  %cmp26 = icmp eq i32 %channels.0, 1
  br i1 %cmp26, label %cond.true, label %cond.false

cond.true:                                        ; preds = %if.then4
  %mul27 = mul i32 %mul2, %bytes_per_element
  br label %cond.end

cond.false:                                       ; preds = %if.then4
  %mul28 = shl i32 %channels.0, 2
  %add = add i32 %mul28, 210
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond29 = phi i32 [ %mul27, %cond.true ], [ %add, %cond.false ]
  %tag_code2.i181 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 8, i32 0
  store i16 279, i16* %tag_code2.i181, align 2, !tbaa !11
  %type_code.i182 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 8, i32 1
  store i16 4, i16* %type_code.i182, align 2, !tbaa !13
  %count3.i183 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 8, i32 2
  store i32 %channels.0, i32* %count3.i183, align 2, !tbaa !14
  %i32.i184 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 8, i32 3, i32 0
  store i32 %cond29, i32* %i32.i184, align 2, !tbaa !15
  %tag_code2.i177 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 9, i32 0
  store i16 282, i16* %tag_code2.i177, align 2, !tbaa !11
  %type_code3.i178 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 9, i32 1
  store i16 5, i16* %type_code3.i178, align 2, !tbaa !13
  %count4.i179 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 9, i32 2
  store i32 1, i32* %count4.i179, align 2, !tbaa !14
  %i32.i180 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 9, i32 3, i32 0
  store i32 194, i32* %i32.i180, align 2, !tbaa !15
  %tag_code2.i175 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 10, i32 0
  store i16 283, i16* %tag_code2.i175, align 2, !tbaa !11
  %type_code3.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 10, i32 1
  store i16 5, i16* %type_code3.i, align 2, !tbaa !13
  %count4.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 10, i32 2
  store i32 1, i32* %count4.i, align 2, !tbaa !14
  %i32.i176 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 10, i32 3, i32 0
  store i32 202, i32* %i32.i176, align 2, !tbaa !15
  %tag_code2.i170 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 11, i32 0
  store i16 284, i16* %tag_code2.i170, align 2, !tbaa !11
  %type_code.i171 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 11, i32 1
  store i16 3, i16* %type_code.i171, align 2, !tbaa !13
  %count3.i172 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 11, i32 2
  store i32 1, i32* %count3.i172, align 2, !tbaa !14
  %value4.i173 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 11, i32 3
  %i16.i174 = bitcast %union.anon* %value4.i173 to i16*
  store i16 2, i16* %i16.i174, align 2, !tbaa !16
  %tag_code2.i165 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 12, i32 0
  store i16 296, i16* %tag_code2.i165, align 2, !tbaa !11
  %type_code.i166 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 12, i32 1
  store i16 3, i16* %type_code.i166, align 2, !tbaa !13
  %count3.i167 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 12, i32 2
  store i32 1, i32* %count3.i167, align 2, !tbaa !14
  %value4.i168 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 12, i32 3
  %i16.i169 = bitcast %union.anon* %value4.i168 to i16*
  store i16 1, i16* %i16.i169, align 2, !tbaa !16
  %arrayidx35 = getelementptr inbounds [10 x i16]* @_ZN12_GLOBAL__N_130pixel_type_to_tiff_sample_typeE, i32 0, i32 %type_code
  %8 = load i16* %arrayidx35, align 2, !tbaa !16
  %tag_code2.i162 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 13, i32 0
  store i16 339, i16* %tag_code2.i162, align 2, !tbaa !11
  %type_code.i163 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 13, i32 1
  store i16 3, i16* %type_code.i163, align 2, !tbaa !13
  %count3.i164 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 13, i32 2
  store i32 1, i32* %count3.i164, align 2, !tbaa !14
  %value4.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 13, i32 3
  %i16.i = bitcast %union.anon* %value4.i to i16*
  store i16 %8, i16* %i16.i, align 2, !tbaa !16
  %tag_code2.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 14, i32 0
  store i16 -32539, i16* %tag_code2.i, align 2, !tbaa !11
  %type_code.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 14, i32 1
  store i16 4, i16* %type_code.i, align 2, !tbaa !13
  %count3.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 14, i32 2
  store i32 1, i32* %count3.i, align 2, !tbaa !14
  %i32.i = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 4, i32 14, i32 3, i32 0
  store i32 %depth.0, i32* %i32.i, align 2, !tbaa !15
  %ifd0_end = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 5
  store i32 0, i32* %ifd0_end, align 2, !tbaa !17
  %arrayidx37 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 6, i32 0
  store i32 1, i32* %arrayidx37, align 2, !tbaa !15
  %arrayidx39 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 6, i32 1
  store i32 1, i32* %arrayidx39, align 2, !tbaa !15
  %arrayidx40 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 7, i32 0
  store i32 1, i32* %arrayidx40, align 2, !tbaa !15
  %arrayidx42 = getelementptr inbounds %"struct.<anonymous namespace>::halide_tiff_header"* %header, i32 0, i32 7, i32 1
  store i32 1, i32* %arrayidx42, align 2, !tbaa !15
  %call43 = call i32 @fwrite(i8* %7, i32 210, i32 1, i8* %call)
  %tobool44 = icmp eq i32 %call43, 0
  br i1 %tobool44, label %if.then45, label %if.end47

if.then45:                                        ; preds = %cond.end
  %call46 = call i32 @fclose(i8* %call)
  call void @llvm.lifetime.end(i64 210, i8* %7) #2
  br label %return

if.end47:                                         ; preds = %cond.end
  %cmp48 = icmp sgt i32 %channels.0, 1
  br i1 %cmp48, label %for.body.lr.ph, label %if.end89

for.body.lr.ph:                                   ; preds = %if.end47
  %mul51 = shl i32 %channels.0, 3
  %add52 = add i32 %mul51, 210
  store i32 %add52, i32* %offset, align 4, !tbaa !15
  %9 = bitcast i32* %offset to i8*
  %mul60 = mul i32 %mul, %bytes_per_element
  %mul61 = mul i32 %mul60, %depth.0
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %if.end58
  %i.0225 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %if.end58 ]
  %call54 = call i32 @fwrite(i8* %9, i32 4, i32 1, i8* %call)
  %tobool55 = icmp eq i32 %call54, 0
  br i1 %tobool55, label %if.then56, label %if.end58

if.then56:                                        ; preds = %for.body
  %call57 = call i32 @fclose(i8* %call)
  call void @llvm.lifetime.end(i64 210, i8* %7) #2
  br label %return

if.end58:                                         ; preds = %for.body
  %10 = load i32* %offset, align 4, !tbaa !15
  %add62 = add nsw i32 %10, %mul61
  store i32 %add62, i32* %offset, align 4, !tbaa !15
  %inc = add nsw i32 %i.0225, 1
  %cmp53 = icmp slt i32 %inc, %channels.0
  br i1 %cmp53, label %for.body, label %for.end

for.end:                                          ; preds = %if.end58
  %mul64 = mul nsw i32 %mul, %depth.0
  store i32 %mul64, i32* %count, align 4, !tbaa !15
  %11 = bitcast i32* %count to i8*
  br label %for.body68

for.cond66:                                       ; preds = %for.body68
  %cmp67 = icmp slt i32 %inc75, %channels.0
  br i1 %cmp67, label %for.body68, label %if.end89

for.body68:                                       ; preds = %for.end, %for.cond66
  %i65.0223 = phi i32 [ 0, %for.end ], [ %inc75, %for.cond66 ]
  %call69 = call i32 @fwrite(i8* %11, i32 4, i32 1, i8* %call)
  %tobool70 = icmp eq i32 %call69, 0
  %inc75 = add nsw i32 %i65.0223, 1
  br i1 %tobool70, label %if.then71, label %for.cond66

if.then71:                                        ; preds = %for.body68
  %call72 = call i32 @fclose(i8* %call)
  call void @llvm.lifetime.end(i64 210, i8* %7) #2
  br label %return

if.else78:                                        ; preds = %if.end32.i, %while.cond1.preheader.i, %if.end24.i, %if.end16.i, %if.end.i, %while.end7.i, %_ZN12_GLOBAL__N_118has_tiff_extensionEPKc.exit
  %arrayinit.begin = getelementptr inbounds [5 x i32]* %header79, i32 0, i32 0
  store i32 %s0, i32* %arrayinit.begin, align 4, !tbaa !15
  %arrayinit.element = getelementptr inbounds [5 x i32]* %header79, i32 0, i32 1
  store i32 %s1, i32* %arrayinit.element, align 4, !tbaa !15
  %arrayinit.element80 = getelementptr inbounds [5 x i32]* %header79, i32 0, i32 2
  store i32 %s2, i32* %arrayinit.element80, align 4, !tbaa !15
  %arrayinit.element81 = getelementptr inbounds [5 x i32]* %header79, i32 0, i32 3
  store i32 %s3, i32* %arrayinit.element81, align 4, !tbaa !15
  %arrayinit.element82 = getelementptr inbounds [5 x i32]* %header79, i32 0, i32 4
  store i32 %type_code, i32* %arrayinit.element82, align 4, !tbaa !15
  %12 = bitcast [5 x i32]* %header79 to i8*
  %call84 = call i32 @fwrite(i8* %12, i32 20, i32 1, i8* %call)
  %tobool85 = icmp eq i32 %call84, 0
  br i1 %tobool85, label %if.then86, label %if.end89

if.then86:                                        ; preds = %if.else78
  %call87 = call i32 @fclose(i8* %call)
  br label %return

if.end89:                                         ; preds = %for.cond66, %if.end47, %if.else78
  %mul90 = mul i32 %mul2, %bytes_per_element
  %call91 = call i32 @fwrite(i8* %data, i32 %mul90, i32 1, i8* %call)
  %tobool92 = icmp eq i32 %call91, 0
  %call94 = call i32 @fclose(i8* %call)
  %. = sext i1 %tobool92 to i32
  br label %return

return:                                           ; preds = %if.end89, %if.then45, %if.then71, %if.then56, %entry, %if.then86
  %retval.1 = phi i32 [ -2, %if.then86 ], [ -1, %entry ], [ -2, %if.then56 ], [ -2, %if.then71 ], [ -2, %if.then45 ], [ %., %if.end89 ]
  ret i32 %retval.1
}

; Function Attrs: nounwind
declare noalias i8* @fopen(i8* nocapture readonly, i8* nocapture readonly) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare i32 @fwrite(i8* nocapture, i32, i32, i8* nocapture) #1

; Function Attrs: nounwind
declare i32 @fclose(i8* nocapture) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #2

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
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
