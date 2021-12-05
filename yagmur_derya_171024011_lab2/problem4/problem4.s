/*
 * ELEC335 Lab02
 * problem4.s
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
	/* enable GPIOA clock, bit1 on IOPENR */
	ldr r6, =RCC_IOPENR
	ldr r5, [r6]
	/* movs expects imm8, so this should be fine */
	movs r4, 0x1
	orrs r5, r5, r4
	str r5, [r6]

	/* setup PA15-11-10-8-7-6-1 */
	ldr r6, =GPIOA_MODER
	ldr r5, [r6]
	/* cannot do with movs, so use pc relative */
	ldr r4, =0xC0F3F00C /* 1100_0000_1111_0011_1111_0000_0000_1100 */
	mvns r4, r4
	ands r5, r5, r4
	ldr r4, =0x40515004 /* xx00_0000_xxxx_00xx_xxxx_0000_0000_xx00 */
	orrs r5, r5, r4
	str r5, [r6]
	/* setup PA4 for push button for bits 9-8 in MODER*/
	ldr r6, =GPIOA_MODER
	ldr r5, [r6]
	ldr r4, =0x300
	mvns r4, r4
	ands r5, r5, r4
	ldr r4, =0x100
	orrs r5, r5, r4
	str r5, [r6]

button:
	ldr r6, =GPIOA_IDR
	ldr r5, [r6]
	lsrs r5, r5, #4
	movs r4, #0x1
	ands r5, r5, r4

	cmp r5, #0x1
	beq toggleR
	bne toggleL

toggleL:
	/* turn on leds connected to A11-7-6 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x8C0 /* x000_xx00_0000 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A15-11-6 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x8840 /* x000_x000_0x00_0000 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A15-11-1 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x8802 /* x000_x000_0000_00x0 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A15-10-1 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x8402 /* x000_0x00_0000_00x0 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A10-8-1 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x502 /* 0x0x_0000_00x0 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A10-8-7 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x580 /* 0x0x_x000_0000 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A8-7-6- in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x1C0 /* 000x_xx00_0000 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	b button


toggleR:
	/* turn on leds connected to A8-7-6- in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x1C0 /* 000x_xx00_0000 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A10-8-7 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x580 /* 0x0x_x000_0000 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A10-8-1 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x502 /* 0x0x_0000_00x0 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A15-10-1 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x8402 /* x000_0x00_0000_00x0 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A15-11-1 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x8802 /* x000_x000_0000_00x0 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A15-11-6 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x8840 /* x000_x000_0x00_0000 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off

	/* turn on leds connected to A11-7-6 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	ldr r4, =0x8C0 /* x000_xx00_0000 */
	orrs r5, r5, r4
	str r5, [r6]

	ldr r0, =#303030 /* counter for delay */
	bl delay

	bl off
	b button

off:
	/* turn off leds connected to A15-11-10-8-7-6-1 in ODR */
	ldr r6, = GPIOA_ODR
	ldr r5, [r6]
	movs r4, #0x0
	ands r5, r5, r4
	str r5, [r6]
	bx lr

delay:
	subs r0, r0, #1
	bne delay
	bx lr

	/* for(;;); */
	b .

	/* this should never get executed */
	nop
