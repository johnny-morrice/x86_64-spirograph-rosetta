; NASM Spirograph
; John Morrice 2011.  Released into the public domain

; A couple of warnings:
; 1. Some of this code is written in the unstructured paradigm.
; 2. This AMD64 OpenGL application is my first assembly program.

BITS 64 

%define GL_COLOR_BUFFER_BIT 0x00004000
%define GL_POINTS 0x0000
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
    
    mov rdi, GL_COLOR_BUFFER_BIT
    call glClear

    mov rdx, SPIRO_LENGTH
    mov rsi, 0
    mov rdi, GL_POINTS
    call glDrawArrays

    call glutSwapBuffers
    ret

; Initialize OpenGL
initialize:
    ; Save rdi
    ; Write that location to rdi for calling glutInit
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
; Returns into xmm6
spiro_x:
    movq xmm7, xmm2
    movq xmm0, xmm4
    call cos
    mulsd xmm7, xmm0
    movq xmm0, xmm6
    call cos
    mulsd xmm0, xmm3
    addsd xmm7, xmm0
    ret

; spiro_y is a little helper for draw_spiro
; Returns into xmm6
spiro_y:
    movq xmm7, xmm2
    movq xmm0, xmm4
    call sin
    mulsd xmm7, xmm0
    movq xmm0, xmm6
    call sin 
    mulsd xmm0, xmm3
    subsd xmm7, xmm0
    ret

; Draw the spiro into the vertex array
; xmm1: moving
; xmm2: fixed
; xmm3: offset
; rdi: vertices 
draw_spiro:
    
    mov rax, 0
    ; xmm4 is time t
    movq xmm4, rax
    ; xmm5 is the time increment
    mov rax, 0
    mov rax, increment
    movq xmm5, rax
    
    ; xmm2 becomes the path magnitude r, fixed - moving
    subsd xmm2, xmm1

    mov rcx, SPIRO_LENGTH

; Drawing loop
parametric:

    push rcx

    ; xmm6 becomes t * r / moving
    movq xmm6, xmm4
    mulsd xmm6, xmm2
    divsd xmm6, xmm1

    ; Write x into the vertex array
    push rdi
    call spiro_x
    pop rdi
    movq [rdi], xmm7

    add rdi, 8

    ; Write y into the vertex array
    push rdi
    call spiro_y
    pop rdi
    movq [rdi], xmm7
 
    push rdi
    push rbp
    mov rbp, rsp
    movq xmm0, xmm5
    mov rdi, dbg_str
    mov rax, 1
    call printf
    pop rbp
    pop rdi
    
    pop rcx

    ; Increment time
    addsd xmm4, xmm5 

    ; Decrement counter
    dec rcx
    jnz parametric

    ret
    
; Begin game loop
render:
    ; The vertex array
    sub rsp, 16 * SPIRO_LENGTH

    ; Draw the spirograph
    mov rdi, rsp
    call draw_spiro

    mov rdi, GL_VERTEX_ARRAY
    call glEnableClientState

    mov rdi, 2
    mov rsi, GL_DOUBLE
    mov rdx, 0
    mov rcx, rsp
    call glVertexPointer

    call glutMainLoop

    mov rdi, GL_VERTEX_ARRAY
    call glDisableClientState

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
    movq xmm1, [rdx]
    movq xmm2, [rdx + 8]
    movq xmm3, [rdx + 16]

    ; Draw the spirograph
    call render
 
    ; Return
    mov rax, 0
    mov rsp, rbp
    pop rbp
    ret
