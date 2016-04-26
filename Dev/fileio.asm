;-----------------------------------------------------
;CrOs v0.02
;Serge Meunier
;
;File IO routines
;-----------------------------------------------------
;
;-----------------------------------------------------
;Convert a command to a filename
;I:    si    Address of string to convert
;      di    Address of string containing filename
;O:    di
;-----------------------------------------------------
_command_to_filename:

	xor     cx, cx

  CommandToFileName_StringLength:

	lodsb

	or      al, al
	jz      CommandToFileName_Resume

	cmp     al, 13
	je      CommandToFileName_Resume


	cmp     al, 96
	ja      CommandToFileName_Capital

	stosb

	add     ch, 1
		
	cmp     ch, 8
	je      CommandToFileName_Resume2

	jmp     CommandToFileName_StringLength

  CommandToFileName_Capital:
	cmp     al, 123
	jb      CommandToFileName_Capital1

	stosb
	add     ch, 1
    cmp     ch, 8
	je      CommandToFileName_Resume2

	jmp     CommandToFileName_StringLength

  CommandToFileName_Capital1:
	sub     al, 32

	stosb
	add     ch, 1
	cmp     ch, 8
	je      CommandToFileName_Resume2

	jmp     CommandToFileName_StringLength
		
  CommandToFileName_Resume:
	mov     al, ' '
	stosb
	add     ch, 1
	cmp     ch, 8
	jne     CommandToFileName_Resume

  CommandToFileName_Resume2:
	mov     al, 'B'
	stosb
	mov     al, 'I'
	stosb
	mov     al, 'N'
	stosb
	ret   