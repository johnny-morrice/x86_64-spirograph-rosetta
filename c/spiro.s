	.file	"spiro.c"
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
	movss	%xmm0, -4(%rbp)
	movss	%xmm1, -8(%rbp)
	movss	%xmm2, -12(%rbp)
	movss	%xmm3, -16(%rbp)
	movss	-4(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	movss	-16(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	call	cos
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -32(%rbp)
	movss	-12(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movsd	%xmm0, -40(%rbp)
	movss	-16(%rbp), %xmm0
	mulss	-4(%rbp), %xmm0
	divss	-8(%rbp), %xmm0
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm0, %xmm0
	call	cos
	mulsd	-40(%rbp), %xmm0
	addsd	-32(%rbp), %xmm0
	unpcklpd	%xmm0, %xmm0
	cvtpd2ps	%xmm0, %xmm0
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
	movss	%xmm0, -4(%rbp)
	movss	%xmm1, -8(%rbp)
	movss	%xmm2, -12(%rbp)
	movss	%xmm3, -16(%rbp)
	movss	-4(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	movss	-16(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	call	sin
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -32(%rbp)
	movss	-12(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movsd	%xmm0, -40(%rbp)
	movss	-16(%rbp), %xmm0
	mulss	-4(%rbp), %xmm0
	divss	-8(%rbp), %xmm0
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm0, %xmm0
	call	sin
	mulsd	-40(%rbp), %xmm0
	movsd	-32(%rbp), %xmm1
	subsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	unpcklpd	%xmm0, %xmm0
	cvtpd2ps	%xmm0, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	spiro_y, .-spiro_y
	.section	.rodata
.LC3:
	.string	"%f radians\n"
	.text
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
	subq	$64, %rsp
	movss	%xmm0, -36(%rbp)
	movss	%xmm1, -40(%rbp)
	movss	%xmm2, -44(%rbp)
	movq	%rdi, -56(%rbp)
	movl	$0x00000000, %eax
	movl	%eax, -4(%rbp)
	movss	-40(%rbp), %xmm0
	subss	-36(%rbp), %xmm0
	movss	%xmm0, -12(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L4
.L5:
	movss	-4(%rbp), %xmm3
	movss	-44(%rbp), %xmm2
	movss	-36(%rbp), %xmm1
	movss	-12(%rbp), %xmm0
	call	spiro_x
	movss	%xmm0, -16(%rbp)
	movss	-4(%rbp), %xmm3
	movss	-44(%rbp), %xmm2
	movss	-36(%rbp), %xmm1
	movss	-12(%rbp), %xmm0
	call	spiro_y
	movss	%xmm0, -20(%rbp)
	movl	-8(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	-56(%rbp), %rax
	movl	-16(%rbp), %edx
	movl	%edx, (%rax)
	movl	-8(%rbp), %eax
	cltq
	addq	$1, %rax
	salq	$2, %rax
	addq	-56(%rbp), %rax
	movl	-20(%rbp), %edx
	movl	%edx, (%rax)
	movss	-4(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movsd	.LC1(%rip), %xmm1
	addsd	%xmm1, %xmm0
	unpcklpd	%xmm0, %xmm0
	cvtpd2ps	%xmm0, %xmm0
	movss	%xmm0, -4(%rbp)
	addl	$2, -8(%rbp)
.L4:
	cmpl	$19999, -8(%rbp)
	jle	.L5
	movss	-4(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movsd	.LC2(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movl	$.LC3, %eax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	draw_spiro, .-draw_spiro
	.globl	display
	.type	display, @function
display:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$16384, %edi
	call	glClear
	movl	$20000, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	glDrawArrays
	call	glutSwapBuffers
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	display, .-display
	.section	.rodata
.LC4:
	.string	"C Spirograph"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160016, %rsp
	movl	%edi, -160004(%rbp)
	movq	%rsi, -160016(%rbp)
	movq	-160016(%rbp), %rdx
	leaq	-160004(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	glutInit
	movl	$0, %edi
	call	glutInitDisplayMode
	movl	$.LC4, %edi
	call	glutCreateWindow
	movl	$display, %eax
	movq	%rax, %rdi
	call	glutDisplayFunc
	xorps	%xmm3, %xmm3
	xorps	%xmm2, %xmm2
	xorps	%xmm1, %xmm1
	xorps	%xmm0, %xmm0
	call	glClearColor
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	initialize, .-initialize
	.section	.rodata
	.align 8
.LC5:
	.string	"Usage: %s MOVING FIXED OFFSET\n"
	.text
	.globl	read_arguments
	.type	read_arguments, @function
read_arguments:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	cmpl	$4, -36(%rbp)
	jne	.L9
	.cfi_offset 3, -24
	movl	$1, -20(%rbp)
	jmp	.L10
.L11:
	movl	-20(%rbp), %eax
	cltq
	subq	$1, %rax
	salq	$2, %rax
	movq	%rax, %rbx
	addq	-56(%rbp), %rbx
	movl	-20(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atof
	unpcklpd	%xmm0, %xmm0
	cvtpd2ps	%xmm0, %xmm0
	movss	%xmm0, (%rbx)
	addl	$1, -20(%rbp)
.L10:
	cmpl	$3, -20(%rbp)
	jle	.L11
	jmp	.L13
.L9:
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movl	$.LC5, %ecx
	movq	stderr(%rip), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L13:
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	read_arguments, .-read_arguments
	.globl	render
	.type	render, @function
render:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160016, %rsp
	movss	%xmm0, -160004(%rbp)
	movss	%xmm1, -160008(%rbp)
	movss	%xmm2, -160012(%rbp)
	movl	$32884, %edi
	call	glEnableClientState
	leaq	-160000(%rbp), %rax
	movss	-160012(%rbp), %xmm2
	movss	-160008(%rbp), %xmm1
	movss	-160004(%rbp), %xmm0
	movq	%rax, %rdi
	call	draw_spiro
	leaq	-160000(%rbp), %rax
	movq	%rax, %rcx
	movl	$0, %edx
	movl	$5126, %esi
	movl	$2, %edi
	call	glVertexPointer
	call	glutMainLoop
	movl	$32884, %edi
	call	glDisableClientState
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	render, .-render
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	leaq	-32(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read_arguments
	movl	-32(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, -12(%rbp)
	movq	-48(%rbp), %rdx
	movl	-36(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	initialize
	movss	-12(%rbp), %xmm2
	movss	-8(%rbp), %xmm1
	movss	-4(%rbp), %xmm0
	call	render
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:
	.long	3951369912
	.long	1067366481
	.align 8
.LC2:
	.long	3229815407
	.long	1074340298
	.ident	"GCC: (GNU) 4.6.1 20110819 (prerelease)"
	.section	.note.GNU-stack,"",@progbits
