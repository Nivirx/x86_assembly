aStruc: struc aStruct
    .reserved1 resb 1
    .somestr resb 5
    .reserved2 resb 2
endstruc

SECTION .data
    dataStr: db "Hello, World!",10
    dataStr_len: equ $-dataStr
SECTION .bss
    myStruc: resb aStruct_size
SECTION .text
    GLOBAL _start
_start:
    nop

    call copy_str

    lea rdi, [dataStr]
    mov rsi, dataStr_len
    call display_str

    lea rdi, [myStruc + aStruct.somestr]
    mov rsi, dataStr_len
    call display_str

    mov eax, 60                 ; sys_exit
    mov edi, 0                  ; int error_code
    syscall

; void copy_str()
copy_str:
    xor rcx, rcx
.L1:
    mov al, byte [dataStr + rcx]
    mov [myStruc + aStruct.somestr + rcx], byte al

    inc rcx
    cmp rcx, dataStr_len
    jl copy_str.L1

    ret

; int display_str(char* str, size_t len)
display_str:
    mov r8, rdi
    mov r9, rsi

    mov eax, 1                  ; sys_write
    mov edi, 1                  ; uint64 fd, 1 = STDOUT
    lea rsi, [r8]               ; const char *buf
    mov edx, r9d                ; size_t count
    syscall

    ret