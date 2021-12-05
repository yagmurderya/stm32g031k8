/*
 *
 * Yagmur Derya
 *
 *
 */

#include "stm32g0xx.h"
volatile uint32_t bcount ;

int main(void);
void TIM1_BRK_UP_TRG_COM_IRQHandler(void);
void EXTI2_3_IRQHandler(void);
void init_timer1(void);
void init_button(void);

int main(void) {

	/* Enable GPIOB and GPIOC clock */
	RCC->IOPENR |= (3U << 1); // 110

	/* Setup PC6 as output */
	GPIOC->MODER &= ~(3U << 2*6); // clear bits ~(11) = 00
	GPIOC->MODER |= (1U << 2*6); // set PC6 as output : 01

	/* Setup PB3 as input */
    GPIOB->MODER &= ~(3U << 2*3);
    bcount = 0;

    init_button();
    init_timer1();

    while(1){
    }

    return 0;
}
void TIM1_BRK_UP_TRG_COM_IRQHandler(void){

	GPIOC->ODR ^= (1U << 6); // toggle the LED on PC6
	TIM1->SR &= ~(1U << 0); // clear update status register
}

void EXTI2_3_IRQHandler(void){

	bcount ++;

	if(bcount > 0 && bcount < 11) {
		TIM1->ARR = (16000 / (bcount + 1)); // to speed up the toggle
		//TIM->ARR = (16000 * (bcount + 1)); // to slow down the toggle
	} else{
		bcount = 0;
		TIM1->ARR = 16000;
	}

	EXTI->RPR1 |= (1U << 3); // clear pending
}

void init_timer1(void){

	RCC->APBENR2 |= (1U << 11); // TIM1  clock enable

	TIM1->CR1 = 0; // control register reset
	TIM1->CR1 |= (1 << 7); // ARPE
	TIM1->CNT = 0; // zero out counter

	/* to 1 second interrupt interval */
	TIM1->PSC = 999;
	TIM1->ARR = 16000;

	TIM1->DIER |= (1 << 0); // update interrupt enable
	TIM1->CR1 |= (1 << 0); // TIM1 enable

	NVIC_SetPriority(TIM1_BRK_UP_TRG_COM_IRQn, 0xC0); // lowest priority
	NVIC_EnableIRQ(TIM1_BRK_UP_TRG_COM_IRQn);
}

void init_button(void){

	EXTI->RTSR1 |= (1U <<3 );
	EXTI->EXTICR[0] |= (1U << 8*3);
	EXTI->IMR1 |= (1U << 3);

	NVIC_SetPriority(EXTI2_3_IRQn, 0); // highest priority
	NVIC_EnableIRQ(EXTI2_3_IRQn);
}
