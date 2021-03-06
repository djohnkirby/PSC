; ModuleID = 'src/runtime/osx_clock.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%struct.timeval = type { i32, i32 }

@halide_reference_clock_inited = weak global i8 0, align 1
@halide_reference_clock = weak global %struct.timeval zeroinitializer, align 4

define weak i32 @halide_start_clock(i8* %user_context) #0 {
entry:
  %0 = load i8* @halide_reference_clock_inited, align 1, !tbaa !1, !range !5
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = tail call i32 @gettimeofday(%struct.timeval* @halide_reference_clock, i8* null)
  store i8 1, i8* @halide_reference_clock_inited, align 1, !tbaa !1
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @gettimeofday(%struct.timeval* nocapture, i8* nocapture) #1

define weak i64 @halide_current_time_ns(i8* %user_context) #0 {
entry:
  %now = alloca %struct.timeval, align 4
  %call = call i32 @gettimeofday(%struct.timeval* %now, i8* null)
  %tv_sec = getelementptr inbounds %struct.timeval* %now, i32 0, i32 0
  %0 = load i32* %tv_sec, align 4, !tbaa !6
  %1 = load i32* getelementptr inbounds (%struct.timeval* @halide_reference_clock, i32 0, i32 0), align 4, !tbaa !6
  %sub = sub nsw i32 %0, %1
  %conv = sext i32 %sub to i64
  %mul = mul nsw i64 %conv, 1000000
  %tv_usec = getelementptr inbounds %struct.timeval* %now, i32 0, i32 1
  %2 = load i32* %tv_usec, align 4, !tbaa !9
  %conv1 = sext i32 %2 to i64
  %3 = load i32* getelementptr inbounds (%struct.timeval* @halide_reference_clock, i32 0, i32 1), align 4, !tbaa !9
  %conv2 = sext i32 %3 to i64
  %sub3 = sub i64 %conv1, %conv2
  %add = add nsw i64 %sub3, %mul
  %mul4 = mul nsw i64 %add, 1000
  ret i64 %mul4
}

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"bool", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{i8 0, i8 2}
!6 = metadata !{metadata !7, metadata !8, i64 0}
!7 = metadata !{metadata !"_ZTS7timeval", metadata !8, i64 0, metadata !8, i64 4}
!8 = metadata !{metadata !"int", metadata !3, i64 0}
!9 = metadata !{metadata !7, metadata !8, i64 4}
