;* ----------------------------------------------------------------------------
;* --  _____       ______  _____                                              -
;* -- |_   _|     |  ____|/ ____|                                             -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems              -
;* --   | | | '_ \|  __|  \___ \   Zurich University of                       -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                           -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland               -
;* ----------------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 12
;* -- Description : Reading the User-Button as Interrupt source
;* -- 				 
;* -- $Id: main.s 5082 2020-05-14 13:56:07Z akdi $
;* -- 		
;* ----------------------------------------------------------------------------


                IMPORT init_measurement
                IMPORT clear_IRQ_EXTI0
                IMPORT clear_IRQ_TIM2

; -----------------------------------------------------------------------------
; -- Constants
; -----------------------------------------------------------------------------

                AREA myCode, CODE, READONLY

                THUMB

REG_GPIOA_IDR       EQU  0x40020010
LED_15_0            EQU  0x60000100
LED_16_31           EQU  0x60000102
REG_CT_7SEG         EQU  0x60000114
REG_SETENA0         EQU  0xe000e100


; -----------------------------------------------------------------------------
; -- Main
; -----------------------------------------------------------------------------             
main            PROC
                EXPORT main


                BL   init_measurement    

                ; Configure NVIC (enable interrupt channel)
                ; STUDENTS: To be programmed
				LDR R0, =REG_SETENA0		; Load SETENA address
				LDR R1, =0x10000040				; Load interrupt mask
				STR R1, [R0]				; Save interrupt mask	
				
                ; END: To be programmed 

                ; Initialize variables
                ; STUDENTS: To be programmed	


                ; END: To be programmed

loop
                ; Output counter on 7-seg
                ; STUDENTS: To be programmed

				LDR	R4, =EXTI0_Interrupt_counted	; Load counted variable address
				LDR R4, [R4]						; Load value from counted 
				LDR R0, =REG_CT_7SEG				; Load address for 7-seg displaz
				STR R4, [R0]						; Store vlaue on 7-seg
				
                ; END: To be programmed

                B    loop

                ENDP

; -----------------------------------------------------------------------------
; Handler for EXTI0 interrupt
; -----------------------------------------------------------------------------

                 ; STUDENTS: To be programmed
EXTI0_IRQHandler PROC
	
				EXPORT EXTI0_IRQHandler
				PUSH {LR}							; Save context
				
				LDR R0, =EXTI0_Interrupt_counter	; Load interrupt counter address	
				LDR R1, [R0]						; Load value from interrupt counter
				
				ADDS R1, #1							; Increment interrupt counter by one
				
				STR R1, [R0]						; Save new interrupt counter
				
				BL clear_IRQ_EXTI0					; Clear pending flag for interrupt
				POP {PC}							; Restore contxt
				ENDP
					
                 ; END: To be programmed

 
; -----------------------------------------------------------------------------                   
; Handler for TIM2 interrupt
; -----------------------------------------------------------------------------
                ; STUDENTS: To be programmed
TIM2_IRQHandler PROC
				EXPORT TIM2_IRQHandler
				PUSH {LR}							; Save context
				
				LDR R1, =LED_16_31					; Load address for led
				LDR R2, [R1]						; Load current value from leds	
				LDR R3, =0xFFFF						; Load full value
				
				EORS R2, R2, R3						; XOR full value and current value (blinking)
				STR R2, [R1]						; Store result in led address
				
				LDR R1, =EXTI0_Interrupt_counter	; Load interrupt counter address	
				LDR R2, [R1]						; Load interrupt counter value
				LDR R3, =EXTI0_Interrupt_counted	; Load counted address	
				
				STR	R2, [R3]						; Save counter value to counted address
				LDR R3, =0x0						; Load reset value
				STR	R3, [R1]						; Reset counter

				BL clear_IRQ_TIM2					; Clear pending flag for interrupt
				POP {PC}							; Restore contxt
				ENDP

                ; END: To be programmed
                ALIGN

; -----------------------------------------------------------------------------
; -- Variables
; -----------------------------------------------------------------------------

                AREA myVars, DATA, READWRITE

                ; STUDENTS: To be programmed
EXTI0_Interrupt_counter	DCD	0x00000000
EXTI0_Interrupt_counted	DCD	0x00000000
                ; END: To be programmed


; -----------------------------------------------------------------------------
; -- End of file
; -----------------------------------------------------------------------------
                END
