/*
 *
 * Yağmur Derya
 *
 *
 */

#include "stm32g0xx.h"
#include <stdio.h>
#include <stdlib.h>

#define LEDDELAY    1600000

void delay(volatile uint32_t);

extern unsigned long_estack;

/* HardFault Handler */
void HardFault_Handler(void){
	GPIOC -> ODR &= (0U << 6); // turn of the LED
	__asm("ldr r0, =_estack");
	__asm("movs sp, r0");
	NVIC_SystemReset();
	__asm("b Reset_Handler");
}

/* Reset Handler */
void Reset_Handler(void){
	main();
	for(;;);
}

int main(void) {

    /* Enable GPIOC clock */
    RCC->IOPENR |= (1U << 2);
    /* Enable GPIOB clock */
    RCC->IOPENR |= (1U << 1);
    /* to enable GPIOA clock : (1U << 0) */

    /* Setup PC6 as output */
    GPIOC->MODER &= ~(3U << 2*6); // clear bits ~(11) = 00
    GPIOC->MODER |= (1U << 2*6); // set PC6 as output : 01


    /* Setup PB3 as input */
    GPIOB->MODER &= ~(3U << 2*3); // to set PB3 as input : 00

    int fault = 1;

    while(1) {
    	if(fault == 0){
			if((GPIOB->IDR >> 3) & 1){ // button active
				__asm("ldr r6, =0xFFFFFFE8"); // invalid address bus error
				__asm("ldr r5, [r6]");
			} else {
				/* turn on LED on PC6 */
				GPIOC->ODR |= (1U << 6);
			}
    	} else if (fault == 1){
    		if((GPIOB->IDR >> 3) & 1){
    			__asm("ldr r6, =0x80000101"); // unaligned memory
    			__asm("ldr r5, [r6]"); // read word
    		} else {
    			GPIOC->ODR |= (1U << 6);
    		}
    	} else {
    		if((GPIOB->IDR >> 3) & 1){
    			__asm("ldr r6, =0x81000100");
    			__asm("ldr r5, [r6]");
    		} else {
    			GPIOC->ODR |= (1U << 6);
    		}
    	}
    }

    return 0;
}

void delay(volatile uint32_t s) {
    for(; s>0; s--);
}
