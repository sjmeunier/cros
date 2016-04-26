;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -( SYSTEM  )
; Detect CPU
;
; inputs:    none
; output:    AX = 0 if 8086/8088
;            AX = 1 if 80186/80188
;            AX = 2 if 80286
;            AX = 3 if 386 (SX or DX)
;            AX = 4 if 486 (SX or DX)
.MODEL TINY

.STACK

.CODE

     XOR     AX,AX
     PUSH    AX
     POPF
     PUSHF
     POP     AX
     AND     AX,0F000h
     CMP     AX,0F000h
     JNZ     getcpu_2			;jmp if not 8088,80188,8086,80186
     PUSH    CX
     MOV     AX,0FFFFh
     MOV     CL,21h    			;286+ mask -cl- with 1fh
     SHL     AX,CL
     POP     CX
     JNZ     getcpu_1			;jmp if 80188 or 80186
;
; we have found an 8088 or 8086
;     
     XOR     AX,AX
     JMP     getcpu_exit
;
; we have found an 80188 or 80186
;     
getcpu_1:
     MOV     AX,0001
     JMP     getcpu_exit
;
; we have a 286+ cpu, determine if this is 286
;     
getcpu_2:
     MOV     AX,7000h
     PUSH    AX
     POPF
     PUSHF
     POP     AX
     AND     AX,7000h
     JNZ     getcpu_3			;jmp if not 80286
;
; we have found an 80286
;     
     MOV     AX,0002
     JMP     getcpu_exit
;
; we have found a 80386+ cpu, determine if 80386
;     
getcpu_3:
     PUSH    DX
     MOV     DX,0003			;preload code for 80386
     DB		66H,50H			;PUSH    EAX
     DB		66H,53H			;PUSH    EBX
     DB		66H,51H			;PUSH    ECX
     DB		66H,8BH,0DCH		;MOV     EBX,ESP
     DB		66H,83H,0E4H,8CH	;AND     ESP,-04
     DB		66H,9CH			;PUSHFD
     DB		66H,58H			;POP     EAX
     DB		66H,8BH,0C8H		;MOV     ECX,EAX
     DB		66H,35H,00,00,04,00	;XOR     EAX,00040000h
     DB		66H,50H			;PUSH    EAX
     DB		66H,9DH			;POPFD
     DB		66H,9CH			;PUSHFD
     DB		66H,58H			;POP     EAX
     DB		66H,25H,00,00,04,00	;AND     EAX,00040000h
     DB		66H,81H,0E1H,0,0,04,00	;AND     ECX,00040000h
     DB		66H,3BH,0C1H		;CMP     EAX,ECX
     JZ      getcpu_4			;jmp if 80386
;
; we have found an 80486
;     
     MOV     DX,0004			;preload 80486 code
getcpu_4:
     DB		66H,51H			;PUSH    ECX
     DB		66H,9DH			;POPFD
     DB		66H,8BH,0E3H		;MOV     ESP,EBX
     DB		66H,59H			;POP     ECX
     DB		66H,5BH			;POP     EBX
     DB		66H,58H			;POP     EAX
     MOV     AX,DX
     POP     DX
getcpu_exit:

	add al, 30h	; convert to ascii
	mov bx, 4Ah	; color
	mov ah, 0eh	; video function 0Eh (print char)
	int 10h

exit:	mov	ax,4C00h
	int	21h
	end