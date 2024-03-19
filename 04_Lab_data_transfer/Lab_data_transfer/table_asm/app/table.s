; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- table.s
; --
; -- CT1 P04 Ein- und Ausgabe von Tabellenwerten
; --
; -- $Id: table.s 800 2014-10-06 13:19:25Z ruan $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB
; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0         EQU     0x60000200
ADDR_DIP_SWITCH_15_8        EQU     0x60000201
ADDR_DIP_SWITCH_31_24       EQU     0x60000203
ADDR_LED_7_0                EQU     0x60000100
ADDR_LED_15_8               EQU     0x60000101
ADDR_LED_23_16              EQU     0x60000102
ADDR_LED_31_24              EQU     0x60000103
ADDR_BUTTONS                EQU     0x60000210

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F

; STUDENTS: To be programmed

ADDR_SEG7_BIN_1_0			EQU		0x60000114
ADDR_SEG7_BIN_3_2			EQU		0x60000115	

N_ELEMENTS					EQU		16
ELEMENT_SIZE				EQU		2	
	
BITMASK_LOWER_BYTE			EQU		0x00FF

; END: To be programmed


; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed

byte_array SPACE N_ELEMENTS + ELEMENT_SIZE
half_word_array SPACE N_ELEMENTS * ELEMENT_SIZE	


; END: To be programmed
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

main    PROC
        EXPORT main

readInput
        BL    waitForKey                    ; wait for key to be pressed and released
; STUDENTS: To be programmed
	
	; Register allecation in this lab
	; ~ R0a and up for values that are longer in use
	; ~R7 and down for themp usage
	; 
	
	
	; 1. read index from DS11-8, mask lower 4 bits, display (LED 15-8)
	;	R1: index input
	;	R2: index multi
	;	R7: temp
	LDR R7,=ADDR_DIP_SWITCH_15_8  ; Load the address of switch DS15-8 into R7
	LDRB R1,[R7]				 ; Load the value from DS15-8 into R1
	LDR R7, =BITMASK_LOWER_NIBBLE ; Load the mask into R7
	ANDS R1,R1,R7				; Perform a bitwise AND operation between R1 and R7 ignor the upper nibble
	MOVS R2, R1					;Store a copy of the value in R2
	LSLS R2,R1,#1				;Double the value in R2
	LDR R7,=ADDR_LED_15_8		;Load the address of LEDs 15-8 into R7
	STRB R1,[R7]				;Store the value in R7
	
	
	; 2. read value from DS7-0, display (LED 7-0)
	;	R0: value input
	;	R7; temp
	LDR R7,=ADDR_DIP_SWITCH_7_0  ; Load the address of switch DS7-0 into R7
	LDRB R0,[R7]				; Load the value from DS7-0 into R0
	LDR R7,=ADDR_LED_7_0		 ; Load the address of LEDs 7-0 into R7
	STRB R0,[R7]				; Store the value in R7
		
		
	; 3. write value to array at index (byte_array[index] = value)
	;										R7		R1		R0
	LDR R7,=half_word_array		 ; Load the address of the array into R7
	;ADDS R1,R1,R1 ist wie mal zwei, kann auch mit shift, dann wird STRB zu STRH
	LSLS R3,R1,#8				;Shift the index left by 8 bits
	ADD R3,R0					;ADD the value to the index
	STRH R3,[R7,R2]				;Store the value at the calculated address
	

	; 4. read value from DS27-24, mask upper 4bits, display (LED27-24)
	; R2: index output
	LDR R7,=ADDR_DIP_SWITCH_31_24	 ; Load the address of DIP switches S31-24 into R7
	LDRB R4,[R7]					; Load the value from S31-24 into R4
	ANDS R4,R4,R6					; Perform a bitwise AND operation between R4 and R6 
	LSLS R2,R4,#1					; Shift the value of R4 left by 1 bit
	LDR R7, =BITMASK_LOWER_NIBBLE	; Load the address of LEDs 31-24 into R7
	STRB R4,[R7]					 ; Store the value in R7
	
	
	; 5. read value from DS2316, display (LED23-16)
	; R3: value output
	LDR R7,=half_word_array			; Load the address of the array into R7
	LDRH R3,[R7,R2]					 ; Load the value from the selected array entry
	MOVS R2,R3						; Copy of the array entry
	LDR R6,=BITMASK_LOWER_BYTE		; Load the mask into R6
	ANDS R3,R6						; Perform a bitwise AND operation between R3 and R6 ignor the upper nipple
	LDR R7,=ADDR_LED_23_16			 ; Load the address of LEDs 23-16 into R7
	STRB R3,[R7]					 ; Store the value in R7
	LDR R7,=ADDR_SEG7_BIN_1_0		 ; Store the value in R7
	STRB R3,[R7]					; Store the value in R7
	LSRS R2,R2,#8					; Shift the index value right by 8 bits extract the lower 8 bits
	LDR R7,=ADDR_SEG7_BIN_3_2		  ; Address for 7-segment display
	STRB R2,[R7]					; Store the value in R7	
	LDR R7,=ADDR_LED_31_24 			; Address for the LEDs 31-24 into R7
	STRB R2,[R7]					; Store the value in R7	
	
	



; END: To be programmed
        B       readInput
        ALIGN

; ------------------------------------------------------------------
; Subroutines
; ------------------------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS           ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0         ; load key mask T0

waitForPress
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is released
        BNE     waitForRelease
                
        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
