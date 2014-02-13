	.file	"halide_module_g"
	.section	.text.halide_current_time_ns,"axG",@progbits,halide_current_time_ns,comdat
	.weak	halide_current_time_ns
	.align	16, 0x90
	.type	halide_current_time_ns,@function
halide_current_time_ns:                 # @halide_current_time_ns
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Ltmp1:
	.cfi_def_cfa_offset 32
	leaq	8(%rsp), %rdx
	movl	$228, %edi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	syscall@PLT
	movq	halide_reference_clock@GOTPCREL(%rip), %rcx
	movq	8(%rsp), %rdx
	movq	16(%rsp), %rax
	subq	(%rcx), %rdx
	imulq	$1000000000, %rdx, %rdx # imm = 0x3B9ACA00
	subq	8(%rcx), %rax
	addq	%rdx, %rax
	addq	$24, %rsp
	ret
.Ltmp2:
	.size	halide_current_time_ns, .Ltmp2-halide_current_time_ns
	.cfi_endproc

	.section	.text.halide_printf,"axG",@progbits,halide_printf,comdat
	.weak	halide_printf
	.align	16, 0x90
	.type	halide_printf,@function
halide_printf:                          # @halide_printf
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$200, %rsp
.Ltmp4:
	.cfi_def_cfa_offset 208
	movq	%rdi, %r10
	testb	%al, %al
	je	.LBB1_2
# BB#1:                                 # %entry
	movaps	%xmm0, 48(%rsp)
	movaps	%xmm1, 64(%rsp)
	movaps	%xmm2, 80(%rsp)
	movaps	%xmm3, 96(%rsp)
	movaps	%xmm4, 112(%rsp)
	movaps	%xmm5, 128(%rsp)
	movaps	%xmm6, 144(%rsp)
	movaps	%xmm7, 160(%rsp)
.LBB1_2:                                # %entry
	movq	%r9, 40(%rsp)
	movq	%r8, 32(%rsp)
	movq	%rcx, 24(%rsp)
	movq	%rdx, 16(%rsp)
	movq	%rsi, 8(%rsp)
	leaq	(%rsp), %rax
	movq	%rax, 192(%rsp)
	leaq	208(%rsp), %rax
	movq	%rax, 184(%rsp)
	movl	$48, 180(%rsp)
	movl	$8, 176(%rsp)
	movq	stderr@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	leaq	176(%rsp), %rdx
	movq	%r10, %rsi
	callq	vfprintf@PLT
	addq	$200, %rsp
	ret
.Ltmp5:
	.size	halide_printf, .Ltmp5-halide_printf
	.cfi_endproc

	.section	.text.halide_host_cpu_count,"axG",@progbits,halide_host_cpu_count,comdat
	.weak	halide_host_cpu_count
	.align	16, 0x90
	.type	halide_host_cpu_count,@function
halide_host_cpu_count:                  # @halide_host_cpu_count
	.cfi_startproc
# BB#0:                                 # %entry
	movl	$84, %edi
	jmp	sysconf@PLT             # TAILCALL
.Ltmp6:
	.size	halide_host_cpu_count, .Ltmp6-halide_host_cpu_count
	.cfi_endproc

	.section	.text.halide_shutdown_thread_pool,"axG",@progbits,halide_shutdown_thread_pool,comdat
	.weak	halide_shutdown_thread_pool
	.align	16, 0x90
	.type	halide_shutdown_thread_pool,@function
halide_shutdown_thread_pool:            # @halide_shutdown_thread_pool
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbp
.Ltmp14:
	.cfi_def_cfa_offset 16
	pushq	%r15
.Ltmp15:
	.cfi_def_cfa_offset 24
	pushq	%r14
.Ltmp16:
	.cfi_def_cfa_offset 32
	pushq	%r13
.Ltmp17:
	.cfi_def_cfa_offset 40
	pushq	%r12
.Ltmp18:
	.cfi_def_cfa_offset 48
	pushq	%rbx
.Ltmp19:
	.cfi_def_cfa_offset 56
	pushq	%rax
.Ltmp20:
	.cfi_def_cfa_offset 64
.Ltmp21:
	.cfi_offset %rbx, -56
.Ltmp22:
	.cfi_offset %r12, -48
.Ltmp23:
	.cfi_offset %r13, -40
.Ltmp24:
	.cfi_offset %r14, -32
.Ltmp25:
	.cfi_offset %r15, -24
.Ltmp26:
	.cfi_offset %rbp, -16
	movq	halide_thread_pool_initialized@GOTPCREL(%rip), %r12
	cmpb	$0, (%r12)
	je	.LBB3_5
# BB#1:                                 # %if.end
	movq	halide_work_queue@GOTPCREL(%rip), %r15
	movq	%r15, %rdi
	callq	pthread_mutex_lock@PLT
	movb	$1, 608(%r15)
	leaq	48(%r15), %r14
	movq	%r14, %rdi
	callq	pthread_cond_broadcast@PLT
	movq	%r15, %rdi
	callq	pthread_mutex_unlock@PLT
	movq	halide_threads@GOTPCREL(%rip), %r13
	movl	(%r13), %eax
	decl	%eax
	xorl	%ebp, %ebp
	testl	%eax, %eax
	jle	.LBB3_4
# BB#2:
	leaq	(%rsp), %rbx
	.align	16, 0x90
.LBB3_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	movq	96(%r15,%rbp,8), %rdi
	movq	%rbx, %rsi
	callq	pthread_join@PLT
	incq	%rbp
	movl	(%r13), %eax
	decl	%eax
	cmpl	%eax, %ebp
	jl	.LBB3_3
.LBB3_4:                                # %for.end
	movq	%r15, %rdi
	callq	pthread_mutex_destroy@PLT
	movq	%r14, %rdi
	callq	pthread_cond_destroy@PLT
	movb	$0, (%r12)
.LBB3_5:                                # %return
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
.Ltmp27:
	.size	halide_shutdown_thread_pool, .Ltmp27-halide_shutdown_thread_pool
	.cfi_endproc

	.section	.text.halide_set_custom_do_task,"axG",@progbits,halide_set_custom_do_task,comdat
	.weak	halide_set_custom_do_task
	.align	16, 0x90
	.type	halide_set_custom_do_task,@function
halide_set_custom_do_task:              # @halide_set_custom_do_task
	.cfi_startproc
# BB#0:                                 # %entry
	movq	halide_custom_do_task@GOTPCREL(%rip), %rax
	movq	%rdi, (%rax)
	ret
.Ltmp28:
	.size	halide_set_custom_do_task, .Ltmp28-halide_set_custom_do_task
	.cfi_endproc

	.section	.text.halide_set_custom_do_par_for,"axG",@progbits,halide_set_custom_do_par_for,comdat
	.weak	halide_set_custom_do_par_for
	.align	16, 0x90
	.type	halide_set_custom_do_par_for,@function
halide_set_custom_do_par_for:           # @halide_set_custom_do_par_for
	.cfi_startproc
# BB#0:                                 # %entry
	movq	halide_custom_do_par_for@GOTPCREL(%rip), %rax
	movq	%rdi, (%rax)
	ret
.Ltmp29:
	.size	halide_set_custom_do_par_for, .Ltmp29-halide_set_custom_do_par_for
	.cfi_endproc

	.section	.text.halide_set_custom_trace,"axG",@progbits,halide_set_custom_trace,comdat
	.weak	halide_set_custom_trace
	.align	16, 0x90
	.type	halide_set_custom_trace,@function
halide_set_custom_trace:                # @halide_set_custom_trace
	.cfi_startproc
# BB#0:                                 # %entry
	movq	halide_custom_trace@GOTPCREL(%rip), %rax
	movq	%rdi, (%rax)
	ret
.Ltmp30:
	.size	halide_set_custom_trace, .Ltmp30-halide_set_custom_trace
	.cfi_endproc

	.section	.text.halide_shutdown_trace,"axG",@progbits,halide_shutdown_trace,comdat
	.weak	halide_shutdown_trace
	.align	16, 0x90
	.type	halide_shutdown_trace,@function
halide_shutdown_trace:                  # @halide_shutdown_trace
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbx
.Ltmp33:
	.cfi_def_cfa_offset 16
.Ltmp34:
	.cfi_offset %rbx, -16
	movq	halide_trace_file@GOTPCREL(%rip), %rbx
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.LBB7_2
# BB#1:                                 # %if.then
	callq	fclose@PLT
	movq	$0, (%rbx)
.LBB7_2:                                # %if.end
	popq	%rbx
	ret
.Ltmp35:
	.size	halide_shutdown_trace, .Ltmp35-halide_shutdown_trace
	.cfi_endproc

	.section	.text.halide_set_custom_allocator,"axG",@progbits,halide_set_custom_allocator,comdat
	.weak	halide_set_custom_allocator
	.align	16, 0x90
	.type	halide_set_custom_allocator,@function
halide_set_custom_allocator:            # @halide_set_custom_allocator
	.cfi_startproc
# BB#0:                                 # %entry
	movq	halide_custom_malloc@GOTPCREL(%rip), %rax
	movq	%rdi, (%rax)
	movq	halide_custom_free@GOTPCREL(%rip), %rax
	movq	%rsi, (%rax)
	ret
.Ltmp36:
	.size	halide_set_custom_allocator, .Ltmp36-halide_set_custom_allocator
	.cfi_endproc

	.section	.text.halide_error,"axG",@progbits,halide_error,comdat
	.weak	halide_error
	.align	16, 0x90
	.type	halide_error,@function
halide_error:                           # @halide_error
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rax
.Ltmp38:
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	movq	halide_error_handler@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.LBB9_2
# BB#1:                                 # %if.then
	movq	%rcx, %rdi
	popq	%rdx
	jmpq	*%rax  # TAILCALL
.LBB9_2:                                # %if.else
	leaq	.L.str26(%rip), %rdi
	xorl	%eax, %eax
	movq	%rcx, %rsi
	callq	halide_printf@PLT
	movl	$1, %edi
	popq	%rax
	jmp	exit@PLT                # TAILCALL
.Ltmp39:
	.size	halide_error, .Ltmp39-halide_error
	.cfi_endproc

	.section	.text.halide_set_error_handler,"axG",@progbits,halide_set_error_handler,comdat
	.weak	halide_set_error_handler
	.align	16, 0x90
	.type	halide_set_error_handler,@function
halide_set_error_handler:               # @halide_set_error_handler
	.cfi_startproc
# BB#0:                                 # %entry
	movq	halide_error_handler@GOTPCREL(%rip), %rax
	movq	%rdi, (%rax)
	ret
.Ltmp40:
	.size	halide_set_error_handler, .Ltmp40-halide_set_error_handler
	.cfi_endproc

	.section	.text.halide_copy_to_host,"axG",@progbits,halide_copy_to_host,comdat
	.weak	halide_copy_to_host
	.align	16, 0x90
	.type	halide_copy_to_host,@function
halide_copy_to_host:                    # @halide_copy_to_host
	.cfi_startproc
# BB#0:                                 # %entry
	ret
.Ltmp41:
	.size	halide_copy_to_host, .Ltmp41-halide_copy_to_host
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.align	4
.LCPI12_0:
	.long	989855744               # float 0.001953125
	.section	.rodata.cst16,"aM",@progbits,16
	.align	16
.LCPI12_1:
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	3                       # 0x3
.LCPI12_2:
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	7                       # 0x7
.LCPI12_3:
	.long	989855744               # float 1.953125e-03
	.long	989855744               # float 1.953125e-03
	.long	989855744               # float 1.953125e-03
	.long	989855744               # float 1.953125e-03
.LCPI12_4:
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	0                       # 0x0
	.byte	128                     # 0x80
	.byte	4                       # 0x4
	.byte	128                     # 0x80
	.byte	8                       # 0x8
	.byte	128                     # 0x80
	.byte	12                      # 0xc
	.byte	128                     # 0x80
.LCPI12_5:
	.byte	0                       # 0x0
	.byte	128                     # 0x80
	.byte	4                       # 0x4
	.byte	128                     # 0x80
	.byte	8                       # 0x8
	.byte	128                     # 0x80
	.byte	12                      # 0xc
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
	.byte	128                     # 0x80
.LCPI12_6:
	.long	1065353216              # 0x3f800000
	.long	1065353216              # 0x3f800000
	.long	1065353216              # 0x3f800000
	.long	1065353216              # 0x3f800000
.LCPI12_7:
	.long	2155872255              # 0x807fffff
	.long	2155872255              # 0x807fffff
	.long	2155872255              # 0x807fffff
	.long	2155872255              # 0x807fffff
.LCPI12_8:
	.long	127                     # 0x7f
	.long	127                     # 0x7f
	.long	127                     # 0x7f
	.long	127                     # 0x7f
.LCPI12_9:
	.long	4294967169              # 0xffffff81
	.long	4294967169              # 0xffffff81
	.long	4294967169              # 0xffffff81
	.long	4294967169              # 0xffffff81
.LCPI12_10:
	.long	1060205080              # float 6.931472e-01
	.long	1060205080              # float 6.931472e-01
	.long	1060205080              # float 6.931472e-01
	.long	1060205080              # float 6.931472e-01
.LCPI12_11:
	.long	1028743925              # float 5.111976e-02
	.long	1028743925              # float 5.111976e-02
	.long	1028743925              # float 5.111976e-02
	.long	1028743925              # float 5.111976e-02
.LCPI12_12:
	.long	3190627789              # float -1.690590e-01
	.long	3190627789              # float -1.690590e-01
	.long	3190627789              # float -1.690590e-01
	.long	3190627789              # float -1.690590e-01
.LCPI12_13:
	.long	3212836864              # float -1.000000e+00
	.long	3212836864              # float -1.000000e+00
	.long	3212836864              # float -1.000000e+00
	.long	3212836864              # float -1.000000e+00
.LCPI12_14:
	.long	1041846319              # float 1.497199e-01
	.long	1041846319              # float 1.497199e-01
	.long	1041846319              # float 1.497199e-01
	.long	1041846319              # float 1.497199e-01
.LCPI12_15:
	.long	3190598332              # float -1.686200e-01
	.long	3190598332              # float -1.686200e-01
	.long	3190598332              # float -1.686200e-01
	.long	3190598332              # float -1.686200e-01
.LCPI12_16:
	.long	1045207583              # float 1.998067e-01
	.long	1045207583              # float 1.998067e-01
	.long	1045207583              # float 1.998067e-01
	.long	1045207583              # float 1.998067e-01
.LCPI12_17:
	.long	3196053750              # float -2.499121e-01
	.long	3196053750              # float -2.499121e-01
	.long	3196053750              # float -2.499121e-01
	.long	3196053750              # float -2.499121e-01
.LCPI12_18:
	.long	1051372237              # float 3.333344e-01
	.long	1051372237              # float 3.333344e-01
	.long	1051372237              # float 3.333344e-01
	.long	1051372237              # float 3.333344e-01
.LCPI12_19:
	.long	3204448274              # float -5.000011e-01
	.long	3204448274              # float -5.000011e-01
	.long	3204448274              # float -5.000011e-01
	.long	3204448274              # float -5.000011e-01
.LCPI12_20:
	.long	2143289344              # float nan
	.long	2143289344              # float nan
	.long	2143289344              # float nan
	.long	2143289344              # float nan
.LCPI12_21:
	.long	4286578688              # float -inf
	.long	4286578688              # float -inf
	.long	4286578688              # float -inf
	.long	4286578688              # float -inf
.LCPI12_22:
	.long	1069066811              # float 1.442695e+00
	.long	1069066811              # float 1.442695e+00
	.long	1069066811              # float 1.442695e+00
	.long	1069066811              # float 1.442695e+00
.LCPI12_23:
	.long	901758606               # float 1.428607e-06
	.long	901758606               # float 1.428607e-06
	.long	901758606               # float 1.428607e-06
	.long	901758606               # float 1.428607e-06
.LCPI12_24:
	.long	1060205056              # float 6.931458e-01
	.long	1060205056              # float 6.931458e-01
	.long	1060205056              # float 6.931458e-01
	.long	1060205056              # float 6.931458e-01
.LCPI12_25:
	.long	967284723               # float 3.196593e-04
	.long	967284723               # float 3.196593e-04
	.long	967284723               # float 3.196593e-04
	.long	967284723               # float 3.196593e-04
.LCPI12_26:
	.long	983314022               # float 1.191568e-03
	.long	983314022               # float 1.191568e-03
	.long	983314022               # float 1.191568e-03
	.long	983314022               # float 1.191568e-03
.LCPI12_27:
	.long	1007360298              # float 8.489886e-03
	.long	1007360298              # float 8.489886e-03
	.long	1007360298              # float 8.489886e-03
	.long	1007360298              # float 8.489886e-03
.LCPI12_28:
	.long	1026188988              # float 4.160188e-02
	.long	1026188988              # float 4.160188e-02
	.long	1026188988              # float 4.160188e-02
	.long	1026188988              # float 4.160188e-02
.LCPI12_29:
	.long	1042984479              # float 1.666798e-01
	.long	1042984479              # float 1.666798e-01
	.long	1042984479              # float 1.666798e-01
	.long	1042984479              # float 1.666798e-01
.LCPI12_30:
	.long	1056964574              # float 4.999990e-01
	.long	1056964574              # float 4.999990e-01
	.long	1056964574              # float 4.999990e-01
	.long	1056964574              # float 4.999990e-01
.LCPI12_31:
	.long	128                     # 0x80
	.long	128                     # 0x80
	.long	128                     # 0x80
	.long	128                     # 0x80
.LCPI12_32:
	.long	2139095040              # float inf
	.long	2139095040              # float inf
	.long	2139095040              # float inf
	.long	2139095040              # float inf
	.text
	.globl	g
	.align	16, 0x90
	.type	g,@function
g:                                      # @g
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbp
.Ltmp47:
	.cfi_def_cfa_offset 16
	pushq	%r15
.Ltmp48:
	.cfi_def_cfa_offset 24
	pushq	%r14
.Ltmp49:
	.cfi_def_cfa_offset 32
	pushq	%rbx
.Ltmp50:
	.cfi_def_cfa_offset 40
	subq	$408, %rsp              # imm = 0x198
.Ltmp51:
	.cfi_def_cfa_offset 448
.Ltmp52:
	.cfi_offset %rbx, -40
.Ltmp53:
	.cfi_offset %r14, -32
.Ltmp54:
	.cfi_offset %r15, -24
.Ltmp55:
	.cfi_offset %rbp, -16
	testq	%rdi, %rdi
	je	.LBB12_1
# BB#3:                                 # %assert succeeded: buffer argument f1 is NULL
	movq	8(%rdi), %rcx
	movl	16(%rdi), %ebx
	cmpl	$8, %ebx
	movslq	48(%rdi), %rdx
	movl	$8, %r14d
	cmovgel	%ebx, %r14d
	leal	-8(%r14), %esi
	movl	%esi, %ebp
	sarl	$31, %ebp
	andl	%esi, %ebp
	leal	(%rbp,%rdx), %r15d
	testq	%rcx, %rcx
	movl	20(%rdi), %r8d
	movl	32(%rdi), %r10d
	movslq	36(%rdi), %r9
	movl	52(%rdi), %r11d
	jne	.LBB12_9
# BB#4:                                 # %assert succeeded: buffer argument f1 is NULL
	movq	(%rdi), %rax
	testq	%rax, %rax
	jne	.LBB12_9
# BB#5:                                 # %after_bb.thread
	movl	$4, 64(%rdi)
	movl	%r15d, 48(%rdi)
	movl	%r14d, 16(%rdi)
	movl	$1, 32(%rdi)
	movl	%r11d, 52(%rdi)
	movl	%r8d, 20(%rdi)
	movl	%r14d, 36(%rdi)
	movl	$0, 56(%rdi)
	movl	$0, 24(%rdi)
	movl	$0, 40(%rdi)
	movl	$0, 60(%rdi)
	movl	$0, 28(%rdi)
	movl	$0, 44(%rdi)
.LBB12_6:                               # %after_bb25
	xorl	%eax, %eax
	jmp	.LBB12_7
.LBB12_9:                               # %true_bb23
	cmpl	$4, 64(%rdi)
	jne	.LBB12_8
# BB#10:                                # %assert succeeded: Output buffer f1 has type float32, but elem_size of the buffer_t passed in is not 4
	testl	%ebp, %ebp
	js	.LBB12_11
# BB#12:                                # %assert succeeded: f1 is accessed before the min in dimension 0
	movl	%r14d, %eax
	subl	%ebx, %eax
	addl	%r15d, %eax
	cmpl	%edx, %eax
	jle	.LBB12_14
# BB#13:                                # %assert failed: f1 is accessed beyond the extent in dimension 0
	leaq	__unnamed_1(%rip), %rdi
	jmp	.LBB12_2
.LBB12_1:                               # %assert failed: buffer argument f1 is NULL
	leaq	__unnamed_2(%rip), %rdi
	jmp	.LBB12_2
.LBB12_8:                               # %assert failed: Output buffer f1 has type float32, but elem_size of the buffer_t passed in is not 4
	leaq	__unnamed_3(%rip), %rdi
	jmp	.LBB12_2
.LBB12_11:                              # %assert failed: f1 is accessed before the min in dimension 0
	leaq	__unnamed_4(%rip), %rdi
	jmp	.LBB12_2
.LBB12_14:                              # %assert succeeded: f1 is accessed beyond the extent in dimension 0
	cmpl	$1, %r10d
	jne	.LBB12_15
# BB#16:                                # %assert succeeded: Static constraint violated: f1.stride.0 == 1
	testl	%r8d, %r8d
	jle	.LBB12_6
# BB#17:                                # %for f1.v1.preheader
	addl	$7, %r14d
	sarl	$3, %r14d
	testl	%r14d, %r14d
	jle	.LBB12_6
# BB#18:
	movdqa	.LCPI12_1(%rip), %xmm5
	movdqa	.LCPI12_2(%rip), %xmm2
	movaps	.LCPI12_3(%rip), %xmm3
	xorps	%xmm13, %xmm13
	movdqa	.LCPI12_4(%rip), %xmm6
	movdqa	.LCPI12_5(%rip), %xmm12
	movaps	.LCPI12_6(%rip), %xmm10
	movaps	.LCPI12_7(%rip), %xmm4
	movslq	%r11d, %r10
	addl	%r11d, %r8d
	movq	%r10, %r11
	.align	16, 0x90
.LBB12_21:                              # %for f1.v0.v0.preheader.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB12_19 Depth 2
	movq	%r11, %r15
	leaq	1(%r15), %r11
	cvtsi2ssl	%r11d, %xmm0
	mulss	.LCPI12_0(%rip), %xmm0
	pshufd	$0, %xmm0, %xmm0        # xmm0 = xmm0[0,0,0,0]
	movdqa	%xmm0, 368(%rsp)        # 16-byte Spill
	subq	%r10, %r15
	imulq	%r9, %r15
	subq	%rdx, %r15
	xorl	%ebx, %ebx
	movl	%r14d, %ebp
	.align	16, 0x90
.LBB12_19:                              # %for f1.v0.v0.us
                                        #   Parent Loop BB12_21 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	cmpl	%esi, %ebx
	movl	%esi, %eax
	cmovlel	%ebx, %eax
	leal	1(%rax,%rdx), %edi
	movd	%edi, %xmm0
	pshufd	$0, %xmm0, %xmm0        # xmm0 = xmm0[0,0,0,0]
	movdqa	%xmm0, %xmm1
	paddd	%xmm5, %xmm1
	paddd	%xmm2, %xmm0
	cvtdq2ps	%xmm0, %xmm9
	cvtdq2ps	%xmm1, %xmm8
	mulps	%xmm3, %xmm8
	mulps	%xmm3, %xmm9
	movaps	%xmm9, %xmm0
	cmpltps	%xmm13, %xmm0
	movaps	%xmm8, %xmm7
	cmpltps	%xmm13, %xmm7
	pshufb	%xmm6, %xmm0
	pshufb	%xmm12, %xmm7
	movaps	%xmm9, %xmm3
	cmpleps	%xmm13, %xmm3
	pshufb	%xmm6, %xmm3
	movaps	%xmm8, %xmm2
	por	%xmm0, %xmm7
	cmpleps	%xmm13, %xmm2
	pshufb	%xmm12, %xmm2
	por	%xmm3, %xmm2
	psllw	$15, %xmm2
	psraw	$15, %xmm2
	movdqa	%xmm2, %xmm0
	punpckhbw	%xmm0, %xmm0    # xmm0 = xmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
	punpcklbw	%xmm0, %xmm2    # xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
	pslld	$31, %xmm0
	movdqa	%xmm0, 384(%rsp)        # 16-byte Spill
	blendvps	%xmm10, %xmm9
	pslld	$31, %xmm2
	movdqa	%xmm2, %xmm0
	blendvps	%xmm10, %xmm8
	movaps	%xmm8, %xmm0
	andps	%xmm4, %xmm0
	movaps	%xmm9, %xmm15
	andps	%xmm4, %xmm15
	movaps	%xmm15, %xmm12
	psrad	$22, %xmm12
	movaps	%xmm0, %xmm11
	psrad	$22, %xmm11
	movdqa	.LCPI12_8(%rip), %xmm5
	movdqa	%xmm5, %xmm10
	psubd	%xmm12, %xmm10
	pslld	$23, %xmm10
	por	%xmm15, %xmm10
	movdqa	.LCPI12_8(%rip), %xmm15
	psubd	%xmm11, %xmm15
	pslld	$23, %xmm15
	psrad	$23, %xmm9
	por	%xmm0, %xmm15
	psrad	$23, %xmm8
	movdqa	.LCPI12_9(%rip), %xmm0
	paddd	%xmm0, %xmm11
	paddd	%xmm8, %xmm11
	paddd	%xmm0, %xmm12
	paddd	%xmm9, %xmm12
	movdqa	%xmm10, %xmm0
	movaps	.LCPI12_11(%rip), %xmm3
	mulps	%xmm3, %xmm0
	movdqa	%xmm15, %xmm6
	mulps	%xmm3, %xmm6
	movdqa	%xmm10, %xmm3
	movaps	.LCPI12_12(%rip), %xmm1
	addps	%xmm1, %xmm0
	addps	.LCPI12_13(%rip), %xmm3
	mulps	%xmm3, %xmm0
	movaps	.LCPI12_14(%rip), %xmm1
	movaps	%xmm1, %xmm14
	addps	%xmm14, %xmm0
	mulps	%xmm3, %xmm0
	movaps	.LCPI12_15(%rip), %xmm4
	movaps	%xmm4, %xmm13
	addps	%xmm13, %xmm0
	mulps	%xmm3, %xmm0
	movaps	.LCPI12_16(%rip), %xmm1
	movaps	%xmm1, %xmm9
	addps	%xmm9, %xmm0
	mulps	%xmm3, %xmm0
	movaps	.LCPI12_17(%rip), %xmm4
	movaps	%xmm4, %xmm8
	addps	%xmm8, %xmm0
	mulps	%xmm3, %xmm0
	movaps	.LCPI12_18(%rip), %xmm1
	movaps	%xmm1, %xmm5
	addps	%xmm5, %xmm0
	mulps	%xmm3, %xmm0
	movaps	.LCPI12_19(%rip), %xmm4
	movaps	%xmm4, %xmm1
	addps	%xmm1, %xmm0
	mulps	%xmm3, %xmm3
	mulps	%xmm0, %xmm3
	movdqa	%xmm15, %xmm4
	addps	.LCPI12_12(%rip), %xmm6
	addps	.LCPI12_13(%rip), %xmm4
	mulps	%xmm4, %xmm6
	addps	%xmm14, %xmm6
	mulps	%xmm4, %xmm6
	addps	%xmm13, %xmm6
	mulps	%xmm4, %xmm6
	addps	%xmm9, %xmm6
	mulps	%xmm4, %xmm6
	addps	%xmm8, %xmm6
	mulps	%xmm4, %xmm6
	addps	%xmm5, %xmm6
	mulps	%xmm4, %xmm6
	addps	%xmm1, %xmm6
	mulps	%xmm4, %xmm4
	mulps	%xmm6, %xmm4
	addps	%xmm15, %xmm4
	movdqa	.LCPI12_8(%rip), %xmm0
	movdqa	%xmm0, %xmm9
	movaps	.LCPI12_10(%rip), %xmm0
	movaps	%xmm0, %xmm8
	psllw	$15, %xmm7
	psraw	$15, %xmm7
	cvtdq2ps	%xmm12, %xmm0
	cvtdq2ps	%xmm11, %xmm6
	movaps	.LCPI12_6(%rip), %xmm11
	movaps	%xmm11, %xmm12
	movaps	.LCPI12_13(%rip), %xmm14
	mulps	%xmm8, %xmm6
	mulps	%xmm8, %xmm0
	addps	%xmm10, %xmm3
	addps	%xmm0, %xmm3
	addps	%xmm6, %xmm4
	addps	%xmm14, %xmm4
	movdqa	%xmm7, %xmm0
	punpcklbw	%xmm0, %xmm0    # xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
	addps	%xmm14, %xmm3
	pslld	$31, %xmm0
	movaps	.LCPI12_21(%rip), %xmm1
	movaps	%xmm1, %xmm8
	movaps	.LCPI12_20(%rip), %xmm6
	movaps	%xmm6, %xmm5
	blendvps	%xmm5, %xmm8
	punpckhbw	%xmm0, %xmm7    # xmm7 = xmm7[8],xmm0[8],xmm7[9],xmm0[9],xmm7[10],xmm0[10],xmm7[11],xmm0[11],xmm7[12],xmm0[12],xmm7[13],xmm0[13],xmm7[14],xmm0[14],xmm7[15],xmm0[15]
	pslld	$31, %xmm7
	movaps	%xmm1, %xmm6
	movdqa	%xmm7, %xmm0
	blendvps	%xmm5, %xmm6
	movaps	384(%rsp), %xmm0        # 16-byte Reload
	blendvps	%xmm6, %xmm3
	movdqa	%xmm2, %xmm0
	blendvps	%xmm8, %xmm4
	movaps	368(%rsp), %xmm0        # 16-byte Reload
	mulps	%xmm0, %xmm4
	mulps	%xmm0, %xmm3
	movaps	%xmm3, %xmm0
	movaps	.LCPI12_22(%rip), %xmm1
	movaps	%xmm1, %xmm2
	mulps	%xmm2, %xmm0
	movaps	%xmm4, %xmm1
	mulps	%xmm2, %xmm1
	roundss	$1, %xmm1, %xmm2
	pshufd	$1, %xmm1, %xmm7        # xmm7 = xmm1[1,0,0,0]
	roundss	$1, %xmm0, %xmm5
	pshufd	$1, %xmm0, %xmm6        # xmm6 = xmm0[1,0,0,0]
	roundss	$1, %xmm7, %xmm7
	roundss	$1, %xmm6, %xmm6
	insertps	$16, %xmm6, %xmm5 # xmm5 = xmm5[0],xmm6[0],xmm5[2,3]
	pshufd	$3, %xmm0, %xmm6        # xmm6 = xmm0[3,0,0,0]
	movhlps	%xmm0, %xmm0            # xmm0 = xmm0[1,1]
	roundss	$1, %xmm0, %xmm0
	insertps	$32, %xmm0, %xmm5 # xmm5 = xmm5[0,1],xmm0[0],xmm5[3]
	pshufd	$3, %xmm1, %xmm0        # xmm0 = xmm1[3,0,0,0]
	movhlps	%xmm1, %xmm1            # xmm1 = xmm1[1,1]
	roundss	$1, %xmm1, %xmm1
	roundss	$1, %xmm0, %xmm0
	roundss	$1, %xmm6, %xmm6
	insertps	$48, %xmm6, %xmm5 # xmm5 = xmm5[0,1,2],xmm6[0]
	insertps	$16, %xmm7, %xmm2 # xmm2 = xmm2[0],xmm7[0],xmm2[2,3]
	insertps	$32, %xmm1, %xmm2 # xmm2 = xmm2[0,1],xmm1[0],xmm2[3]
	insertps	$48, %xmm0, %xmm2 # xmm2 = xmm2[0,1,2],xmm0[0]
	movaps	%xmm5, %xmm0
	movaps	.LCPI12_23(%rip), %xmm1
	mulps	%xmm1, %xmm0
	cvttps2dq	%xmm5, %xmm1
	movaps	.LCPI12_24(%rip), %xmm6
	mulps	%xmm6, %xmm5
	cvttps2dq	%xmm2, %xmm6
	subps	%xmm5, %xmm3
	movdqa	%xmm1, %xmm5
	paddd	%xmm9, %xmm5
	movdqa	%xmm5, %xmm13
	subps	%xmm0, %xmm3
	pslld	$23, %xmm13
	movaps	%xmm3, %xmm7
	movaps	.LCPI12_25(%rip), %xmm0
	mulps	%xmm0, %xmm7
	movaps	.LCPI12_26(%rip), %xmm0
	addps	%xmm0, %xmm7
	mulps	%xmm3, %xmm7
	movaps	.LCPI12_27(%rip), %xmm0
	movaps	%xmm0, %xmm15
	addps	%xmm15, %xmm7
	mulps	%xmm3, %xmm7
	movaps	.LCPI12_28(%rip), %xmm0
	movaps	%xmm0, %xmm11
	addps	%xmm11, %xmm7
	mulps	%xmm3, %xmm7
	movaps	.LCPI12_29(%rip), %xmm0
	movaps	%xmm0, %xmm9
	addps	%xmm9, %xmm7
	mulps	%xmm3, %xmm7
	movaps	.LCPI12_30(%rip), %xmm0
	movaps	%xmm0, %xmm8
	addps	%xmm8, %xmm7
	mulps	%xmm3, %xmm7
	addps	%xmm12, %xmm7
	mulps	%xmm3, %xmm7
	movdqa	.LCPI12_31(%rip), %xmm0
	movdqa	%xmm0, %xmm3
	pcmpgtd	%xmm1, %xmm0
	movdqa	%xmm3, %xmm1
	pshufb	.LCPI12_4(%rip), %xmm0
	pcmpgtd	%xmm6, %xmm1
	pshufb	.LCPI12_5(%rip), %xmm1
	por	%xmm0, %xmm1
	addps	%xmm12, %xmm7
	movaps	%xmm12, %xmm10
	psllw	$15, %xmm1
	psraw	$15, %xmm1
	movdqa	%xmm1, %xmm0
	punpckhbw	%xmm0, %xmm0    # xmm0 = xmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
	mulps	%xmm13, %xmm7
	pslld	$31, %xmm0
	movaps	.LCPI12_32(%rip), %xmm3
	movaps	%xmm3, %xmm14
	blendvps	%xmm7, %xmm3
	pxor	%xmm13, %xmm13
	movdqa	.LCPI12_5(%rip), %xmm12
	movaps	%xmm2, %xmm0
	mulps	.LCPI12_24(%rip), %xmm2
	subps	%xmm2, %xmm4
	mulps	.LCPI12_23(%rip), %xmm0
	subps	%xmm0, %xmm4
	movdqa	%xmm6, %xmm2
	paddd	.LCPI12_8(%rip), %xmm2
	movaps	%xmm4, %xmm6
	mulps	.LCPI12_25(%rip), %xmm6
	addps	.LCPI12_26(%rip), %xmm6
	mulps	%xmm4, %xmm6
	addps	%xmm15, %xmm6
	mulps	%xmm4, %xmm6
	addps	%xmm11, %xmm6
	mulps	%xmm4, %xmm6
	addps	%xmm9, %xmm6
	mulps	%xmm4, %xmm6
	addps	%xmm8, %xmm6
	mulps	%xmm4, %xmm6
	movaps	%xmm10, %xmm7
	addps	%xmm7, %xmm6
	mulps	%xmm4, %xmm6
	movdqa	%xmm2, %xmm0
	pslld	$23, %xmm0
	addps	%xmm7, %xmm6
	mulps	%xmm0, %xmm6
	punpcklbw	%xmm0, %xmm1    # xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
	movaps	%xmm14, %xmm4
	pslld	$31, %xmm1
	movdqa	%xmm1, %xmm0
	blendvps	%xmm6, %xmm4
	movdqa	.LCPI12_4(%rip), %xmm6
	pcmpgtd	%xmm13, %xmm5
	pshufb	%xmm6, %xmm5
	pcmpgtd	%xmm13, %xmm2
	pshufb	%xmm12, %xmm2
	por	%xmm5, %xmm2
	psllw	$15, %xmm2
	psraw	$15, %xmm2
	movdqa	%xmm2, %xmm0
	punpcklbw	%xmm0, %xmm0    # xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
	pslld	$31, %xmm0
	pxor	%xmm1, %xmm1
	blendvps	%xmm4, %xmm1
	punpckhbw	%xmm0, %xmm2    # xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
	pslld	$31, %xmm2
	xorps	%xmm4, %xmm4
	movdqa	%xmm2, %xmm0
	movdqa	.LCPI12_2(%rip), %xmm2
	movdqa	.LCPI12_1(%rip), %xmm5
	blendvps	%xmm3, %xmm4
	movaps	.LCPI12_3(%rip), %xmm3
	leal	(%rax,%rdx), %eax
	cltq
	addq	%r15, %rax
	movups	%xmm4, 16(%rcx,%rax,4)
	movaps	.LCPI12_7(%rip), %xmm4
	movups	%xmm1, (%rcx,%rax,4)
	addl	$8, %ebx
	decl	%ebp
	jne	.LBB12_19
# BB#20:                                # %end for f1.v0.v0.us
                                        #   in Loop: Header=BB12_21 Depth=1
	cmpl	%r8d, %r11d
	jne	.LBB12_21
	jmp	.LBB12_6
.LBB12_15:                              # %assert failed: Static constraint violated: f1.stride.0 == 1
	leaq	__unnamed_5(%rip), %rdi
.LBB12_2:                               # %assert failed: buffer argument f1 is NULL
	callq	halide_error@PLT
	movl	$-1, %eax
.LBB12_7:                               # %after_bb25
	addq	$408, %rsp              # imm = 0x198
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
.Ltmp56:
	.size	g, .Ltmp56-g
	.cfi_endproc

	.globl	g_jit_wrapper
	.align	16, 0x90
	.type	g_jit_wrapper,@function
g_jit_wrapper:                          # @g_jit_wrapper
	.cfi_startproc
# BB#0:                                 # %entry
	movq	(%rdi), %rdi
	jmp	g@PLT                   # TAILCALL
.Ltmp57:
	.size	g_jit_wrapper, .Ltmp57-g_jit_wrapper
	.cfi_endproc

	.type	halide_reference_clock_inited,@object # @halide_reference_clock_inited
	.section	.bss.halide_reference_clock_inited,"aGw",@nobits,halide_reference_clock_inited,comdat
	.weak	halide_reference_clock_inited
halide_reference_clock_inited:
	.byte	0                       # 0x0
	.size	halide_reference_clock_inited, 1

	.type	halide_reference_clock,@object # @halide_reference_clock
	.section	.bss.halide_reference_clock,"aGw",@nobits,halide_reference_clock,comdat
	.weak	halide_reference_clock
	.align	8
halide_reference_clock:
	.zero	16
	.size	halide_reference_clock, 16

	.type	halide_work_queue,@object # @halide_work_queue
	.section	.bss.halide_work_queue,"aGw",@nobits,halide_work_queue,comdat
	.weak	halide_work_queue
	.align	8
halide_work_queue:
	.zero	616
	.size	halide_work_queue, 616

	.type	halide_threads,@object  # @halide_threads
	.section	.bss.halide_threads,"aGw",@nobits,halide_threads,comdat
	.weak	halide_threads
	.align	4
halide_threads:
	.long	0                       # 0x0
	.size	halide_threads, 4

	.type	halide_thread_pool_initialized,@object # @halide_thread_pool_initialized
	.section	.bss.halide_thread_pool_initialized,"aGw",@nobits,halide_thread_pool_initialized,comdat
	.weak	halide_thread_pool_initialized
halide_thread_pool_initialized:
	.byte	0                       # 0x0
	.size	halide_thread_pool_initialized, 1

	.type	halide_custom_do_task,@object # @halide_custom_do_task
	.section	.bss.halide_custom_do_task,"aGw",@nobits,halide_custom_do_task,comdat
	.weak	halide_custom_do_task
	.align	8
halide_custom_do_task:
	.quad	0
	.size	halide_custom_do_task, 8

	.type	halide_custom_do_par_for,@object # @halide_custom_do_par_for
	.section	.bss.halide_custom_do_par_for,"aGw",@nobits,halide_custom_do_par_for,comdat
	.weak	halide_custom_do_par_for
	.align	8
halide_custom_do_par_for:
	.quad	0
	.size	halide_custom_do_par_for, 8

	.type	halide_custom_trace,@object # @halide_custom_trace
	.section	.bss.halide_custom_trace,"aGw",@nobits,halide_custom_trace,comdat
	.weak	halide_custom_trace
	.align	8
halide_custom_trace:
	.quad	0
	.size	halide_custom_trace, 8

	.type	halide_trace_file,@object # @halide_trace_file
	.section	.bss.halide_trace_file,"aGw",@nobits,halide_trace_file,comdat
	.weak	halide_trace_file
	.align	8
halide_trace_file:
	.quad	0
	.size	halide_trace_file, 8

	.type	halide_custom_malloc,@object # @halide_custom_malloc
	.section	.bss.halide_custom_malloc,"aGw",@nobits,halide_custom_malloc,comdat
	.weak	halide_custom_malloc
	.align	8
halide_custom_malloc:
	.quad	0
	.size	halide_custom_malloc, 8

	.type	halide_custom_free,@object # @halide_custom_free
	.section	.bss.halide_custom_free,"aGw",@nobits,halide_custom_free,comdat
	.weak	halide_custom_free
	.align	8
halide_custom_free:
	.quad	0
	.size	halide_custom_free, 8

	.type	halide_error_handler,@object # @halide_error_handler
	.section	.bss.halide_error_handler,"aGw",@nobits,halide_error_handler,comdat
	.weak	halide_error_handler
	.align	8
halide_error_handler:
	.quad	0
	.size	halide_error_handler, 8

	.type	.L.str26,@object        # @.str26
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str26:
	.asciz	"Error: %s\n"
	.size	.L.str26, 11

	.type	__unnamed_2,@object     # @0
	.section	.rodata,"a",@progbits
	.align	16
__unnamed_2:
	.asciz	"buffer argument f1 is NULL"
	.size	__unnamed_2, 27

	.type	__unnamed_3,@object     # @1
	.align	16
__unnamed_3:
	.asciz	"Output buffer f1 has type float32, but elem_size of the buffer_t passed in is not 4"
	.size	__unnamed_3, 84

	.type	__unnamed_4,@object     # @2
	.align	16
__unnamed_4:
	.asciz	"f1 is accessed before the min in dimension 0"
	.size	__unnamed_4, 45

	.type	__unnamed_1,@object     # @3
	.align	16
__unnamed_1:
	.asciz	"f1 is accessed beyond the extent in dimension 0"
	.size	__unnamed_1, 48

	.type	__unnamed_5,@object     # @4
	.align	16
__unnamed_5:
	.asciz	"Static constraint violated: f1.stride.0 == 1"
	.size	__unnamed_5, 45


	.ident	"clang version 3.4 (trunk 193715)"
	.ident	"clang version 3.4 (trunk 193715)"
	.ident	"clang version 3.4 (trunk 193715)"
	.ident	"clang version 3.4 (trunk 193715)"
	.ident	"clang version 3.4 (trunk 193715)"
	.ident	"clang version 3.4 (trunk 193715)"
	.ident	"clang version 3.4 (trunk 193715)"
	.ident	"clang version 3.4 (trunk 193715)"
	.ident	"clang version 3.4 (trunk 193715)"
	.ident	"clang version 3.4 (trunk 193715)"
	.section	".note.GNU-stack","",@progbits