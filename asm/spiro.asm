; Spirograph in x86_64 assembly (NASM) with OpenGL
; John Morrice 2011.  Released into the public domain

; A couple of warnings:
; 1. Some of this code is written in the unstructured paradigm.
; 2. This is my first assembly program.

BITS 64 

%define GL_COLOR_BUFFER_BIT 0x00004000
%define GL_POINTS 0
%define GL_VERTEX_ARRAY 0x8074
%define GL_DOUBLE 0x140A
%define SPIRO_LENGTH 10000

section .data
    name:   db 'NASM Spirograph', 0
    usage:  db 'Usage: %s MOVING FIXED OFFSET', 10, 0
    increment: dq __float64__(0.03)
    dbg_str: db '%f', 10, 0

section .text

    global main 

    extern stderr, printf, fprintf
    extern atof
    extern exit

    extern sin, cos

    extern glClear
    extern glEnableClientState, glDisableClientState
    extern glVertexPointer, glDrawArrays

    extern glutInit, glutInitDisplayMode, glutCreateWindow
    extern glutDisplayFunc, glutSwapBuffers, glutMainLoop


; Process arguments
; Expects:
;   argc in rdi
;   argv in rsi    
;   memory for 3 floats in rdx
; argc must equal 4, otherwise terminate
; Read argv into floats with atof
read_arguments:
    cmp rdi, 4
    jnz usage_error
    mov rcx, 3
    mov rbx, rsi
    add rbx, 8
    mov r8, rdx

; If arguments okay do: 
read_args:
    mov rdi, [rbx]
    mov rax, 0

    ; Call atof, preserving registers
    push rdx
    push r8
    push rcx
    call atof
    pop rcx
    pop r8
    pop rdx

    movq rax, xmm0 
    mov [r8], rax
    add rbx, 8
    add r8, 8
    dec rcx
    jnz read_args 
    ret

; Otherwise for incorrect arguments do:
usage_error:
    mov rdx, [rsi]
    mov rsi, usage
    mov rdi, [stderr]
    mov rax, 0
    call fprintf
    mov rdi, 1
    call exit 

; Display the vertex array
display:

    push rbp    
    mov rdi, GL_COLOR_BUFFER_BIT
    call glClear

    mov rdx, SPIRO_LENGTH
    mov rsi, 0
    mov rdi, GL_POINTS
    call glDrawArrays

    call glutSwapBuffers
    pop rbp
    ret

; Initialize OpenGL
initialize:
    ; Save argc to the stack
    ; Write that a pointer to argc to rdi for calling glutInit
    push rdi
    mov rdi, rsp
    call glutInit
    pop rdi

    mov rdi, 0
    call glutInitDisplayMode

    mov rdi, name 
    call glutCreateWindow

    mov rdi, display
    call glutDisplayFunc
    ret

; spiro_x is a little helper for draw_spiro
; y coordinate of spiro
spiro_x:

    mov rax, [rbp - 48]
    movq xmm0, rax 
    push rbp
    call cos

    pop rbp
    mov rax, [rbp - 40]
    movq xmm1, rax
    mulsd xmm0, xmm1

    movq [rbp - 56], xmm0
    
    mov rax, [rbp - 8]
    movq xmm0, rax
    push rbp
    call cos
    pop rbp
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
    push rbp
    call sin
    pop rbp
    mov rax, [rbp - 40]
    movq xmm1, rax
    mulsd xmm0, xmm1

    movq [rbp - 56], xmm0
    
    mov rax, [rbp - 8]
    movq xmm0, rax
    push rbp
    call sin 
    pop rbp
    mov rax, [rbp - 24]
    movq xmm1, rax
    mulsd xmm0, xmm1 

    mov rax, [rbp - 56]
    movq xmm1, rax
    subsd xmm0, xmm1 

    ret

; Draw the spiro into the vertex array
; xmm0: moving
; xmm1: fixed
; xmm2: offset
; rdi: vertices 
draw_spiro:
    
    push rbp
    mov rbp, rsp
    sub rsp, 56

    ; rbp - 8 is time t
    mov qword [rbp - 8], 0
    ; rbp - 16 is time increment
    mov rax, [increment]
    mov qword [rbp - 16], rax

    ; rbp - 24 becomes the path magnitude, fixed - moving
    subsd xmm1, xmm0
    movq [rbp - 24], xmm1

    ; rbp - 32 becomes the moving circle's radius
    movq [rbp - 32], xmm0

    ; rbp - 40 becomes the offset
    movq [rbp - 40], xmm2

    mov rcx, SPIRO_LENGTH

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
    
; Begin game loop
render:
    push rbp
    mov rbp, rsp
    ; The vertex array
    sub rsp, 16 * SPIRO_LENGTH

    ; Draw the spirograph
    mov rdi, rsp
    call draw_spiro

    mov rdi, GL_VERTEX_ARRAY
    call glEnableClientState

    mov rcx, rsp
    mov rdx, 0
    mov rsi, GL_DOUBLE
    mov rdi, 2
    call glVertexPointer

    call glutMainLoop

    mov rdi, GL_VERTEX_ARRAY
    call glDisableClientState

    mov rsp, rbp
    pop rbp
    ret

; Entry!
main:
    push rbp
    mov rbp, rsp
    
    ; Store the radii and offset in an array
    ; The array is pointed to by rdx
    sub rsp, 24
    mov rdx, rsp

    ; Get the radii etc from the command line arguments 
    push rdx
    push rsi
    push rdi
    call read_arguments
    pop rdi
    pop rsi
    pop rdx

    ; Initialize OpenGL
    push rdx
    call initialize
    pop rdx

    ; Extract the values of the radii etc 
    movq xmm0, [rdx]
    movq xmm1, [rdx + 8]
    movq xmm2, [rdx + 16]

    ; Draw the spirograph
    call render
 
    ; Return
    mov rax, 0
    mov rsp, rbp
    pop rbp
    ret
