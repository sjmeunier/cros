[segment .data]
   strwelcome db "Crazy-OS 0.0.001", 0x0D, 0x0A, "Greetings, O Wise User.", 0x00
   strPrompt  db "CrOS->>",0x00
   cmdLen     db 255
   OsName     db "Crazy-OS 0.0.001",0x00
   
   cmdInfo     db "info",0x00
   cmdExit     db "exit",0x00
   strUnknown  db "Ummm...I don't know that one!",0x00
   cmdCpuid    db "cpuid",0x00
   
   
   logo1 db "Written by Serge Meunier",0x00
   logo2 db "January 2003", 0x00




   
[segment .bss]
   strCmd     resb 256
   nCmdSize   resb 1
   strCmd0     resb    256     ;buffers for the command components
   strCmd1     resb    256
   strCmd2     resb    256
   strCmd3     resb    256
   strCmd4     resb    256
   VendorSign  resb    13

   
   
