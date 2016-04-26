;-----------------------------------------------------
;-----------------------------------------------------
;Display space chaacter
;I:    none
;O:    none
;-----------------------------------------------------

_display_space:
    mov ah, 0x0E    ; BIOS teletype
    mov al, 0x20    ; space character
    mov bh, 0x00    ; display page 0
    mov bl, 0x07    ; text attribute
    int 0x10        ; invoke BIOS
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display CRLF
;I:    none
;O:    none
;-----------------------------------------------------
_display_endl:
    mov ah, 0x0E        ; BIOS teletype acts on newline!
    mov al, 0x0D
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    mov ah, 0x0E        ; BIOS teletype acts on linefeed!
    mov al, 0x0A
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display prompt
;I:    none
;O:    none
;-----------------------------------------------------

_display_prompt:
    mov si, strPrompt   ;load message
    mov al, 0x01        ;request sub-service 0x01
    int 0x21
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Get user command
;I:    none
;O:    none
;-----------------------------------------------------

_get_cmd:
    mov BYTE[nCmdSize],0x00 ; set 0 cmd length
    mov di,strCmd
   _get_cmd_begin:
    mov ah,0x10 ; read a char
    int 0x16
    
    cmp al,0x08; check back space
    je  _backspace
    
    cmp al, 0x0D        ;check if Enter pressed
    je _enter_key
    
    mov bh,[cmdLen]
    mov bl,[nCmdSize]
    cmp bh,bl   ; is max len  reached ?
    je _get_cmd_begin
    
    mov [di],al        ; add it to buffer
    inc di
    inc BYTE[nCmdSize] ;increment counter
    
    mov ah,0x0E ; Display char
    mov bl,0x07
    int 0x10
    jmp _get_cmd_begin;
  _backspace:
    mov bh,0x00
    mov bl,[nCmdSize]
    cmp bh,bl        ; if counter = 0 do nothing
    je _get_cmd_begin
    
    dec BYTE[nCmdSize]
    dec di
    
    mov ah,0x03  ; read cursor position
    mov bh,0x00
    int 0x10
    
    cmp dl,0x00
    jne _move_back
    dec dh
    mov dl,79
    mov ah,0x02
    int 0x10
    
    mov ah,0x09  ;display
    mov al,' '
    mov bh,0x00
    mov bl,0x07
    mov cx,1
    int 0x10
    jmp _get_cmd_begin
    
  _move_back:
    mov ah,0x0E
    mov bh,0x00
    mov bl,0x07
    int 10h
    mov ah,0x09
    mov al,' '
    mov bh,0x00
    mov bl,0x07
    mov cx,1
    int 0x10
    jmp _get_cmd_begin
    
  _enter_key:
    mov BYTE[di],0x00
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Display logo
;I:    none
;O:    none
;-----------------------------------------------------
  _disp_logo:
    mov si,logo1
    mov al,0x01
    int 0x21
    call _display_endl
    
    mov si,logo2
    mov al,0x01
    int 0x21
    call _display_endl
    ret
;-----------------------------------------------------
