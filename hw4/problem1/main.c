/*
 *
 * Yagmur Derya
 *
 *
 */

#include "stm32g0xx.h"
#include "bsp.h"

int main(void) {

	BSP_init_led();
	BSP_init_button();

    while(1){
    	if (BSP_read_button()){ // if button is pressed
    		BSP_set_led();
    	} else { // button is not pressed
    		BSP_clear_led();
    	}
    }
    return 0;
}
