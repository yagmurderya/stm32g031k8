/*
 * bsp.c
 *
 *      Author: Yagmur Derya
 */

#include "bsp.h"
#include "stm32g0xx.h"

void BSP_init_led(void){

	/* Enable GPIOC clock */
	RCC->IOPENR |= (1U << 2); // 100

	/* Setup PC6 as output */
	GPIOC->MODER &= ~(3U << 2*6); // clear bits ~(11) = 00
	GPIOC->MODER |= (1U << 2*6); // set PC6 as output : 01

	/* clear LED */
	GPIOC->BRR |= (1U << 6);
}

void BSP_set_led(void){

	/* turn on */
	GPIOC->ODR |= (1U << 6);
}

void BSP_clear_led(void){

	/* turn off */
	GPIOC->BRR |= (1U << 6);
}

void BSP_toggle_led(void){

	/* toggle */
	GPIOC->ODR ^= (1U << 6);
}

void BSP_init_button(void){

	/* Enable GPIOB clock */
	RCC->IOPENR |= (1U << 1); // 10

	/* Setup PB3 as input */
	GPIOB->MODER &= ~(3U << 2*3);
}

// returns 1 if button is pressed
int BSP_read_button(void){

	int b = ((GPIOB->IDR >> 3) & 0x1);

	return (b) ? 1 : 0;
}
