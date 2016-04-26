;-----------------------------------------------------
;CrOs v0.02
;Serge Meunier
;
;String handling routines
;-----------------------------------------------------
;
;-----------------------------------------------------
;Clear a string by setting it to 0
;I:    si    address of string
;      cl    length of string
;O:    none
;----------------------------------------------------- 
_clear_string:
    mov     ch, 0
    
	xor     cx, cx
	mov     cl, al
   
  ClearString_Loop:
	mov     al, 0
	stosb
	add     ch, 1
	cmp     ch, cl
	jne     ClearString_Loop

	ret