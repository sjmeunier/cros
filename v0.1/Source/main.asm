;-----------------------------------------------------
;CrOs v0.01
;Serge Meunier
;
;Main CrOS kernel
;-----------------------------------------------------
;
 
[org 0x000]
[bits 16]

[SEGMENT .text]

;-----------------------------------------------------
;Code start
;----------------------------------------------------- 
    mov     ax, 0x0100			;location where kernel is loaded
    mov     ds, ax
    mov     es, ax

    cli
    mov     ss, ax				;stack segment
    mov     sp, 0xFFFF			;stack pointer at 64k limit
    sti

    push    dx
    push    es
    xor     ax, ax
    mov     es, ax
    cli
    mov     word [es:0x21*4], _int0x21	; setup interrupt service
    mov     [es:0x21*4+2], cs
    sti
    pop     es
    pop     dx
    
    mov     ah,00h
    mov     al,0ch
    int     10h

    call     _display_welcome
    call     _display_endl
    
	call     _shell				; call the shell

_rebootpoint:
    call     _display_endl
    int     0x19                ; reboot
;-----------------------------------------------------
;Code end
;----------------------------------------------------- 

;-----------------------------------------------------
;Kernel module inclusions
;----------------------------------------------------- 
%include "display.asm"
%include "shell.asm"
%include "exec.asm"
%include "cpu.asm"
%include "int21h.asm"
%include "data.inc"

