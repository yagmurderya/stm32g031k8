/*
 *
 * Yağmur Derya
 *
 *
 */

#include "stm32g0xx.h"

#define LEDDELAY    1600000

int main(void);
void delay(volatile uint32_t);

void EXTI2_3_IRQHandler(void){
    GPIOB->ODR &= ~(1U << 6); // turn off LED on PB6
    for(volatile long long int a = 0; a < 5000000; ++a);
    GPIOB->ODR |= (1U << 6);
    EXTI->RPR1 |= (1U << 3); // clear pending
}

void EXTI0_1_IRQHandler(void){
	 GPIOB->ODR &= ~(1U << 4); // turn off LED on PB4
	 for(volatile long long int a = 0; a < 5000000; ++a);
	 GPIOB->ODR |= (1U << 4);
	 EXTI->RPR1 |= (1U << 1); // clear pending
}
int main(void) {

    /* Enable GPIOB clock */
    RCC->IOPENR |= (1U << 1);

    /* Setup PB6 as output */
    GPIOB->MODER &= ~(3U << 2*6);
    GPIOB->MODER |= (1U << 2*6);

    /* Setup PB4 as output */
    GPIOB->MODER &= ~(3U << 2*4);
    GPIOB->MODER |= (1U << 2*4);

    /* Setup PB3 as input */
    GPIOB->MODER &= ~(3U << 2*3);

    EXTI->RTSR1 |= (1U << 3); // rising trigger selection register
    EXTI->EXTICR[0] |= (1U << 8*3); // external interrupt selection register
    EXTI->IMR1 |= (1U << 3); // wake up with interrupt mask register

    NVIC_SetPriority(EXTI2_3_IRQn, 0); // higher priority
    NVIC_EnableIRQ(EXTI2_3_IRQn);

    /* Setup PB1 as input */
    GPIOB->MODER &= ~(3U << 2*1);

    EXTI->RTSR1 |= (1U << 1); // rising trigger selection register
    EXTI->EXTICR[0] |= (1U << 8*1); // external interrupt selection register
    EXTI->IMR1 |= (1U << 1); // wake up with interrupt mask register

    NVIC_SetPriority(EXTI0_1_IRQn, 1); // lower priority
    NVIC_EnableIRQ(EXTI0_1_IRQn);

    while(1) {
        /* Turn on LED on PB6 */
        GPIOB->ODR |= (1U << 6);
        /* Turn on LED on PB4 */
        GPIOB->ODR |= (1U << 4);
    }
    return 0;
}

void delay(volatile uint32_t s) {
    for(; s>0; s--);
}
