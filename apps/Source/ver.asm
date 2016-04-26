;CAPS_ON - Turn the keyboard CAPS LOCK key on
; inputs:  none
; output:  none
.MODEL TINY
.STACK

.DATA
Msg      db  'Silly-OS Version 0.0.001\'


string1 db	100 dup (31h)	; The number 1
string2 db	100 dup (32h)	; The number 2

;----------------------------------------------------
;
; This routine prints a character to the screen
;	without using BIOS interupts.
;
;----------------------------------------------------
.CODE	

	push	ds	; Save return segment address on stack.
	xor	ax,ax	; Zero out ax reg,
	push	ax	;   and place on stack.
	mov	ax,data  ;
	mov	ds,ax	 ; Establish addressibility,
			 ;   for DATA segment.
;
; Set up for and simulate a INT 10h with ah = 10
;
	mov	ah,0		 ; Write on row 6
	mov	al,0		 ;  column 10
	mov	bh,0		 ;  on page 0
	mov	cx,length string1 ; 1000 characters
	mov	si,offset string1
	call	disp_text

	mov	ah,0		 ; Write on row 6
	mov	al,0		 ;  column 10
	mov	bh,0		 ;  on page 0
	mov	cx,length string2 ; 1000 characters
	mov	si,offset string2
	call	disp_text
exit:	mov	ax,4C00h
	int	21h
	end

;-------------------------------------------------------------
;
; DISP_TEXT
;
; This routine will print N characters on the screen.
;
; INPUT
;	(ah)	= Row to start printing data on.
;	(al)	= Column to start printing data on.
;	(bh)	= Number of page to use.
;	(cx)	= Number of characters to write.
;	(ds:si) = Address of message to print on screen.
;
; OUTPUT
;	None.
;
;-------------------------------------------------------------
DISP_TEXT	proc	near
	assume	ds:intdata	; Use intdata as data segment.
	sti		; Restore interupts.
	cld		; Set direction forward.
	push	es	; Save registers on stack.
	push	dx
	push	cx
	push	bx
	push	si
	push	di
	push	ds
	push	ax	; save row, column value.

	mov	ax,intdata	; Establish addressibility for
	mov	ds,ax		;   DISP_TEXT procs.
	mov	ax,0b800h	; Color card segment
	mov	di,equip_flag	; Get equipment setting
	and	di,30h		; Isolate CRT switches
	cmp	di,30h		;   Is setting for B&W card?
	jne	skip_bw
	mov	ax,0b000h	;   If B&W reset address.
skip_bw:
	mov	es,ax		; Set up ES to point at video ram areas.
	mov	ah,crt_mode	; Move the CRT mode into ah.
	jmp	write_character ; Jump over Write_Character's subroutines.
DISP_TEXT	endp

;--------------------------------------------------------------------
;
; FIND_POSITION
;
;	These routines convert the row and column contained in AX
;	to the offset required for screen memory. (The regen buffer).
;	This routine works for alphanumeric modes.
;
; INPUT
;	ax = row, column position for characters.
;
; OUTPUT
;	ax = offset of char position in regen buffer.
;
;--------------------------------------------------------------------

Find_position	proc	near
	push	cx
	mov	cl,bh		; display page to cx
	xor	ch,ch
	xor	bx,bx		; Assume screen 0.
	jcxz	no_page
page_loop:			; If we are not on screen 0 then
	add	bx,crt_len	;    adjust bx for the page we're on.
	loop	page_loop
no_page:

	push	bx		; Save work register
	mov	bx,ax
	mov	al,ah		; Move rows to al.
	mul	byte ptr crt_cols	; Determine # of bytes to row.
	xor	bh,bh
	add	ax,bx		; Add in column value.
	sal	ax,1		; Times 2 for attribute bytes.
	pop	bx		; Restore work register

	add	bx,ax		; Add to start of screen buffer.
	pop	cx
	ret
find_position	endp

;----------------------------------------------------------------------
;
; WRITE_CHARACTER
;
;	This routine writes the characters at
;	the calculated cursor position, with attribute unchanged.
;
;	This procedure could be changed to write the attribute
;	byte also. This would require changing the MOVSB instruction
;	to a MOVSW instruction as well as deleting the INC DI
;	instruction that follows it.
;
;----------------------------------------------------------------------

write_character proc	near
	cmp	ah,4		; Is this graphics ?
	jc	begin
	cmp	ah,7		; Is this the b&w card ?
	je	begin
	pop	ax		; Throw away ax,
	ret			;   and abort.
begin:
	pop	ax		; Restore row and column.
	call	find_position	; Calculate address at which to
	mov	di,bx		;   put text, and put it in di.
;
;------Wait for horizontal retrace.
;
wait_retrace:
	mov	dx,addr_6845	; Get base address of 6845 screen controller,.
	add	dx,6		;     and point at 6845 status port.
	pop	ds		; Restore users Data segment so we can
	assume	ds:data 	;	  find and print his data.
wait_low:
	in	al,dx		; Get status.
	test	al,1		; Is it low ?
	jnz	wait_low	; Wait until it is.
	cli			; Mask out interupts.
wait_high:
	in	al,dx		; Get status.
	test	al,1		; Is it high ?
	jz	wait_high	; Wait until it is.
	movsb			; Put the the char/attr
	inc	di		; Bump pointer past attribute byte.
	loop	wait_low	;   as many times as requested.
;
;  Return to caller.
;
	sti		; reallow interupts
	pop	di	; recover registers and segments
	pop	si
	pop	bx
	pop	cx
	pop	dx
	pop	es
	ret
write_character endp

