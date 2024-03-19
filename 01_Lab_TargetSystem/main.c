#include "utils_ctboard.h"
#include <stdio.h>
#define LED_S7_S0 0x60000200
#define LED_S15_S8 0x60000201
#define LED_S23_S16 0x60000202
#define LED_S31_S24 0x60000203

#define LED_L7_L0 0x60000100
#define LED_L15_L8 0x60000101
#define LED_L23_L16 0x60000102
#define LED_L31_L24 0x60000103

#define Rotary_P11 0x60000211
#define Rotary_DS0 0x60000110


static const uint8_t number[16] = {
	// 0x0F => 0000'1111

	0xC0, // 1100'0000 => 0000'0011 => 1111'1100
	0xF9, // 1111'1001 => 1001'1111 => 0110'0000
	0xA4, // 1010'0100 => 0010'0101 => 1101'1010
	0xB0, // 1111'0010 <= 0000'1101 <= 1011'0000
	0x99, // 0110'0110 <= 1001'1001 <= 1001'1001
	0x92, // 1011'0110 <= 0100'1001 <= 1001'0010
	0x83, // 0011'1110 <= 1100'0001 <= 1000'0011
	0xB8, // 1110'0010 <= 0001'1101 <= 1011'1000
	0x80, // 1111'1110 <= 0000'0001 <= 1000'0000
	0x98, // 1110'0110 <= 0001'1001 <= 1001'1000
	0x88, // 1110'1110 <= 0001'0001 <= 1000'1000
	0x83, // 0011'1110 <= 1100'0001 <= 1000'0011
	0xC6, // 1001'1100 <= 0110'0011 <= 1100'0110
	0xA1, // 0111'1010 <= 1000'0101 <= 1010'0001
	0x86, // 1001'1110 <= 0110'0001 <= 1000'0110
	0x8E // 1000'1110 <= 0111'0001 <= 1000'1110
};


int main(void){
	
	/* initializations go here */
	
	//uint8_t readValue;
	
	while(1){
		
		/* this is the application */
		
		
		//readValue = read_byte(LED_Switch);
		//write_byte(LED_Adress, readValue);
		
		/* 4.1, 4.2, 5.1 */
		write_byte(LED_L7_L0, read_byte(LED_S7_S0));
		write_byte(LED_L15_L8, read_byte(LED_S15_S8));
		write_byte(LED_L23_L16, read_byte(LED_S23_S16));
		write_byte(LED_L31_L24, read_byte(LED_S31_S24));
		
		write_byte(Rotary_DS0, number[read_byte(Rotary_P11) & 0x0F]);
		
		//write_byte(Rotary_DS0, number[Rotary_P11]);
	}
	
}