;-----------------------------------------------------
;CrOs v0.02
;Serge Meunier
;
;Display procedures
;-----------------------------------------------------
;
;-----------------------------------------------------
;Set graphics mode
;I:    al    video mode
;O:    none
;-----------------------------------------------------
_set_video_mode:
    mov     ah, 00h     
    int     10h         ; invoke BIOS
    ret
;-----------------------------------------------------
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
    mov     bl, 02h
    call _display_string_col
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display welcome
;I:    none
;O:    none
;-----------------------------------------------------
_display_welcome:
    mov     si, OsName           ; load message
    mov     bl, 5
    call     _display_string_col
    call     _display_endl
    mov     si, strWelcome       ; load message
    mov     bl, 3
    call     _display_string_col
    
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display string
;I:    si    Address of string
;O:    none
;-----------------------------------------------------
_display_string:
    mov     ah, 01h              ; request sub-service 0x01
    mov     bl, 0x07            ; text attribute
    int     21h
    
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display string in color
;I:    si    Address of string
;      bl    color
;O:    none
;-----------------------------------------------------
_display_string_col:
    mov     ah, 01h              ; request sub-service 0x01
    int     21h
    
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Color test
;I:    none
;O:    none
;-----------------------------------------------------
_colortest:
    push cx
    push si
    push ax
    push bx
    
    mov cl, 0
  BeginTest:
    call    _display_endl
    mov     si, strColor
    mov     bl, cl
    call    _display_string_col
   
    mov     ah, 0Eh     ; BIOS teletype
    mov     al, 4Eh     ; space character
    mov     bh, 00h     ; display page 0
    mov     bl, cl      ; text attribute
    int     10h         ; invoke BIOS     
    add     cl, 1
    cmp     cl, 7
    je      BeginTest
    pop bx
    pop ax
    pop si
    pop cx
    ret
;-----------------------------------------------------
