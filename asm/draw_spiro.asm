; Draw a Spirograph
; John Morrice 2011
; Released under the WTFPL

section .text

    extern sin, cos

; Draw the spiro into the vertex array
; xmm0: moving
; xmm1: fixed
; xmm2: offset
; rdi: vertex array 
; rsi: length of vertex array
draw_spiro:
    
    push rbp
    mov rbp, rsp
    sub rsp, 56

    ; rbp - 8 is time t
    mov qword [rbp - 8], 0
    ; rbp - 16 is time increment
    mov rax, __float64__(0.03)
    mov qword [rbp - 16], rax

    ; rbp - 24 becomes the path magnitude, fixed - moving
    subsd xmm1, xmm0
    movq [rbp - 24], xmm1

    ; rbp - 32 becomes the moving circle's radius
    movq [rbp - 32], xmm0

    ; rbp - 40 becomes the offset
    movq [rbp - 40], xmm2

    mov rcx, rsi

; Drawing loop
parametric:

    push rcx

    ; rbp - 48 becomes t * magnitude / moving
    mov rax, [rbp - 8]
    movq xmm0, rax
    mov rax, [rbp - 24]
    movq xmm1, rax
    mulsd xmm0, xmm1
    mov rax, [rbp - 32]
    movq xmm1, rax
    divsd xmm0, xmm1
    movq [rbp - 48], xmm0

    ; Write x into the vertex array
    push rdi
    call spiro_x
    pop rdi
    movq [rdi], xmm0

    add rdi, 8

    ; Write y into the vertex array
    push rdi
    call spiro_y
    pop rdi
    movq [rdi], xmm0

    add rdi, 8   
 
    pop rcx

    ; Increment time
    mov rax, [rbp - 8]
    movq xmm0, rax
    mov rax, [rbp - 16]
    movq xmm1, rax
    addsd xmm0, xmm1 
    movq [rbp - 8], xmm0

    ; Decrement counter
    dec rcx
    jnz parametric

    mov rsp, rbp
    pop rbp
    ret

; spiro_x is a little helper for draw_spiro
; y coordinate of spiro
spiro_x:

    mov rax, [rbp - 48]
    movq xmm0, rax 
    call cos
    mov rax, [rbp - 40]
    movq xmm1, rax
    mulsd xmm0, xmm1

    movq [rbp - 56], xmm0
    
    mov rax, [rbp - 8]
    movq xmm0, rax
    call cos
    mov rax, [rbp - 24]
    movq xmm1, rax
    mulsd xmm0, xmm1

    mov rax, [rbp - 56]
    movq xmm1, rax

    addsd xmm0, xmm1 

    ret

; spiro_y is a little helper for draw_spiro
; y coordinate of spiro
spiro_y:
    mov rax, [rbp - 48]
    movq xmm0, rax 
    call sin
    mov rax, [rbp - 40]
    movq xmm1, rax
    mulsd xmm0, xmm1

    movq [rbp - 56], xmm0
    
    mov rax, [rbp - 8]
    movq xmm0, rax
    call sin 
    mov rax, [rbp - 24]
    movq xmm1, rax
    mulsd xmm0, xmm1 

    mov rax, [rbp - 56]
    movq xmm1, rax
    subsd xmm0, xmm1 

    ret
