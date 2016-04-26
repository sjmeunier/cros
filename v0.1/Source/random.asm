;-----------------------------------------------------
;Generate a random number
;I:    bx    min val
;      bp    max val
;O:    ax    random number
;-----------------------------------------------------
_random_word:
    push	dx
    push    cx
	mov	ax, rndseed
	cmp	ax, 0x0000			;check if first entry
	jne	do_rand			; jmp if not first entry
;
; initialize the random seed
;
	call	_random_seed

do_rand:
    mov	cx,0x04E7			;get constant multiplier
	mul	cx
	add	ax,0x181D			;add constant adjustment factor
	adc	dx,0
	mov	cx,0x7262		;mod value for ranging
	div	cx
	mov	rndseed,dx		;store new seed
;
; now convert number to desired range
;
	mov	ax,dx
	call	_scale_word
	
	pop	cx
	pop dx
	ret
;-----------------------------------------------------	
;-----------------------------------------------------
;Scale number
;I:    bx    min val
;      bp    max val
;      ax    number to be scaled
;O:    ax    scaled number
;-----------------------------------------------------
_scale_word:
	push	cx
	push    dx
	mov	cx,bp
	sub	cx,bx		;compute range delta
	mul	cx		;(input value) * (delta)
	mov	ax,dx
    add	ax,bx		;result + low range = scaled number
    pop	dx
    pop cx
	ret	
;-----------------------------------------------------
;Generate random seed
;I:    none
;O:    ax    low val of clock
;-----------------------------------------------------
_random_seed
	push	cx
	push    bx
	mov bx, 0x046C
	mov	cx,ds
	sub	ax,ax
	mov	ds,ax
	mov	ax,[bx]
	mov	ds,cx
	pop bx
	pop	cx
	ret	
;-----------------------------------------------------