section .data
    result_format db "%d", 10, 0    ; Format string for printf

section .text
global main
extern printf

; TODO a: Implement `int pow(int a, int b)` which returns
; `a` at power of `b`.

pow:
    push ebp
    mov ebp, esp
    
    ; Get parameters: a = [ebp+8], b = [ebp+12]
    mov eax, [ebp+8]    ; eax = a (base)
    mov ecx, [ebp+12]   ; ecx = b (exponent)
    
    ; Handle edge cases
    cmp ecx, 0
    je pow_zero         ; if b == 0, return 1
    
    cmp ecx, 1
    je pow_done         ; if b == 1, return a (already in eax)
    
    ; Initialize result to 1
    mov edx, 1          ; edx will hold the result
    
pow_loop:
    cmp ecx, 0
    je pow_return       ; if exponent is 0, we're done
    
    imul edx, eax       ; result *= base
    dec ecx             ; exponent--
    jmp pow_loop
    
pow_zero:
    mov eax, 1          ; a^0 = 1
    jmp pow_done
    
pow_return:
    mov eax, edx        ; move result to return register
    
pow_done:
    leave
    ret

; TODO b: Implement RECURSIVELY `int pow_rec(int a, int b)`
; which returns `a` at power of `b`.

pow_rec:
    push ebp
    mov ebp, esp

    leave
    ret


main:
    push ebp
    mov ebp, esp

    ; TODO a: Call `pow` using 3 for `a` and 4 for `b`.
    ; NOTE: You must print the result.
    
    ; Push arguments in reverse order (right to left)
    push 4              ; b = 4
    push 3              ; a = 3
    call pow
    add esp, 8          ; clean up stack (2 parameters * 4 bytes)
    
    ; Print the result (3^4 = 81)
    push eax            ; push result as argument to printf
    push result_format  ; push format string
    call printf
    add esp, 8          ; clean up stack (2 parameters * 4 bytes)

    ; TODO b: Call `pow_rec` using 3 for `a` and 4 for `b`.
    ; NOTE: You must print the result.



    ; TODO c: Call `get_nano()` for each of the functions above
    ; in order to get the number of nanoseconds each one of them
    ; took to run.
    ; NOTE: You must print the name of the function that took
    ; less seconds to run.



    ; Return 0.
    xor eax, eax
    leave
    ret