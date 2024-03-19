; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- main.s
; --
; -- CT1 P08 "Strukturierte Codierung" mit Assembler
; --
; -- $Id: struct_code.s 3787 2016-11-17 09:41:48Z kesr $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address-Defines
; ------------------------------------------------------------------
; input
ADDR_DIP_SWITCH_7_0       EQU        0x60000200
ADDR_BUTTONS              EQU        0x60000210

; output
ADDR_LED_31_0             EQU        0x60000100
ADDR_7_SEG_BIN_DS3_0      EQU        0x60000114
ADDR_LCD_COLOUR           EQU        0x60000340
ADDR_LCD_ASCII            EQU        0x60000300
ADDR_LCD_ASCII_BIT_POS    EQU        0x60000302
ADDR_LCD_ASCII_2ND_LINE   EQU        0x600003140'


; ------------------------------------------------------------------
; -- Program-Defines
; ------------------------------------------------------------------
; value for clearing lcd
ASCII_DIGIT_CLEAR        EQU         0x00000000
LCD_LAST_OFFSET          EQU         0x00000028

; offset for showing the digit in the lcd
ASCII_DIGIT_OFFSET        EQU        0x00000030

; lcd background colors to be written
DISPLAY_COLOUR_RED        EQU        0
DISPLAY_COLOUR_GREEN      EQU        2
DISPLAY_COLOUR_BLUE       EQU        4

; ------------------------------------------------------------------
; -- myConstants
; ------------------------------------------------------------------
        AREA myConstants, DATA, READONLY
; display defines for hex / dec
DISPLAY_BIT               DCB        "Bit "
DISPLAY_2_BIT             DCB        "2"
DISPLAY_4_BIT             DCB        "4"
DISPLAY_8_BIT             DCB        "8"
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY
        ENTRY

        ; imports for calls
        import adc_init
        import adc_get_value

main    PROC
        export main
        ; 8 bit resolution, cont. sampling
        BL         adc_init 
        BL         clear_lcd

main_loop
; STUDENTS: To be programmed
		; R0 ADC-value
		; R1 Button T0
		; R2 dip_switch_7_0
		; R3 differenz
		; R7 temp
		
		; save adc value into R0
		BL		adc_get_value
		
		
		LDR R7,=ADDR_BUTTONS
		LDR R1,[R7]
		LDR R7,=0x01
		
		; Test if button is pressed
		TST R1,R7
		BNE		button_t0_pressed
		
		B	button_to_not_pressed

button_to_not_pressed
		; R3 differenz
		
		LDR R2,=ADDR_DIP_SWITCH_7_0
		LDRB R2,[R2]
		SUBS R3,R2,R0
		MOVS R0,R3
		
		BL		write_7seg
		
		CMP R0,#0
		
		BMI		case_red
		
		b		case_blue
		
		
		
		
button_t0_pressed	
		
		b	case_green

case_green

		; R0 ADC_Value
		; R2 backGroundColor LCD
		; R3 counter
		; R6 colorpart shift
		; R7 temp		
		LDR R2,=ADDR_LCD_COLOUR
		LDR R7, =0xffff 
		LDR R6,=DISPLAY_COLOUR_GREEN
		STRH R7,[R2, R6]
		LDR R7, =0x0000
		LDR R6,=DISPLAY_COLOUR_BLUE
		STRH R7,[R2, R6]
		LDR R6,=DISPLAY_COLOUR_RED
		STRH R7,[R2, R6]



		BL		write_7seg
		
		LDR R3,=1
		CMP R0,#7
		BHI		case_green_while
		
		B		case_green_while_end

case_green_while
		; R0 ADC_Value
		; R3 counter
		; R7 temp
		LSLS R3,#1
		ADDS R3,R3,#1
		
		SUBS R0,R0,#8
		
		CMP R0,#7
		BLS		case_green_while_end
		B		case_green_while
		
case_green_while_end
		; R3 counter
		; R7 temp
		; R5 zero
		LDR R7,=ADDR_LED_31_0
		STR R3,[R7]

		BL		delete_LCD_number_1nd
		
		BL		delete_LCD_number_2nd

		b		student_end
		
delete_LED_31_0
		
		LDR R5,=0x00
		LDR R7,=ADDR_LED_31_0
		STR R5,[R7]
		
		
		BX LR
		
		
delete_LCD_number_1nd		
		LDR R5,=0x00
		LDR R7, =ADDR_LCD_ASCII
		STRB R5, [R7]
		LDR R7,=ADDR_LCD_ASCII_BIT_POS
		STR R5, [R7]
		
		BX LR		
		 
		
delete_LCD_number_2nd		
		LDR R5,=0x00
		LDR R7, =ADDR_LCD_ASCII_2ND_LINE 
		STR R5, [R7]
		
		BX LR
		
case_red
		; R2 backGroundColor LCD
		; R3 differenz
		; R4 counter to one byte
		; R5
		; R6 colorpart shift
		; R7 temp		
		LDR R2,=ADDR_LCD_COLOUR
		LDR R7, =0xffff 
		LDR R6,=DISPLAY_COLOUR_RED
		STRH R7,[R2, R6]
		LDR R7, =0x0000
		LDR R6,=DISPLAY_COLOUR_BLUE
		STRH R7,[R2, R6]
		LDR R6,=DISPLAY_COLOUR_GREEN
		STRH R7,[R2, R6]
		BL		write_7seg
		
		LDR 	R4,=0
		LDR		R5,=0
		MOVS	R3, R0
		
		; R6 ist 1
		LDR		R6,=0x01
		
		B		case_red_loop

case_red_loop
		; R1
		; R3 differenz
		; R4 counter to one byte
		; R5
		; R6 ist 1

		CMP R4, #8
		BEQ		case_red_loop_end
		ADDS R4, R4, #1		; increment for loop
	
		MOVS R1, R3
		LSRS R3, R3, #1
	
		TST	R1, R6
		BHI		case_red_loop
	
		ADDS R5, R5, #1

		B		case_red_loop
		

case_red_loop_end
		
		LDR	R1,=ASCII_DIGIT_OFFSET
	
		ADDS R5, R5, R1
	
		LDR R0, =ADDR_LCD_ASCII_2ND_LINE 
		STR R5, [R0]
		
		BL		delete_LED_31_0
		
		BL		delete_LCD_number_1nd
		
		B		student_end

case_blue

		; R2 backGroundColor LCD
		; R3 differenz
		; R6 colorpart shift
		; R7 temp		
		LDR R2,=ADDR_LCD_COLOUR
		LDR R7, =0xffff 
		LDR R6,=DISPLAY_COLOUR_BLUE
		STRH R7,[R2, R6]
		LDR R7, =0x0000
		LDR R6,=DISPLAY_COLOUR_GREEN
		STRH R7,[R2, R6]
		LDR R6,=DISPLAY_COLOUR_RED
		STRH R7,[R2, R6] 
		BL		write_7seg
		

		LDR R4,=0xFF
		ANDS R3, R3, R4
	
		BL 		write_bit_ascii				; bit auf LCD anzeigen
		CMP R3, #0x04
		BLT	case_color_blue_2_bit
	
		CMP R3, #0x10
		BLT		case_color_blue_4_bit
	
		B 		case_color_blue_8_bit
	
case_color_blue_2_bit
		LDR R0, =ADDR_LCD_ASCII 
		LDR R1, =DISPLAY_2_BIT
		LDR R1, [R1]
		STRB R1, [R0]
		B 		case_color_blue_end

case_color_blue_4_bit
		LDR R0, =ADDR_LCD_ASCII 
		LDR R1, =DISPLAY_4_BIT
		LDR R1, [R1]
		STRB R1, [R0]
		B 		case_color_blue_end

case_color_blue_8_bit
		LDR R0, =ADDR_LCD_ASCII 
		LDR R1, =DISPLAY_8_BIT
		LDR R1, [R1]
		STRB R1, [R0]
		B 		case_color_blue_end

case_color_blue_end		
		
		BL		delete_LED_31_0
		
		BL		delete_LCD_number_2nd
		
		b		student_end
		

write_7seg 
		LDR R7,=ADDR_7_SEG_BIN_DS3_0
		STRH R0,[R7]
		BX LR
		





student_end



; END: To be programmed
        B          main_loop
        
clear_lcd
        PUSH       {R0, R1, R2}
        LDR        R2, =0x0
clear_lcd_loop
        LDR        R0, =ADDR_LCD_ASCII
        ADDS       R0, R0, R2                       ; add index to lcd offset
        LDR        R1, =ASCII_DIGIT_CLEAR
        STR        R1, [R0]
        ADDS       R2, R2, #4                       ; increas index by 4 (word step)
        CMP        R2, #LCD_LAST_OFFSET             ; until index reached last lcd point
        BMI        clear_lcd_loop
        POP        {R0, R1, R2}
        BX         LR

write_bit_ascii
        PUSH       {R0, R1}
        LDR        R0, =ADDR_LCD_ASCII_BIT_POS 
        LDR        R1, =DISPLAY_BIT
        LDR        R1, [R1]
        STR        R1, [R0]
        POP        {R0, R1}
        BX         LR

        ENDP
        ALIGN


; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
