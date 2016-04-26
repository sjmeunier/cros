[segment .data]
   strWelcome     db "Greetings, O Wise User.", 0x00
   strPrompt      db "CrOS->>",0x00
   cmdLen         db 255
   OsName         db "Crazy-OS 0.01",0x00
   
   cmdInfo        db "info",0x00
   cmdReboot      db "reboot",0x00
   cmdCpuid       db "cpuid",0x00
   cmdCls	  db "cls",0x00
   cmdQuote	  db "quote", 0x00
   strUnknown     db "Ummm...I don't know that one!",0x00
   
   
   info1          db "Written by Serge Meunier",0x00
   info2          db "January 2003", 0x00


   file_asciiz    db "quote.dat", 0x00


   
[segment .bss]
   strCmd      resb 256
   nCmdSize    resb 1
   strCmd0     resb    256     ;buffers for the command components
   strCmd1     resb    256
   strCmd2     resb    256
   strCmd3     resb    256
   strCmd4     resb    256
   VendorSign  resb    13
   file_path   resb    50
   rndseed     resw 1	
 

   
   
