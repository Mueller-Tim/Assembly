                AREA myCode, CODE, READONLY
                THUMB

          
					EXPORT out_word	
					EXPORT in_word						
; out_word
; - address in R0
; - value in R1  
out_word	      	PROC
					
					STR		R1, [R0]					; load value from R1 in address of R0
					BX		LR
				
					ENDP
						
                   
; int_word
; - address in R0
; - result in R0   
in_word		      	PROC

						
					LDR		R0, [R0]					; read value from address R0 into R0
					
					BX		LR
				

					ENDP
					ALIGN
						
                  
                END
