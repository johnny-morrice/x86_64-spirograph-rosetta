	.file	"bench.c"
	.text
	.globl	spiro_x
	.type	spiro_x, @function
spiro_x:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movsd	%xmm0, -8(%rbp)
	movsd	%xmm1, -16(%rbp)
	movsd	%xmm2, -24(%rbp)
	movsd	%xmm3, -32(%rbp)
	movsd	-32(%rbp), %xmm0
	call	cos
	movapd	%xmm0, %xmm1
	mulsd	-8(%rbp), %xmm1
	movsd	%xmm1, -40(%rbp)
	movsd	-32(%rbp), %xmm0
	mulsd	-8(%rbp), %xmm0
	divsd	-16(%rbp), %xmm0
	call	cos
	mulsd	-24(%rbp), %xmm0
	addsd	-40(%rbp), %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	spiro_x, .-spiro_x
	.globl	spiro_y
	.type	spiro_y, @function
spiro_y:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movsd	%xmm0, -8(%rbp)
	movsd	%xmm1, -16(%rbp)
	movsd	%xmm2, -24(%rbp)
	movsd	%xmm3, -32(%rbp)
	movsd	-32(%rbp), %xmm0
	call	sin
	movapd	%xmm0, %xmm1
	mulsd	-8(%rbp), %xmm1
	movsd	%xmm1, -40(%rbp)
	movsd	-32(%rbp), %xmm0
	mulsd	-8(%rbp), %xmm0
	divsd	-16(%rbp), %xmm0
	call	sin
	mulsd	-24(%rbp), %xmm0
	movsd	-40(%rbp), %xmm1
	subsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	spiro_y, .-spiro_y
	.globl	draw_spiro
	.type	draw_spiro, @function
draw_spiro:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movsd	%xmm0, -56(%rbp)
	movsd	%xmm1, -64(%rbp)
	movsd	%xmm2, -72(%rbp)
	movq	%rdi, -80(%rbp)
	movl	$0, %eax
	movq	%rax, -8(%rbp)
	movsd	-64(%rbp), %xmm0
	subsd	-56(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L4
.L5:
	movsd	-8(%rbp), %xmm3
	movsd	-72(%rbp), %xmm2
	movsd	-56(%rbp), %xmm1
	movsd	-24(%rbp), %xmm0
	call	spiro_x
	movsd	%xmm0, -32(%rbp)
	movsd	-8(%rbp), %xmm3
	movsd	-72(%rbp), %xmm2
	movsd	-56(%rbp), %xmm1
	movsd	-24(%rbp), %xmm0
	call	spiro_y
	movsd	%xmm0, -40(%rbp)
	movl	-12(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	-80(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, (%rax)
	movl	-12(%rbp), %eax
	cltq
	addq	$1, %rax
	salq	$3, %rax
	addq	-80(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, (%rax)
	movsd	-8(%rbp), %xmm1
	movsd	.LC1(%rip), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	addl	$2, -12(%rbp)
.L4:
	cmpl	$99999, -12(%rbp)
	jle	.L5
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	draw_spiro, .-draw_spiro
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1600016, %rsp
	movl	%edi, -1600004(%rbp)
	movq	%rsi, -1600016(%rbp)
	leaq	-1600000(%rbp), %rax
	movsd	.LC2(%rip), %xmm2
	movsd	.LC3(%rip), %xmm1
	movsd	.LC4(%rip), %xmm0
	movq	%rax, %rdi
	call	draw_spiro
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:
	.long	3951369912
	.long	1067366481
	.align 8
.LC2:
	.long	2576980378
	.long	1072273817
	.align 8
.LC3:
	.long	0
	.long	1071644672
	.align 8
.LC4:
	.long	2576980378
	.long	1070176665
	.ident	"GCC: (GNU) 4.6.1 20110819 (prerelease)"
	.section	.note.GNU-stack,"",@progbits
