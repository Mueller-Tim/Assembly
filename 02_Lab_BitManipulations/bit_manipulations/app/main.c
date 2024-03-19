/* -----------------------------------------------------------------
 * --  _____       ______  _____                                    -
 * -- |_   _|     |  ____|/ ____|                                   -
 * --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
 * --   | | | '_ \|  __|  \___ \   Zurich University of             -
 * --  _| |_| | | | |____ ____) |  Applied Sciences                 -
 * -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
 * ------------------------------------------------------------------
 * --
 * -- main.c
 * --
 * -- main for Computer Engineering "Bit Manipulations"
 * --
 * -- $Id: main.c 744 2014-09-24 07:48:46Z ruan $
 * ------------------------------------------------------------------
 */
//#include <reg_ctboard.h>
#include "utils_ctboard.h"

#define ADDR_DIP_SWITCH_31_0 0x60000200
#define ADDR_DIP_SWITCH_7_0  0x60000200
#define ADDR_LED_31_24       0x60000103
#define ADDR_LED_23_16       0x60000102
#define ADDR_LED_15_8        0x60000101
#define ADDR_LED_7_0         0x60000100
#define ADDR_BUTTONS         0x60000210

// define your own macros for bitmasks below (#define)
/// STUDENTS: To be programmed

#define bright 0xC0 // 11000000
#define dark 0xCF //11001111




/// END: To be programmed

int main(void)
{
    uint8_t led_value = 0;
		

    // add variables below
    /// STUDENTS: To be programmed
	
		uint8_t button_State = 0x00;
		uint8_t new_Button_State = 0x00;
		uint8_t counter = 0;
		uint8_t push = 0;
		uint8_t button_Variable = 0; 
		uint8_t rising = 0;
	
		


    /// END: To be programmed

    while (1) {
        // ---------- Task 3.1 ----------
        led_value = read_byte(ADDR_DIP_SWITCH_7_0);

        /// STUDENTS: To be programmed

				button_State = read_byte(ADDR_BUTTONS);
				button_State &= 0x0F;
			
				led_value &= dark;
			
				led_value |= bright;
			
			
			

        /// END: To be programmed

        write_byte(ADDR_LED_7_0, led_value);

        // ---------- Task 3.2 and 3.3 ----------
        /// STUDENTS: To be programmed

			
			
				write_byte(ADDR_LED_15_8, counter);
				
				rising = ~button_State & new_Button_State;
				
				if(button_State & 0x01){
					counter++;
				}
				new_Button_State = button_State;
				
				write_byte(ADDR_LED_31_24, push);
				
				if(rising & 0x08){
					button_Variable = read_byte(ADDR_DIP_SWITCH_7_0);			
				}else if(rising & 0x04){
					button_Variable = ~button_Variable;
				}else if(rising & 0x02){
					button_Variable <<= 1;
				} else if(rising & 0x01){
					button_Variable >>= 1;
					push++;
				}
				
				write_byte(ADDR_LED_23_16, button_Variable);

        /// END: To be programmed
    }
}
