;-----------------------------------------------------
;Check if year is leap year
;I:    ax    year
;O:    carry set if leap year
;-----------------------------------------------------
_is_leap_year
	push    dx
	push    cx
	cmp	    ax, 0x190
	jb	    ily_end		;exit if error
	push	ax
	mov	    cx,400
	xor	    dx,dx		;clear dx
	div	    cx
	cmp	    dx,0		;check if centenial leap
	pop	    ax
	je	    got_leap	;jmp if leap
	mov	    cx,4
	xor	    dx,dx
	div	    cx
	cmp	    dx,0
	jne	    not_leap	;jmp if not leap
got_leap:
	stc
	jmp	    ily_end
not_leap:
    clc
ily_end:
    pop	   cx
    pop    dx
	ret
;-----------------------------------------------------

