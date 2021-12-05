Stack_Size      EQU     0x00000400

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp

    THUMB

    AREA    RESET, DATA, READONLY
    EXPORT  __Vectors

__Vectors
    DCD     __initial_sp                   ; Top of Stack
    DCD     Reset_Handler                  ; Reset Handler
    DCD     NMI_Handler                    ; NMI Handler
    DCD     HardFault_Handler              ; Hard Fault Handler

    AREA    |.text|, CODE, READONLY


; nmi handler
NMI_Handler    PROC
    EXPORT  NMI_Handler
    B .
    ENDP


; hardfault handler
HardFault_Handler    PROC
    EXPORT  HardFault_Handler
    B .
    ENDP


; entry function
Reset_Handler    PROC
    EXPORT  Reset_Handler
    ; Edit below this line
	
	;the values are assumed as 16-bit
	;LDR R0,=0x14224
	;LDR R1,=0x14228
	
	MOVS R2, #0x0 ; to count ones
	MOVS R3, #0x0 ; to shift
	
loop
	LDR R4,=0x14224;[R0] ; R4 = mem[0x14224]
	LDR R5,=0x14220;[R1] ; R5 = mem[0x14228]
	EORS R4, R4, R5 ; R4 = R4 ^ R5
	ASRS R4, R4, R3 ; R4 = R4 >> R3
	MOVS R7, #0x1
	ADDS R3, #1 ; increase R3 to shift one more right in every loop
	CMP R3, #21 
	BEQ finish ; if R3 = 17 leave the loop and go to <finish>
	ANDS R7, R7, R4 ; if R3 != 17, R7 = R7 & R4
	CMP R7, #1
	BNE loop ; if R7 != 1, go back to loop
	ADDS R2, R2, #1 ; if R7 = 1, increase counter
	B loop ; go back to loop
	
finish
	;LDR R6, =0x1422C
	;STR R2, [R6]
	ADDS R2, #0
	
	

    ; Edit above this line
    B .
    ENDP

    END