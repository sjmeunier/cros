;-----------------------------------------------------
;Start up the shell and go into infinite loop
;I:    none
;O:    none
;-----------------------------------------------------
_shell:
  _shell_begin:
  call _display_endl
  call _display_prompt
  call _get_cmd
  call _exec_cmd
  jmp _shell_begin
;-----------------------------------------------------