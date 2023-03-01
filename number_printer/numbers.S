bits 64

;
; takes the number 0xffffffff and displays the ascii representation in decimal
; only supports up to UINT32_MAX, not designed for signed numbers.
;

SECTION .data
    prompt:     db "Look ma' no libc!",10
    promptLen:  equ $-prompt
    number:     dd 0xffffffff   ; 4 2 9 4 9 6 7 2 9 5
    base:       dd 0xa
SECTION .bss
    buffer:     resb 2

SECTION .text
    GLOBAL _start

_start:
    nop

    mov eax, 1                  ; sys_write
    mov edi, 1                  ; uint64 fd, 1 = STDOUT
    lea rsi, [prompt]           ; const char *buf
    mov edx, promptLen          ; size_t count
    syscall

    lea edi, [number]
    call get_numbers

    mov eax, 60                 ; sys_exit
    mov edi, 0                  ; int error_code
    syscall

; void get_numbers(uint32_t &number) { ... }
; prints digits of a uint32
get_numbers:
    xor rax, rax
    mov eax, [edi]
_do_div:
    xor edx, edx
    div dword [base]            ; dividend in edx:eax -> quotient in eax, remainder in edx

    add dl, '0'
    mov [buffer], dl            ; convert remainder to ascii and store in buffer
    mov [buffer+1], byte 0xa

    push rax                    ; save quotient

    mov eax, 1                  ; sys_write
    mov edi, 1                  ; uint64 fd, 1 = STDOUT
    lea rsi, [buffer]           ; const char *buf
    mov edx, 2                  ; size_t count
    syscall

    pop rax                     ; restore quotient

    test eax, eax               ; if number is not 0 then keep dividing and displaying digits
    jnz _do_div

    ret