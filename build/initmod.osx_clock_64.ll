; ModuleID = 'src/runtime/osx_clock.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.timeval = type { i64, i32 }

@halide_reference_clock_inited = weak global i8 0, align 1
@halide_reference_clock = weak global %struct.timeval zeroinitializer, align 8

; Function Attrs: uwtable
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

; Function Attrs: uwtable
define weak i64 @halide_current_time_ns(i8* %user_context) #0 {
entry:
  %now = alloca %struct.timeval, align 8
  %call = call i32 @gettimeofday(%struct.timeval* %now, i8* null)
  %tv_sec = getelementptr inbounds %struct.timeval* %now, i64 0, i32 0
  %0 = load i64* %tv_sec, align 8, !tbaa !6
  %1 = load i64* getelementptr inbounds (%struct.timeval* @halide_reference_clock, i64 0, i32 0), align 8, !tbaa !6
  %sub = sub nsw i64 %0, %1
  %mul = mul nsw i64 %sub, 1000000
  %tv_usec = getelementptr inbounds %struct.timeval* %now, i64 0, i32 1
  %2 = load i32* %tv_usec, align 8, !tbaa !10
  %conv = sext i32 %2 to i64
  %3 = load i32* getelementptr inbounds (%struct.timeval* @halide_reference_clock, i64 0, i32 1), align 8, !tbaa !10
  %conv1 = sext i32 %3 to i64
  %sub2 = add i64 %mul, %conv
  %add = sub i64 %sub2, %conv1
  %mul3 = mul nsw i64 %add, 1000
  ret i64 %mul3
}

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"bool", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{i8 0, i8 2}
!6 = metadata !{metadata !7, metadata !8, i64 0}
!7 = metadata !{metadata !"_ZTS7timeval", metadata !8, i64 0, metadata !9, i64 8}
!8 = metadata !{metadata !"long long", metadata !3, i64 0}
!9 = metadata !{metadata !"int", metadata !3, i64 0}
!10 = metadata !{metadata !7, metadata !9, i64 8}
