Stack_Size      EQU     0x00000400


RCC_BASE		EQU	0x40021000	; 
RCC_IOPENR		EQU	RCC_BASE   + (0x34)
	
	
;GPIO-A control registers
GPIOA_BASE  	EQU 	(0x50000000) 
GPIOA_MODER		EQU     GPIOA_BASE + (0x00)
GPIOA_ODR		EQU		GPIOA_BASE + (0x14)

;GPIO-B control registers
GPIOB_BASE  EQU 	   (0x50000400) 
GPIOB_MODER	EQU        GPIOB_BASE + (0x00)
GPIOB_ODR	EQU        GPIOB_BASE + (0x14)


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
	
	; enable GPIOA clock, bit1 on IOPENR 
	LDR R6, =RCC_IOPENR
	LDR R5, [R6]
	; movs expects imm8, so this should be fine 
	MOVS R4, 0x1 
	ORRS R5, R5, R4
	STR R5, [R6]

	; setup PA8 for led 01 for bits 17-16 in MODER 
	LDR R6, =GPIOA_MODER
	LDR R5, [R6]
	; cannot do with movs, so use pc relative 
	LDR R4, =0x3000
	MVNS R4, R4 
	ANDS R5, R5, R4 
	LDR R4, =0x1000 
	ORRS R5, R5, R4
	STR R5, [R6]

	; turn on led connected to A8 in ODR 
	LDR R6, =GPIOA_ODR
	LDR R5, [R6]
	LDR R4, =0x100
	ORRS R5, R5, R4
	STR R5, [R6]
	
	NOP