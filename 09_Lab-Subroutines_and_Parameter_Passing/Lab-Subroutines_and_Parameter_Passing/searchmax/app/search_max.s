;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 10
;* -- Description : Search Max
;* -- 
;* -- $Id: search_max.s 879 2014-10-24 09:00:00Z muln $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
                AREA myCode, CODE, READONLY
                THUMB
                    
; STUDENTS: To be programmed




; END: To be programmed
; -------------------------------------------------------------------                    
; Searchmax
; - tableaddress in R0
; - table length in R1
; - result returned in R0
; -------------------------------------------------------------------   
search_max      PROC
                EXPORT search_max

                ; STUDENTS: To be programmed
				; R0, max Value
				; R2 counter
				; R6 table adresse
				
				PUSH {R4,R5,R6,R7}
				
				MOVS R6,R0
				LDR R0, = 0x80000000 
				LDR R4,=0x0
				
				CMP R4,R1
				BEQ 	firstEndIf ;first if start
				
loop			LSLS R7,R4,#2 ;Do while start
				
				LDR R5,[R6,R7]
				
				CMP R0,R5
				
				BGT		secondEndIf ;second if start
				
				MOVS R0,R5
				
secondEndIf		ADDS R4, #0x1
				CMP R4,R1
				BNE 	loop
					
				
				
firstEndIf		POP {R4,R5,R6,R7}
				BX LR	
				
				
				
				

				



                ; END: To be programmed
                ALIGN
                ENDP
; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

