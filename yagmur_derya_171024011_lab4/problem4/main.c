/*
 *
 * Yagmur Derya
 *
 *
 */

#include "stm32g0xx.h"

#define LEDDELAY    1600000

void delay(volatile uint32_t);

void init_IWDG(void){
	IWDG->KR = 0xCCCC; // enable IWDG
	IWDG->KR = 0x5555; // enable configuring peripheral
	IWDG->PR = 0x06; // 256
	IWDG->RLR = 0xFFFF;

}

int main(void) {

    /* Enable GPIOC clock */
    RCC->IOPENR |= (1U << 2);

    /* Setup PC6 as output */
    GPIOC->MODER &= ~(3U << 2*6);
    GPIOC->MODER |= (1U << 2*6);

    init_IWDG();

    while(1) {
        /* Toggle LED */
        GPIOC->ODR ^= (1U << 6);
        IWDG->KR = 0xAAAA;
    }

    return 0;
}

void delay(volatile uint32_t s) {
    for(; s>0; s--);
}
