; ModuleID = 'src/runtime/windows_clock.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

@halide_reference_clock_inited = weak global i8 0, align 1
@halide_reference_clock = weak global i64 0, align 8
@halide_clock_frequency = weak global i64 1, align 8

define weak i32 @halide_start_clock(i8* %user_context) #0 {
entry:
  %0 = load i8* @halide_reference_clock_inited, align 1, !tbaa !1, !range !5
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = tail call x86_stdcallcc zeroext i1 @QueryPerformanceCounter(i64* @halide_reference_clock)
  %call1 = tail call x86_stdcallcc zeroext i1 @QueryPerformanceFrequency(i64* @halide_clock_frequency)
  store i8 1, i8* @halide_reference_clock_inited, align 1, !tbaa !1
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  ret i32 0
}

declare x86_stdcallcc zeroext i1 @QueryPerformanceCounter(i64*) #0

declare x86_stdcallcc zeroext i1 @QueryPerformanceFrequency(i64*) #0

define weak i64 @halide_current_time_ns(i8* %user_context) #0 {
entry:
  %clock = alloca i64, align 8
  %call = call x86_stdcallcc zeroext i1 @QueryPerformanceCounter(i64* %clock)
  %0 = load i64* @halide_reference_clock, align 8, !tbaa !6
  %1 = load i64* %clock, align 8, !tbaa !6
  %sub = sub nsw i64 %1, %0
  %2 = load i64* @halide_clock_frequency, align 8, !tbaa !6
  %conv = sitofp i64 %2 to double
  %div = fdiv double 1.000000e+09, %conv
  %conv1 = sitofp i64 %sub to double
  %mul = fmul double %div, %conv1
  %conv2 = fptosi double %mul to i64
  ret i64 %conv2
}

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.4 (trunk 193715)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"bool", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{i8 0, i8 2}
!6 = metadata !{metadata !7, metadata !7, i64 0}
!7 = metadata !{metadata !"long long", metadata !3, i64 0}
