/*
 * project2.h
 *
 *  Yagmur Derya
 *  171024011
 *
 */

#ifndef PROJECT2_H_
#define PROJECT2_H_

/* defines for SSD */
#define D1      6  // PB
#define D2      7  // PB
#define D3      3  // PB
#define D4      1  // PB
#define A       7  // PA
#define B       11 // PA
#define c       4  // PA
#define D       5  // PA
#define E       12 // PA
#define F       6  // PA
#define G       0  // PA
#define decimal 1  // PA

/* defines for Keypad */
#define R1      4  // PB
#define R2      5  // PB
#define R3      9  // PB
#define R4      8  // PA
#define C1      8  // PB
#define C2      2  // PB
#define C3      0  // PB
#define C4      9  // PA

#include "stm32g0xx.h"

void init_system(void);

void EXTI0_1_IRQHandler(void);
void EXTI2_3_IRQHandler(void);
void EXTI4_15_IRQHandler(void);

void TIM1_BRK_UP_TRG_COM_IRQHandler(void);
void init_timer1(void);

void delay(void);

void clear_array(char*);

/* setup for both SSD and Keypad */
void init_pins(void);

/* for SSD */
void set_SSD(int);
void clear_SSD(void);
void set_digit(int);
void clear_digit(int);
void clear_all_digits(void);
void toggle_digit(int);

int  digit_num(int);
void overflow(void);
void invalid(void);
void display_negative(int, int);
void display_positive(int, int);
void display(double);

/* for Keypad - PB4 PB5 PB9 PA8 PB8 PB2 PB0 PA9 */
void set_rows(void);
void clear_rows(void);

#endif /* PROJECT2_H_ */
