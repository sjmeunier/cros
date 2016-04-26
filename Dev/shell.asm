;-----------------------------------------------------
;CrOs v0.02
;Serge Meunier
;
;CrOS shell routines
;-----------------------------------------------------
;
;-----------------------------------------------------
;Start up the shell and go into infinite loop
;I:    none
;O:    none
;-----------------------------------------------------
_shell:
 _shell_begin:
    call     _display_endl
    call     _display_prompt
	
    call    _clear_commands
	    
    call     _get_cmd
    call     _split_cmd
    call     _exec_cmd
    jmp     _shell_begin
;-----------------------------------------------------    
;-----------------------------------------------------
;Split user command
;I:    none
;O:    none
;-----------------------------------------------------
_split_cmd:
    ;adjust si/di
    mov     si, strCmd
    ;mov di, strCmd0

    ;move blanks
  _split_mb0_start:
    cmp     BYTE [si], 20h
    je      _split_mb0_nb
    jmp     _split_mb0_end

  _split_mb0_nb:
    inc     si
    jmp     _split_mb0_start

  _split_mb0_end:
    mov     di, strCmd0

  _split_1_start:         ;get first string
    cmp     BYTE [si], 20h
    je      _split_1_end
    cmp     BYTE [si], 00h
    je      _split_1_end
    mov     al, [si]
    mov     [di], al
    inc     si
    inc     di
    jmp     _split_1_start

  _split_1_end:
    mov     BYTE [di], 00h

    ;move blanks
  _split_mb1_start:
    cmp     BYTE [si], 20h
    je      _split_mb1_nb
    jmp     _split_mb1_end

  _split_mb1_nb:
    inc     si
    jmp     _split_mb1_start

  _split_mb1_end:
    mov     di, strCmd1

  _split_2_start:         ;get second string
    cmp     BYTE [si], 20h
    je      _split_2_end
    cmp     BYTE [si], 00h
    je      _split_2_end
    mov     al, [si]
    mov     [di], al
    inc     si
    inc     di
    jmp     _split_2_start

  _split_2_end:
    mov     BYTE [di], 00h

    ;move blanks
  _split_mb2_start:
    cmp     BYTE [si], 20h
    je      _split_mb2_nb
    jmp     _split_mb2_end

  _split_mb2_nb:
    inc     si
    jmp     _split_mb2_start

  _split_mb2_end:
    mov     di, strCmd2

  _split_3_start:         ;get third string
    cmp     BYTE [si], 20h
    je      _split_3_end
    cmp     BYTE [si], 00h
    je      _split_3_end
    mov     al, [si]
    mov     [di], al
    inc     si
    inc     di
    jmp     _split_3_start

  _split_3_end:
    mov     BYTE [di], 00h

    ;move blanks
  _split_mb3_start:
    cmp     BYTE [si], 20h
    je      _split_mb3_nb
    jmp     _split_mb3_end

  _split_mb3_nb:
    inc     si
    jmp     _split_mb3_start

  _split_mb3_end:
    mov     di, strCmd3

  _split_4_start:         ;get fourth string
    cmp     BYTE [si], 20h
    je      _split_4_end
    cmp     BYTE [si], 00h
    je      _split_4_end
    mov     al, [si]
    mov     [di], al
    inc     si
    inc     di
    jmp     _split_4_start

  _split_4_end:
    mov     BYTE [di], 00h

    ;move blanks
  _split_mb4_start:
    cmp     BYTE [si], 20h
    je      _split_mb4_nb
    jmp     _split_mb4_end

  _split_mb4_nb:
    inc     si
    jmp     _split_mb4_start

  _split_mb4_end:
    mov     di, strCmd4

  _split_5_start:         ;get last string
    cmp     BYTE [si], 20h
    je      _split_5_end
    cmp     BYTE [si], 00h
    je      _split_5_end
    mov     al, [si]
    mov     [di], al
    inc     si
    inc     di
    jmp     _split_5_start

  _split_5_end:
    mov     BYTE [di], 00h

    ret
;-----------------------------------------------------    
;-----------------------------------------------------
;Get user command
;I:    none
;O:    none
;-----------------------------------------------------
_get_cmd:
    mov     BYTE[nCmdSize],00h ; set 0 cmd length
    mov     di,strCmd
  _get_cmd_begin:
    mov     ah,10h ; read a char
    int     16h
    
    cmp     al,08h; check back space
    je      _backspace
    
    cmp     al, 0Dh        ;check if Enter pressed
    je      _enter_key
    
    mov     bh,[cmdLen]
    mov     bl,[nCmdSize]
    cmp     bh,bl   ; is max len  reached ?
    je      _get_cmd_begin
    
    mov     [di],al        ; add it to buffer
    inc     di
    inc     BYTE[nCmdSize] ;increment counter
    
    mov     ah,0Eh ; Display char
    mov     bl,07h
    int     10h
    jmp     _get_cmd_begin;
  _backspace:
    mov     bh,00h
    mov     bl,[nCmdSize]
    cmp     bh,bl        ; if counter = 0 do nothing
    je      _get_cmd_begin
    
    dec     BYTE[nCmdSize]
    dec     di
    
    mov     ah,03h  ; read cursor position
    mov     bh,00h
    int     10h
    
    cmp     dl,00h
    jne     _move_back
    dec     dh
    mov     dl,79
    mov     ah,0x02
    int     10h
    
    mov     ah,09h  ;display
    mov     al,' '
    mov     bh,00h
    mov     bl,07h
    mov     cx,1
    int     10h
    jmp     _get_cmd_begin
    
  _move_back:
    mov     ah,0Eh
    mov     bh,00h
    mov     bl,07h
    int     10h
    mov     ah,09h
    mov     al,' '
    mov     bh,00h
    mov     bl,07h
    mov     cx,1
    int     10h
    jmp     _get_cmd_begin
    
  _enter_key:
    mov     BYTE[di],0x00
    ret
;-----------------------------------------------------
;-----------------------------------------------------
;Execute shell command
;I:    none
;O:    none
;-----------------------------------------------------
_exec_cmd:
    ;Check for Empty Comamnd
    mov     si,strCmd0
    cmp     BYTE[si],00h
    je near _cmd_done
  
 
;Check for info command
    mov      si,strCmd0
    mov      di,cmdInfo
    mov      cx,5
    repe     cmpsb
    jne      _after_info
    call     _get_info
    jmp     _cmd_done
  _after_info:
   
;Check for cpuid command
    mov      si,strCmd0
    mov      di,cmdCpuid
    mov      cx,6
    repe     cmpsb
    jne      _after_cpuid
    call     _display_endl
    call     _get_cpuid
    jmp      _cmd_done
  _after_cpuid:

;Check for cls command
    mov      si,strCmd0
    mov      di,cmdCls
    mov      cx,4
    repe     cmpsb
    jne      _after_cls
    call     _display_endl
    call     _do_cls
    jmp      _cmd_done
  _after_cls:      

;Check for quote command
    mov      si,strCmd0
    mov      di,cmdQuote
    mov      cx,6
    repe     cmpsb
    jne      _after_quote
    call     _display_endl
 ;   call     _get_quote
    jmp      _cmd_done
  _after_quote:

;Check for reboot command   
    mov      si,strCmd0
    mov      di,cmdReboot
    mov      cx,7
    repe     cmpsb
    jne      _after_reboot
    jmp     _rebootpoint
    jmp     _cmd_done
  _after_reboot

;Check for color test command   
    mov      si,strCmd0
    mov      di,cmdColorTest
    mov      cx,5
    repe     cmpsb
    jne      _after_colortest
    jmp     _colortest
    jmp     _cmd_done
  _after_colortest
  
;Check if we need to run a file
	mov     si, strCmd0
	mov     di, FileNameRun
	call    _command_to_filename
	
    call _display_endl
	mov     ah, 9
	mov     dx, FileNameRun
	mov     al, 0
	mov     bx, 2000h
	int     21h
	cmp     ah, 3
	jne     _cmd_done   
;If we get here, there is no such command
  _cmd_unknown:
    call     _display_endl
    call     _unknown_cmd 
    call     _display_endl
  _cmd_done:
    ret
    
;-----------------------------------------------------
;-----------------------------------------------------
;Clear all the command strings
;I:    none
;O:    none
;-----------------------------------------------------    
_clear_commands:    
	mov     al, 255					; Clearing command strings
	mov     di, strCmd
	call    _clear_string    
	mov     al, 255					; Clearing command strings
	mov     di, strCmd0
	call    _clear_string    
	mov     al, 255					; Clearing command strings
	mov     di, strCmd1
	call    _clear_string    
	mov     al, 255					; Clearing command strings
	mov     di, strCmd2
	call    _clear_string    
	mov     al, 255					; Clearing command strings
	mov     di, strCmd3
	call    _clear_string
	mov     al, 255					; Clearing command strings
	mov     di, strCmd4
	call    _clear_string
	ret    
;----------------------------------------------------- 