;-----------------------------------------------------
;CrOs v0.01
;Serge Meunier
;
;Display procedures
;-----------------------------------------------------
;
;-----------------------------------------------------
;Display space chaacter
;I:    none
;O:    none
;-----------------------------------------------------
_display_space:
    mov     ah, 0x0E    ; BIOS teletype
    mov     al, 0x20    ; space character
    mov     bh, 0x00    ; display page 0
    mov     bl, 0x07    ; text attribute
    int     0x10        ; invoke BIOS
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display CRLF
;I:    none
;O:    none
;-----------------------------------------------------
_display_endl:
    mov     ah, 0x0E        ; BIOS teletype acts on newline!
    mov     al, 0x0D
    mov     bh, 0x00
    mov     bl, 0x07
    int     0x10
    mov     ah, 0x0E        ; BIOS teletype acts on linefeed!
    mov     al, 0x0A
    mov     bh, 0x00
    mov     bl, 0x07
    int     0x10
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display prompt
;I:    none
;O:    none
;-----------------------------------------------------
_display_prompt:
    mov     si, strPrompt   ;load message
    mov     al, 0x01        ;request sub-service 0x01
    int     0x21
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display welcome
;I:    none
;O:    none
;-----------------------------------------------------
_display_welcome:
    mov     si, OsName           ; load message
    mov     al, 0x01             ; request sub-service 0x01
    int     0x21
    call     _display_endl
    mov     si, strWelcome       ; load message
    mov     al, 0x01             ; request sub-service 0x01
    int     0x21
    
    ret

;-----------------------------------------------------





