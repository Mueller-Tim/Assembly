; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- sumdiff.s
; --
; -- CT1 P05 Summe und Differenz
; --
; -- $Id: sumdiff.s 705 2014-09-16 11:44:22Z muln $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_LED_7_0            EQU     0x60000100
ADDR_LED_15_8           EQU     0x60000101
ADDR_LED_23_16          EQU     0x60000102
ADDR_LED_31_24          EQU     0x60000103

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA MyCode, CODE, READONLY

main    PROC
        EXPORT main

user_prog
        ; STUDENTS: To be programmed

		;Task 3.2
		; R0 operant A 
		; R1 operant B
		; R2 sum of A and B
		; R3 subtraction of A and B
		; R5 flags from sum
		; R6 faggs from subtraction
		; R7 temp
		LDR R7, =ADDR_DIP_SWITCH_15_8 	; Load the address of switch DS15-8 into R7
		LDRB R0,[R7]					; Load the value from DS15-8 into R1
		
		LDR R7, =ADDR_DIP_SWITCH_7_0    ; Load the address of switch DS15-8 into R7
		LDRB R1,[R7]					; Load the value from DS15-8 into R1
		LSLS R0,R0,#24					; Shift value in R0 24 bits to the left for 32 bit addtion
		LSLS R1,R1,#24					; Shift value in R1 24 bits to the left for 32 bit addtion
		
		
		ADDS R2,R0,R1					; 32 bit addtion from R0 and R1 into R2
		
		MRS R5, APSR					; Coppies flags from last calculation into R5
		LSRS R5,R5,#24					; Shifts value in R5 24 bits to the right, because it's in 32 bit format
		LDR R7, =ADDR_LED_15_8			; Load the address of led 15 to 8 into R7
		STRB R5,[R7]					; Store the value in R7
		
		LSRS R2,R2,#24					; Shifts value in R2 24 bits to the right, because it's in 32 bit format
		LDR R7, =ADDR_LED_7_0			; Load the address of led 7 to 0 into R7
		STRB R2,[R7]					; Store the value in R7
		
		SUBS R3,R0,R1					; 32 bit substraction from R0 and R1 into R3
		
		MRS R6, APSR					; Coppies flags from last calculation into R6
		LSRS R6,R6,#24					; Shifts value in R6 24 bits to the right, because it's in 32 bit
		LDR R7, =ADDR_LED_31_24			; Load the address of led 15 to 31 into R24
		STRB R6,[R7]					; Store the value in R7
		
		LSRS R3,R3,#24					; Shifts value in R3 24 bits to the right, because it's in 32 bit format
		LDR R7, =ADDR_LED_23_16			; Load the address of led 23 to 16 into R7
		STRB R3,[R7]					; Store the value in R7
		
		
		
		
		;Achtung subtraction ergänzen
		




        ; END: To be programmed
        B       user_prog
        ALIGN
; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
