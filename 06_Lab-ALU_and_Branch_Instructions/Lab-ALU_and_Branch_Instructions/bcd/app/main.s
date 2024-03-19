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
; -- CT1 P06 "ALU und Sprungbefehle" mit MUL
; --
; -- $Id: main.s 4857 2019-09-10 17:30:17Z akdi $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address Defines
; ------------------------------------------------------------------

ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_7_SEG_BIN_DS3_0    EQU     0x60000114
ADDR_BUTTONS            EQU     0x60000210

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF       EQU     0x0000

; STUDENTS: To be programmed

ADDR_LED_15_8           EQU     0x60000101
BITMASK_LOWER_NIBBLE	EQU		0x0F
BIT_1_MASK				EQU		0x01	
VALUE_10				EQU		0x0A
VALUE_0					EQU		0x00
; END: To be programmed

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
            
; STUDENTS: To be programmed

		;Task 3.1 
		; R0 value ones
		; R1 value tens
		; R2 value tens+ones in BCD
		; R3 value tens and ones in Binary
		; R4 Test Buttonpush
		; R5 value BCD und Binary combined
		; R6 Backlight
		; R7 temp
		
		
		
		
		LDR R7, =ADDR_DIP_SWITCH_7_0		; Load the address of switch DS7-0 into R7
		LDRB R0,[R7]						; Load the value from DS7-0 into R0
		
		LDR R7, =ADDR_DIP_SWITCH_15_8		; Load the address of switch DS15-8 into R7
		LDRB R1,[R7]						; Load the value from DS15-8 into R0
		
		LDR R7, =BITMASK_LOWER_NIBBLE		; Load the address BITMASK_LOWER_NIBBLE
		ANDS R0,R0,R7						; ADD the value of R0 and value of R7 0x0F and save it in R0
		ANDS R1,R1,R7						; ADD the value of R1 and value of R7 0x0F and save it in R1
		
		
		MOVS R2,R1							; Copie the value of R1 into R2
		LSLS R2,R2,#4						; Shift the value of R2 4 bits to the left 
		ADDS R2,R0,R2						; Add the value of R0 and R2 and save it into R2
		
		;;; Frage wieso speichert man hier nur addressen? nicht mit STRH

		LDR R7, =ADDR_BUTTONS				; Load the address of the buttons into R7
		LDR R4, [R7]						; Load the value from the buttons
		LDR R7, =BIT_1_MASK					; Load the adress of the bidmask into R5
		TST R4, R7							; Addition R4 and R5, wenn button bushed 1+1 = 0, CMP woult be substraction
		BEQ 	mult						; EQ equal => z = 0, if button is bushed go to branch mult
		B 		shift						; go to branch shift
		
shift										; start of branch shift

		MOVS R7, R1							; Copie value of R1 into R7
		LSLS R7, R7,#1						; Move the value of R7 1 bit to the left, multiplication of 2
		MOVS R3, R7							; Copie value of R7 into R3
		LSLS R7,R7,#2						; Move the value of R7 2 bit to the left, multiplication of 4, (total multiplication of 8)
		ADDS R3, R3, R7						; Add the value of R7 and R3 and save into R3, total multplication of 10
		ADDS R3, R3, R0						; Add the value of R3 and R0 and save into R3
		
		LDR R7, =ADDR_LCD_RED				; Load the address of LCD Red light into R7
		LDR R6, =LCD_BACKLIGHT_FULL			; Load the address of LCD backlight full into R6
		STRH R6,[R7]						; Copie the value of lcd red into backlight full
		LDR R7, =ADDR_LCD_BLUE				; Load the address of LCD blue light into R7
		LDR R6, =LCD_BACKLIGHT_OFF			; Load the address of LCD backlight off into R6
		STRH R6,[R7]						; Copie the value of lcd blue into backlight off
		
		
		B 		done


mult

		LDR R7,= VALUE_10					; Load the address of value_10 0x0A into R7
		MOVS R3, R1							; Copie the value of R3 into R1
		MULS R3, R7, R3						; Multiplay the value of R7 and R3 and save into R3
		ADDS R3, R3, R0						; Add R3 and R0 and save into R3
		
		LDR R7, =ADDR_LCD_BLUE				; Load the address of LCD blue light into R7
		LDR R6, =LCD_BACKLIGHT_FULL			; Load the address of LCD backlight full into R6
		STRH R6,[R7]						; Load the address of LCD blue light into R7
		LDR R7, =ADDR_LCD_RED				; Load the address of LCD red light into R7
		LDR R6, =LCD_BACKLIGHT_OFF			; Load the address of LCD backlight off into R6
		STRH R6,[R7]						; Copie the value of lcd red into backlight off
		B		done
			
		
done	
		LSLS R3,R3,#8
		MOVS R5, R3
		
		ORRS R5, R5, R2						; ODER-Verknüpfung von R5 mit R2 (kombiniere beides)
		
		LDR R7, =ADDR_LED_15_0				; Load the address of the led15-0 into R7
		STRH R5,[R7]							
				
		LDR R7, = ADDR_7_SEG_BIN_DS3_0
		
		STRH R5,[R7]
		
		

		;Task 3.2
		; R0
		; R1 Maske 0x01
		; R2 Zähler von "1"en
		; R4 Endbedinung 256
		; R5 
		; R6 Rotationszähler
		; R7 temp
		LDR R7,=ADDR_LED_15_8				; Lade die Adresse von LED 15-8 in R7
		LDRB R0,[R7]						; Lade den Wert von LED 15-8 in R0
		LDR R1, =1	;mask					; Setze die Maske R1 auf 1
		LDR R2, =0	;number of ones			; Initialisiere den Zähler R2 der Einsen auf 0
		LDR R4, =0x100						; Setze die Endbedingung für den Loop (256, oder 1 verschoben um 8 Stellen)
check
		CMP R1, R4 ;end bedingung, loop wird verlassen, wenn mask ein szu gross ist
		BEQ end_of_loop						; Wenn gleich, gehe zu end_of_loop
		TST	R0, R1							; Teste, ob das entsprechende Bit in R0 gesetzt ist (gemäß Maske R1)
		BNE bit_is_set						; Wenn Bit gesetzt, gehe zu bit_is_set
;bit is not set
		LSLS R1,R1,#1						; Verschiebe Maske R1 um 1 Bit nach links
		B check								; Gehe zurück und checke nächstes Bit
bit_is_set
		LSLS R1,R1,#1 ;shift mask			; Verschiebe Maske R1 um 1 Bit nach links (nächste Bitposition)
		
		LSLS R2,R2,#1 ;shift counter		; Verschiebe den Zähler R2 um 1 Bit nach links
		ADDS R2,#1    ;add to counter		; Erhöhe den Zähler R2 (füge 1 hinzu)
					
		B check								; Gehe zurück und checke nächstes Bit
		
end_of_loop
		LDR R7,=ADDR_LED_31_16				; Lade die Adresse von LED 31-16 in R7
		STRH R2,[R7]						; Speichere den Zählerwert R2 in LED 31-16
		LDR R6,=1							; Setze den Rotationswert R6 auf 1
		MOVS R5, R2							; Kopiere den Zählerwert R2 in R5
		LSLS R5, #16						; Verschiebe R5 um 16 Bits nach links
		ORRS R5, R5, R2						; ODER-Verknüpfung von R5 mit R2 (kombiniere beides)
		LDR R3,=0							; Initialisiere Rotationszähler R3 auf 0
		
start_rotate
		RORS R5, R5, R6						; Rotiere R5 rechts um R6 (1 Bit)
		STRH R5,[R7]						; Speichere das rotierte R5 in LED 31-16
		BL pause							; Aufruf der Pause-Prozedur für Rotationsverzögerung
		ADDS R3,#1							; Erhöhe den Rotationszähler R3
		
		CMP R3,#16							; Vergleiche R3 mit 16 (volle Rotation)
		BNE start_rotate					; Wenn R7 nicht 16, wiederhole die Rotation


		
		
; END: To be programmed
        B       main
        ENDP
            
;----------------------------------------------------
; Subroutines
;----------------------------------------------------

;----------------------------------------------------
; pause for disco_lights
pause           PROC
        PUSH    {R0, R1}
        LDR     R1, =1
        LDR     R0, =0x000FFFFF
        
loop        
        SUBS    R0, R0, R1
        BCS     loop
    
        POP     {R0, R1}
        BX      LR
        ALIGN
        ENDP

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
