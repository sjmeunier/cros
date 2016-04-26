;-----------------------------------------------------
;CrOs v0.01
;Serge Meunier
;
;Int 0x21 routine definitions
;-----------------------------------------------------
;
_int0x21:
;-----------------------------------------------------
;service 0x01
;Display a string on screen
;I:    si    address of first char of null terminated string
;O:    none
;-----------------------------------------------------
_int0x21_ser0x01:               ;service 0x01
    cmp     al, 0x01            ;see if service 0x01 wanted
    jne     _int0x21_end        ;goto next check (now it is end)

_int0x21_ser0x01_start:
    lodsb                       ; load next character
    or      al, al              ; test for NUL character
    jz      _int0x21_ser0x01_end
    mov     ah, 0x0E            ; BIOS teletype
    mov     bh, 0x00            ; display page 0
    mov     bl, 0x07            ; text attribute
    int     0x10                ; invoke BIOS
    jmp     _int0x21_ser0x01_start
    
_int0x21_ser0x01_end:
    jmp     _int0x21_end
;-----------------------------------------------------
 _int0x21_end:
    iret
;-----------------------------------------------------
    