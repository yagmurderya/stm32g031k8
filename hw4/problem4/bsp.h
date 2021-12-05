/*
 * bsp.h
 *
 *      Author: Yagmur Derya
 */

#ifndef BSP_H_
#define BSP_H_

/* for on-board LED on PC6 */
void BSP_init_led(void);
void BSP_set_led(void);
void BSP_clear_led(void);
void BSP_toggle_led(void);

/* for button on PB3 */
void BSP_init_button(void);
int BSP_read_button(void);

#endif /* BSP_H_ */
