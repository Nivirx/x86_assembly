bits 64

;
; FizzBuzz from 1-100 print fizz on multiples of 3, buzz on multiples of 5, and fizzbuzz on multiples of 15
;

struc controlStruct
    .is_div_3 resw 1
    .is_div_5 resw 1
    .number   resd 1
endstruc

SECTION .data
    const_fizz: db "fizz"
    const_fizzLen: equ $-const_fizz

    const_buzz: db "buzz"
    const_buzzLen: equ $-const_buzz

SECTION .bss
    buf: resb 16                        ; 16 byte char buffer, which is much more than we need
    bufLen: resd 1

    control: resb controlStruct_size    ; using a structure in bss because it is easier to manage than adjusting the stack pointer
                                        ; not the best way to do this, I know.
SECTION .text
    GLOBAL _start 
_start:
    nop                                 ; gdb seems to like having the nop here, idk.

    mov [control + controlStruct.number], dword 1
    mov r8d, dword [control + controlStruct.number]
fizzbuzz:
    mov eax, r8d
    xor edx, edx
    div dword [rel div_base3]            ; dividend in edx:eax -> quotient in eax, remainder in edx
    mov [control + controlStruct.is_div_3], dx

    mov eax, r8d
    xor edx, edx
    div dword [rel div_base5]
    mov [control + controlStruct.is_div_5], dx

    cmp r8d, 100
    jg wait_and_exit

    call is_fizz
    call is_buzz
    call is_number

    lea rdi, [base10]
    mov esi, 1
    call put_string

    inc r8d
    mov [control + controlStruct.number], r8d
    jmp fizzbuzz

is_fizz:
    xor eax, eax
    mov ax, word [control + controlStruct.is_div_3]
    cmp ax, 0
    jne is_fizz.return                  ; if control.is_div_3 isn't zero then it isn't a multiple of 3

    lea rdi, [const_fizz]
    mov esi, const_fizzLen
    call put_string

.return:  
    ret

is_buzz:
    xor eax, eax
    mov ax, word [control + controlStruct.is_div_5]
    cmp ax, 0
    jne is_buzz.return                  ; if control.is_div_5 isn't zero then it isn't a multiple of 5

    lea rdi, [const_buzz]
    mov esi, const_buzzLen
    call put_string

.return:
    ret

is_number:
    xor eax, eax
    mov ax, word [control + controlStruct.is_div_3]
    cmp ax, 0
    je is_number.return

    mov ax, word [control + controlStruct.is_div_5]
    cmp ax, 0
    je is_number.return

    lea rdi, [control + controlStruct.number]
    call display_number

.return:
    ret

display_number:
    xor ecx, ecx                ; character count
    xor ebx, ebx                ; buf offset

    mov eax, [rdi]
.do_div:
    
    xor edx, edx                ; ensure edx is zeroed because of div EDX:EAX/10 
    div dword [rel base10]      ; dividend in edx:eax -> quotient in eax, remainder in edx
    or dl, '0'                  ; convert to ascii represetation
    push rdx                    ; store on stack to pop off in the correct order later
    inc ecx
    test eax, eax
    jnz display_number.do_div

    mov [bufLen], ecx           ; store length of number
    
.unstack:
    pop rdx
    mov [buf + ebx], dl         ; ebx offset into buf, ecx is the digit count
    inc ebx
    dec ecx
    test ecx, ecx
    jnz display_number.unstack

; basicly a inline put_string(...)
.write_number:
    mov eax, 1                  ; sys_write(uint64_t fd, char *buf, size_t count)
    mov edi, 1                  ; uint64 fd, 1 = STDOUT
    lea rsi, [buf]              ; const char *buf
    mov edx, [bufLen]           ; size_t count
    syscall

    ret

wait_and_exit:
    lea rdi, [buf]              ; char *buf
    mov esi, dword [bufLen]     ; size_t count
    call read_input

    mov eax, 60                 ; sys_exit
    mov edi, 0                  ; int error_code
    syscall

; read_input(char *buf, size_t count)
read_input:
    push rcx                    ;rcx and r11 are clobbered in syscalls
    push r11

    mov rdx, rsi                ; second arg to 3rd syscall arg
    mov rsi, rdi                ; first arg to 2nd syscall arg
    xor rdi, rdi                ; 0 = STDIN, 1st syscall arg

    mov eax, 0                  ; sys_read(uint64 fd, char *buf, size_t count)
    syscall

    pop r11
    pop rcx

    ret

; put_string(char *buf, size_t count)
put_string:
    push rcx                    ;rcx and r11 are clobbered in syscalls
    push r11

    mov rdx, rsi                ; second arg to 3rd syscall arg
    mov rsi, rdi                ; first arg to 2nd syscall arg
    mov edi, 1                  ; 1 = STDOUT, 1st syscall arg

    mov eax, 1                  ; sys_write(uint64 fd, char *buf, size_t count)
    syscall

    pop r11
    pop rcx

    ret

; done to use rip relative addressing
in_text_data:
    div_base3: dd 3h
    div_base5: dd 5h
    base10:    dd 0Ah
    newline:   db 0Ah


