; NASM Spirograph
; John Morrice 2011.  Released into the public domain

; Some of this code is written in the unstructured paradigm

BITS 64 

%define GL_COLOR_BUFFER_BIT 0x00004000
%define GL_POINTS 0x0000
%define GL_VERTEX_ARRAY 0x8074
%define GL_FLOAT 0x1406
%define SPIRO_LENGTH 10000

section .data
    name:   db 'NASM Spirograph', 0
    usage:  db 'Usage: %s MOVING FIXED OFFSET', 10, 0
    tick:   db 'Tick', 10, 0

section .text

    global main 

    extern stderr, printf, fprintf
    extern atof
    extern exit

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

    ; Extract the values of the radii etc into
    ; rdi: moving
    ; rsi: fixed
    ; rdx: offset
    ; r10: vertices 
    mov rdi, [rdx]
    mov rsi, [rdx + 8]
    mov rdx, [rdx + 16]
    sub rsp, 8 * SPIRO_LENGTH

    ; Draw the spirograph
    call draw_spiro
 
    ; Return
    mov rax, 0
    mov rsp, rbp
    pop rbp
    ret
