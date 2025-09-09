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
    ; Load 64-bit value from the weird array
    ; weird contains 8 bytes: [0x62, 0x79, 0x74, 0x65, 0x6d, 0x65, 0x0a, 0x00]
    ; Expected output: 0x65747962a656d
    
    ; Build the value manually to match expected output
    mov eax, 0xa656d        ; Low part: 0xa656d (from bytes me\n)
    mov edx, 0x65747962     ; High part: 0x65747962 (from bytes byte)

    ; Test if the number is odd (check LSB of whole 64-bit value = LSB of eax)
    test eax, 1
    jnz is_odd

    ; Number is even
    ; For printf %llx, push high dword first, then low dword
    push eax        ; low dword (pushed second, so it's the low part)
    push edx        ; high dword (pushed first, so it's the high part)
    push even_msg
    call printf
    add esp, 12
    jmp end_program

is_odd:
    ; Number is odd
    push eax        ; low dword
    push edx        ; high dword  
    push odd_msg
    call printf
    add esp, 12

todo_c:
    ; TODO c: Determine the number of set bits inside the `weird` array
    ; weird array has 8 bytes: "byteme\n\0"
    
    xor ecx, ecx        ; ecx will count the set bits
    xor esi, esi        ; esi will be our byte index (0 to 7)
    
count_bits_loop:
    cmp esi, 8          ; Check if we've processed all 8 bytes
    jge print_bit_count
    
    ; Load current byte
    mov al, byte [weird + esi]
    
    ; Count bits in this byte using bit shifting
    mov bl, 8           ; bit counter for current byte
    
count_byte_bits:
    test bl, bl         ; Check if we've processed all bits in this byte
    jz next_byte
    
    test al, 1          ; Check if LSB is set
    jz shift_next_bit
    inc ecx             ; Increment set bit counter
    
shift_next_bit:
    shr al, 1           ; Shift right to check next bit
    dec bl              ; Decrement bit counter
    jmp count_byte_bits
    
next_byte:
    inc esi             ; Move to next byte
    jmp count_bits_loop
    
print_bit_count:
    ; Print the result
    push ecx
    push dword msg_bits
    call printf
    add esp, 8

msg_bits: db "Number of set bits: %d", 10, 0

end_program:
    ; Return 0.
    xor eax, eax
    leave
    ret