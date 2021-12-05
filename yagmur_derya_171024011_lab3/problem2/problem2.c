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

    GPIOC->ODR ^= (1U << 6); // toggle
    EXTI->RPR1 |= (1U << 3); // clear pending
}

int main(void) {

    /* Enable GPIOC clock */
    RCC->IOPENR |= (1U << 2);
    /* Enable GPIOB clock */
    RCC->IOPENR |= (1U << 1);


    /* Setup PC6 as output */
    GPIOC->MODER &= ~(3U << 2*6);
    GPIOC->MODER |= (1U << 2*6);

    /* Turn on LED */
    GPIOC->ODR |= (1U << 6);



    /* Set PB3 as input */
    GPIOB->MODER &= ~(3U << 2*3);

    EXTI->RTSR1 |= (1U << 3); // rising trigger selection register
    EXTI->EXTICR[0] |= (1U << 8*3); // external interrupt selection register
    EXTI->IMR1 |= (1U << 3); // wake up with interrupt mask register

    NVIC_SetPriority(EXTI2_3_IRQn, 0);
    NVIC_EnableIRQ(EXTI2_3_IRQn);

    while(1) {
    }
    return 0;
}

void delay(volatile uint32_t s) {
    for(; s>0; s--);
}
