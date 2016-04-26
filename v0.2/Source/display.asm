;-----------------------------------------------------
;CrOs v0.02
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
    mov     ah, 0Eh     ; BIOS teletype
    mov     al, 20h     ; space character
    mov     bh, 00h     ; display page 0
    mov     bl, 07h     ; text attribute
    int     10h         ; invoke BIOS
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display CRLF
;I:    none
;O:    none
;-----------------------------------------------------
_display_endl:
    mov     ah, 0Eh         ; BIOS teletype acts on newline!
    mov     al, 0Dh
    mov     bh, 00h
    mov     bl, 07h
    int     10h
    mov     ah, 0Eh         ; BIOS teletype acts on linefeed!
    mov     al, 0Ah
    mov     bh, 00h
    mov     bl, 07h
    int     10h
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display prompt
;I:    none
;O:    none
;-----------------------------------------------------
_display_prompt:
    mov     si, strPrompt   ;load message
    mov     ah, 01h         ;request sub-service 0x01
    int     21h
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display welcome
;I:    none
;O:    none
;-----------------------------------------------------
_display_welcome:
    mov     si, OsName           ; load message
    mov     ah, 01h              ; request sub-service 0x01
    int     21h
    call     _display_endl
    mov     si, strWelcome       ; load message
    mov     ah, 01h              ; request sub-service 0x01
    int     21h
    
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display string
;I:    si    Address of string
;O:    none
;-----------------------------------------------------
_display_string:
    mov     ah, 01h              ; request sub-service 0x01
    int     21h
    
    ret
;-----------------------------------------------------

