;CAPS_ON - Turn the keyboard CAPS LOCK key on
; inputs:  none
; output:  none
.MODEL SMALL
.STACK

.CODE
	jmp After
	msg	db	'Hello World',0	
After:
	mov si, 0204h
putstr:

	lodsb		; AL = [DS:SI]
	or al, al	; Set zero flag if al=0
	jz putstrd	; jump to putstrd if zero flag is set
      ;  mov al, 4Eh
	mov bx, 4Ah	; color
	mov ah, 0eh	; video function 0Eh (print char)
	int 10h

	jmp putstr
putstrd:

exit:	mov	ax,4C00h
	int	21h
	
end

;--------------------------------------------------------
;Display character
; Input:	AL - Character
;		BX - Color
; Output:	none
;
; TODO:- Change to not use interrupts
;--------------------------------------------------------
;disp_char	proc	near
;	mov ah, 0eh	; video function 0Eh (print char)
;	int 10h
;disp_char	endp
