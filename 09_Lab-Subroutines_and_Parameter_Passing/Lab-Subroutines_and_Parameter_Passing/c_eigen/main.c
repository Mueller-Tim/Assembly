#include <stdint.h>

extern void out_word(uint32_t out_address, uint32_t out_value);
extern uint32_t in_word(uint32_t in_address);

#define ADD_LED 0x60000100
#define ADD_SWITCH 0x60000200

int main(void){
	while(1){
		uint32_t dip_switch_value = in_word(ADD_SWITCH);
		out_word(ADD_LED, dip_switch_value);
	}
}
