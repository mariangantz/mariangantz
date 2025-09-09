%include "printf32.asm"

section .rodata
    weird: db "byteme", 10, 0
    pos_msg: db "The number %d is positive", 10, 0
    neg_msg: db "The number %d is negative", 10, 0
    odd_msg: db "The number %#llx is odd", 10, 0
    even_msg: db "The number %#llx is even", 10, 0

section .text
extern printf
global main

main:
    push ebp
    mov ebp, esp

    ; TODO a: Determine whether the signed integer saved at the
    ; middle of the `weird` array is positive.
    ; NOTE: You must print "The number <nr> is positive" if nr
    ; is higher that 0, or "The number <nr> is negative", otherwise.
    
    ; The weird array has 8 bytes: "byteme\n\0"
    ; Middle 32-bit integer starts at offset 2 (bytes 2-5: 't','e','m','e')
    mov eax, dword [weird + 2]
    
    ; Check if positive (> 0)
    cmp eax, 0
    jg positive
    
    ; Print negative message
    push eax
    push neg_msg
    call printf
    add esp, 8
    jmp todo_b
    
positive:
    ; Print positive message
    push eax
    push pos_msg
    call printf
    add esp, 8

todo_b:
    ; TODO b: Determine whether the signed quad word
    ; represented by the `weird` array is odd or even.
    ; NOTE: You must print "The number <nr> is odd" if nr
    ; is odd, or "The number <nr> is even", otherwise.
    
    ; Load the entire 8-byte array as a quad word (64-bit)
    mov eax, dword [weird]      ; Load first 32 bits
    mov edx, dword [weird + 4]  ; Load second 32 bits
    
    ; Check if odd by testing the least significant bit of the lower 32 bits
    test eax, 1
    jnz is_odd
    
    ; Number is even
    push edx        ; Push upper 32 bits
    push eax        ; Push lower 32 bits
    push even_msg
    call printf
    add esp, 12
    jmp end_program
    
is_odd:
    ; Number is odd
    push edx        ; Push upper 32 bits
    push eax        ; Push lower 32 bits
    push odd_msg
    call printf
    add esp, 12

end_program:
    ; Return 0.
    xor eax, eax
    leave
    ret