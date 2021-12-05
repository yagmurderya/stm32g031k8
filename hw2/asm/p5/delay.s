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
	
	MOVS R0, #5
	MOVS R1, #0 ; counter to test delay
	
delay
	SUBS R0, #1
	ADDS R1, #1
	CMP R0, #0 
	BNE delay
	

    ; Edit above this line
    B .
    ENDP

    END