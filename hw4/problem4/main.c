/*
 *
 * Yagmur Derya
 *
 *
 */

#include "stm32g0xx.h"
#include "bsp.h"

int main(void);
void SysTick_Handler(void);
void delay_ms(uint32_t);
void StateMode(int);
void EXTI2_3_IRQHandler(void);

int count = 0;
int mode = 0;
volatile uint32_t TimeDelay;

int main(void) {

	SystemCoreClockUpdate(); // to update processor clock speed
	SysTick_Config(SystemCoreClock/1000); // 1 ms interrupt interval =16MHz/1ms = 16 000 = SystemCoreClock/1000

	BSP_init_led();
	BSP_init_button();

    while(1){
    	mode = count;
    	StateMode(mode % 5);
    }
    return 0;
}

void SysTick_Handler(void){
	if (TimeDelay != 0)
		TimeDelay --;
}

void delay_ms(uint32_t time){
	TimeDelay = time;
	while(TimeDelay != 0);
}

void StateMode(int mode){
	if(mode == 0){	//LED is OFF
		BSP_clear_led();
	} else if(mode == 1){ // LED is toggling at 1 second intervals
		delay_ms(1000);
		BSP_toggle_led();
	} else if(mode == 2){ // LED is toggling at 0.5 second intervals
		delay_ms(500);
		BSP_toggle_led();
	} else if(mode == 3){ // LED is toggling at 0.1 second intervals
		delay_ms(100);
		BSP_toggle_led();
	} else if(mode == 4){ // LED is ON
		BSP_set_led();
	}
}

void EXTI2_3_IRQHandler(void){
	count ++;
	EXTI->RPR1 |= (1U << 3); // clear pending
}
