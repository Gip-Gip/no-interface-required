; No Interface Required, a really small esoteric programming lanuage
;                        and compiler for the Altair 8080(126 bytes!)

; The Public File License (see https://github.com/Gip-Gip/PFL for info)

; Copyright Charles "Gip-Gip" Thompson, December 17th, 2015

; In this case, a file is a named group of digital data that can be
; transferred and used.

; The copyright holder of the file nir.asm has declared that the file
; and everything taken from it, unless stated otherwise, is free for any
; use by any one, with the exception of preventing the free use of the
; unmodified file, including but not limited to patenting and/or claiming
; further copyright on the unmodified file.

; THE FILE nir.asm IS PROVIDED WITHOUT ANY WARRANTY OR GUARANTEE AT ALL
; THE AUTHOR IS NOT LIABLE FOR CLAIMS, DAMAGES, OR REALLY ANYTHING ELSE IN
; CONNECTION TO THIS FILE, UNLESS EXPLICITLY STATED OTHERWISE.

; commands:
; / = set the pointer to zero
; * = set the value at the pointer to 0
; > = increment the pointer's location
; + = increment the value the pointer is pointing at
; < = decrement the pointer's location
; - = decrement the value the pointer is pointing at
; ? = jump to return mark if the value at the pointer is not zero
; ! = jump to return mark if the value at the pointer is zero
; @ = return mark
; | = end of code

    ORG 100h ; The address at which this compiler is being loaded to

    LXI D, 3FFh ; The location of the code being compiled, minus one
    LXI H, 200h ; The location of the output binary

loop:
    INX D ; Increment the code offset
    LDAX D ; Load the character into the accumulator

    CPI '|' ; If the character was the end of code command, jump to end
    JZ end

    CPI '@' ; If the character is a return point, jump to mk_returnPoint
    JZ mk_returnPoint

;==============================================================================
;                                JUMP COMMANDS:
;==============================================================================

    CPI '?' ; If the character is a jump on not zero command...
    MVI A, 0C2h ; Generate a conditional jump using JNZ(0xC2)
    JZ mk_jump

    LDAX D ; Reload the accumulator
    CPI '!' ; If the character is a jump on zero command...
    MVI A, 0CAh ; Generate a conditional jump using JZ(0xCE)
    JZ mk_jump

;==============================================================================
;                              ONE-BYTE COMMANDS:
;==============================================================================

    LDAX D ; Reload the accumulator
    CPI '+' ; If the character is a increment at pointer command...
    MVI A, 34h ; Write INR M(0x34)
    JZ mk_oneByte

    LDAX D ; Reload the accumulator
    CPI '-' ; If the character is a decrement at pointer command...
    MVI A, 35h ; Write DCR M(0x35)
    JZ mk_oneByte

    LDAX D ; Reload the accumulator
    CPI '>' ; If the character is a increment pointer command...
    MVI A, 23h ; Write INX H(0x23)
    JZ mk_oneByte

    LDAX D ; Reload the accumulator
    CPI '<' ; If the character is a decrement pointer command,,,
    MVI A, 2Bh ; Write DCX H(0x2B)
    JZ mk_oneByte

;==============================================================================
;                                ZERO COMMANDS:
;==============================================================================

    LDAX D ; Reload the accumulator
    CPI '/' ; If the character is a set pointer to zero command...
    MVI A, 21h ; Write LXI H, 0(0x21 + 0 + 0)
    JZ mk_zero

    LDAX D ; Reload the accumulator
    CPI '*' ; If the character is a set at pointer to zero command...
    MVI A, 36h ; Write MVI M, 0 + NOP (0x36 + 0 + 0)
    JZ mk_zero

    JMP loop ; Jump back to loop

mk_zero:
    MOV M, A ; Write the opcode given in the accumulator

    INX H ; Increment the output offset

    MVI M, 0 ; Write a zero

    INX H ; Increment the output offset

    MVI M, 0 ; Write another zero

    INX H ; Increment the output offset

    JMP loop ; Jump back to the loop

mk_oneByte:
    MOV M, A ; Write the opcode given in the accumulator

    INX H ; Increment the output offset

    JMP loop ; Jump Back to the loop!

mk_jump:
    MVI M, 7Eh ; Write the opcode MOV A, M(0x7E)

    INX H ; Increment the output offset

    MVI M, 0FEh ; Write the opcode CPI(0xFE)

    INX H ; Increment the output offset

    MVI M, 0 ; Write the CPI comparison (0)

    INX H ; Increment the output offset

    MOV M, A ; Write the jump type stored in the accumulator

    INX H ; Increment the output offset

    MOV M, B ; Write the first part of the stored return point

    INX H ; Increment the output offset

    MOV M, C ; Write the second part of the stored return point

    INX H ; Increment the output offset

    JMP loop ; Jump back to the loop


mk_returnPoint:
    MOV B, L ; Move HL to BC(it's inversed, for some reason)
    MOV C, H

    JMP loop ; Jump back to the loop

end:
    MVI M, 76h ; Store the HLT opcode to the output offset

    HLT ; Stop execution!
