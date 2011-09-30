; Spirograph benchmark
; John Morrice 2011
; Released under the WTFPL

%include "draw_spiro.asm"

%define SPIRO_LENGTH 100000

section .data
    moving: dq __float64__(0.2)
    fixed: dq __float64__(0.5)
    offset: dq __float64__(0.8)

section .text

    global main

main:
    push rbp
    mov rbp, rsp

    sub rsp, 16 * SPIRO_LENGTH

    mov rax, [moving]
    movq xmm0, rax
    mov rax, [fixed]
    movq xmm1, rax
    mov rax, [offset]
    movq xmm2, rax

    mov rsi, SPIRO_LENGTH
    mov rdi, rsp
    call draw_spiro 

    mov rax, 0
    mov rsp, rbp
    pop rbp
    ret
