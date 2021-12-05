/*
 *
 * Project #1
 * Yagmur Derya 171024011
 *
*/

.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb


/* make linker see this */
.global Reset_Handler

/* get these from linker script */
.word _sdata
.word _edata
.word _sbss
.word _ebss


/* define peripheral addresses from RM0444 page 57, Tables 3-4 */
.equ RCC_BASE,         (0x40021000)          // RCC base address
.equ RCC_IOPENR,       (RCC_BASE   + (0x34)) // RCC IOPENR offset

.equ GPIOA_BASE,       (0x50000000)          // GPIOA base address
.equ GPIOA_MODER,      (GPIOA_BASE + (0x00)) // GPIOA MODER offset
.equ GPIOA_ODR,        (GPIOA_BASE + (0x14)) // GPIOA ODR offset
.equ GPIOA_IDR,        (GPIOA_BASE + (0x10)) // GPIOA IDR offset

.equ GPIOB_BASE,       (0x50000400)          // GPIOB base address
.equ GPIOB_MODER,      (GPIOB_BASE + (0x00)) // GPIOB MODER offset
.equ GPIOB_ODR,        (GPIOB_BASE + (0x14)) // GPIOB ODR offset
.equ GPIOB_IDR,        (GPIOB_BASE + (0x10)) // GPIOB IDR offset

/* vector table, +1 thumb mode *f/
.section .vectors
vector_table:
	.word _estack             /*     Stack pointer */
	.word Reset_Handler +1    /*     Reset handler */
	.word Default_Handler +1  /*       NMI handler */
	.word Default_Handler +1  /* HardFault handler */
	/* add rest of them here if needed */


/* reset handler */
.section .text
Reset_Handler:
	/* set stack pointer */
	ldr r0, =_estack
	mov sp, r0

	/* initialize data and bss
	 * not necessary for rom only code
	 * */
	bl init_data
	/* call main */
	bl main
	/* trap if returned */
	b .


/* initialize data and bss sections */
.section .text
init_data:

	/* copy rom to ram */
	ldr r0, =_sdata
	ldr r1, =_edata
	ldr r2, =_sidata
	movs r3, #0
	b LoopCopyDataInit

	CopyDataInit:
		ldr r4, [r2, r3]
		str r4, [r0, r3]
		adds r3, r3, #4

	LoopCopyDataInit:
		adds r4, r0, r3
		cmp r4, r1
		bcc CopyDataInit

	/* zero bss */
	ldr r2, =_sbss
	ldr r4, =_ebss
	movs r3, #0
	b LoopFillZerobss

	FillZerobss:
		str  r3, [r2]
		adds r2, r2, #4

	LoopFillZerobss:
		cmp r2, r4
		bcc FillZerobss

	bx lr


/* default handler */
.section .text
Default_Handler:
	b Default_Handler


/* main function */
.section .text
main:
	/* enable GPIOA and GPIOB clock, bit1 on IOPENR */
	ldr r6, =RCC_IOPENR
	ldr r5, [r6]
	/* movs expects imm8, so this should be fine */
	movs r4, 0x3
	orrs r5, r5, r4
	str r5, [r6]

	/* setup PA8-7-6-5 for D1-2-3-4 for bits 17-10 PA4 for button for bits 9-8 and PA0 for LED for bits 1-0 in MODER */
	ldr r6, =GPIOA_MODER
	ldr r5, [r6]
	/* cannot do with movs, so use pc relative */
	ldr r4, =0x3FF03 /* 0011_1111_1111_0000_0011 */
	mvns r4, r4
	ands r5, r5, r4
	ldr r4, =0x15501 /* 00(01)_(01)(01)_(01)(01)_0000_00(01) */
	orrs r5, r5, r4
	str r5, [r6]

	/* setup PB0-6 for A-G for bits 13-0 in MODER*/
	ldr r6, =GPIOB_MODER
	ldr r5, [r6]
	ldr r4, =0xC000 /* 1100_0000_0000_0000 */
	ands r5, r5, r4
	ldr r4, =0x1555 /* 00(01)_(01)(01)_(01)(01)_(01)(01) */
	orrs r5, r5, r4
	str r5, [r6]

bcontrol:
	ldr r6, =GPIOA_IDR /* input data */
	ldr r5, [r6]
	lsrs r5, r5, #4
	movs r4, 0x1
	ands r5, r5, r4

	cmp r5, #0x1
	beq button1
	bne initialDisplay

/* to write digit by digit we need to turn on and of digits with a delay which can not be recognized */
initialDisplay:
	/* write on D1 */
	bl turnonD1
	bl four
	bl delay8000
	bl resetstr /* clear data on mem[r6] */
	bl turnoffD /* turns off all digits */

	/* write on D2 */
	bl turnonD2
	bl zero
	bl delay8000
	bl resetstr
	bl turnoffD

	/* write on D3 */
	bl turnonD3
	bl one
	bl delay8000
	bl resetstr
	bl turnoffD

	/* write on D4 */
	bl turnonD4
	bl one
	bl delay8000
	bl resetstr
	bl turnoffD

	b bcontrol

button1:
	bl turnonALL
	b countdown

countdown:
	bl nine
	bl delay1sec
	bl resetstr

	bl eight
	bl delay1sec
	bl resetstr

	bl seven
	bl delay1sec
	bl resetstr

	bl six
	bl delay1sec
	bl resetstr

	bl five
	bl delay1sec
	bl resetstr

	bl four
	bl delay1sec
	bl resetstr

	bl three
	bl delay1sec
	bl resetstr

	bl two
	bl delay1sec
	bl resetstr

	bl one
	bl delay1sec
	bl resetstr

	bl turnonLED

	bl zero
	bl delay1sec
	bl resetstr

	bl turnoffD
	bl delay1sec

	movs r1, #2 /* r1+1 toggle */
	b toggleZero

toggleZero:
	bl turnonALL
	bl turnonLED
	bl zero
	bl delay1sec
	bl resetstr
	bl turnoffD
	bl delay1sec

	subs r1, r1, #1
	bne toggleZero
	b bcontrol

zero:
	/* 1: (b c) 100_0000*/
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x40 /* 0100_0000 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

one:
	/* 1: (b c) 111_1001*/
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x06 /* 0000_0110 */
	mvns r4, r4
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

two:
	/* 2: (a b d e g) 010_0100  */
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x24 /* 0010_0100 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

three:
	/* 3: (a b c d g) 011_0000 */
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x30 /* 0011_0000 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

four:
	/* 4: (b c f g) 001_1001 */
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x19 /* 0001_1001 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

five:
	/* 5: (a c d f g) 001_0010 */
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x12 /* 0001_0010 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

six:
	/* 6: (a c d e f g) 000_0010*/
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x02 /* 0000_0010 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

seven:
	/* 7: (a b c) 111_1000*/
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x07 /* 0000_0111 */
	mvns r4, r4
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

eight:
	/* 8: (a b c d e f g) 000_0000 */
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x0 /* 0000_0000 */
	ands r5, r5, r4
	str r5, [r6]
	bx lr

nine:
	/* 9: (a b c d f g) 001_0000 */
	ldr r6, =GPIOB_ODR
	ldr r5, [r6]
	movs r4, 0x10 /* 0001_0000 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

delay:
	subs r0, r0, #1
	bne delay
	bx lr

delay8000: /* turns 8000 times */
	push {lr}
	ldr r0, =#8000
	bl delay
	pop {pc}
	bx lr

delay1sec: /* delay for one second */
	push {lr}
	ldr r0, =#3030303
	bl delay
	pop {pc}
	bx lr

resetstr: /* clears old data */
	movs r5, 0x0
	str r5, [r6]
	bx lr

turnonD1:
	/* turn on D1 connected to A8 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x100 /* 0001_0000_0000 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

turnonD2:
	/* turn on D2 connected to A7 in ODR */
	str r5, [r6]
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x80 /* 0000_1000_0000 = lsrs r4, r4, #1 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

turnonD3:
	/* turn on D3 connected to A6 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x40 /* 0000_0100_0000 = lsrs r4, r4, #1 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

turnonD4:
	/* turn on D4 connected to A5 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x20 /* 0000_0010_0000 = lsrs r4, r4, #1 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

turnonALL:
	push {lr}
	bl turnonD1
	bl turnonD2
	bl turnonD3
	bl turnonD4
	bl turnoffLED
	pop {pc}
	bx lr

turnoffD: /* turn off digits and LED */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x0
	ands r5, r5, r4
	str r5, [r6]
	bx lr

turnonLED:
	/* turn on led connected to A0 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	movs r4, 0x1 /* 0001 */
	orrs r5, r5, r4
	str r5, [r6]
	bx lr

turnoffLED:
	/* turn off led connected to A0 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	movs r4, 0x1 /* 0001 */
	mvns r4, r4
	ands r5, r5, r4
	str r5, [r6]
	bx lr


	/* for(;;); */
	b .

	/* this should never get executed */
	nop
