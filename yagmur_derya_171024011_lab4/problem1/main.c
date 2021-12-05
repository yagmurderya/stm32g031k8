/*
 *
 * Yağmur Derya
 *
 *
 */

#include "stm32g0xx.h"

void SysTick_Handler(void);
void delay_ms(uint32_t);

volatile uint32_t TimeDelay; // global volatile variable

int main(void) {

	/* Enable GPIOC clock */
	RCC->IOPENR |= (1U << 2); // 100

	/* Setup PC6 as output */
	GPIOC->MODER &= ~(3U << 2*6); // clear bits ~(11) = 00
	GPIOC->MODER |= (1U << 2*6); // set PC6 as output : 01

	GPIOC->ODR |= (1U << 6); // turn on the LED on PC6

	SystemCoreClockUpdate(); // to update processor clock speed
	SysTick_Config(SystemCoreClock/1000); // 1 ms interrupt interval = 16MHz/1ms = 16 000 = SystemCoreClock/1000

    while(1){

    	delay_ms(500);
    	GPIOC->ODR ^= (1U << 6); // toggle the LED on PC6
    }
    return 0;
}

/* SysTick Handler */
void SysTick_Handler(void){
	if(TimeDelay !=0)
		TimeDelay --; // decrease TimeDelay until it equals to 0
}

/* function to wait for given number of milliseconds */
void delay_ms(uint32_t time){
	TimeDelay = time;
	while(TimeDelay != 0); // waits until TimeDelay = 0 by Systick_Handler
}
