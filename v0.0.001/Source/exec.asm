;-----------------------------------------------------
;Execute shell command
;I:    none
;O:    none
;-----------------------------------------------------
_exec_cmd:
   ;Check for Empty Comamnd
   mov si,strCmd
   cmp BYTE[si],0x00
   je _cmd_done
  
 _cmd_ver:
   mov  si,strCmd
   mov  di,cmdInfo
   mov  cx,5
   repe cmpsb
   jne  _cmd_cpuid
   
   call _display_endl
   mov si,OsName
   mov al,0x01
   int 0x21
   call _display_space
   jmp _cmd_done
   
   _cmd_cpuid:
   mov  si,strCmd
   mov  di,cmdCpuid
   mov  cx,6
   repe cmpsb
   jne  _cmd_exit
   call _display_endl
   call _get_cpuid
   jmp  _exec_end
   
   _cmd_exit:
   mov  si,strCmd
   mov  di,cmdExit
   mov  cx,5
   repe cmpsb
   jne  _cmd_unknown
   

   
   jmp _exec_end
   
   _cmd_unknown:
   call _display_endl
   mov si,strUnknown
   mov al,0x01
   int 0x21
   
   _cmd_done:
   
   jmp _shell_begin
   _exec_end:
   ret
;-----------------------------------------------------  
  
