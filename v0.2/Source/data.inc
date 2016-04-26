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

   FileNameRun	TIMES 11 DB 0
   strCmd0     TIMES 256 DB 0     ;buffers for the command components
   strCmd1     TIMES 256 DB 0
   strCmd2     TIMES 256 DB 0
   strCmd3     TIMES 256 DB 0
   strCmd4     TIMES 256 DB 0
   strCmd      TIMES 256 DB 0
;Status stuff
   Buffer 	times 10 db 0
	MSG_PhyMemory	db	'Physical Memory (in KB) : ',0
	MSG_ExtMemory	db	'Extended Memory (in KB) : ',0
	MSG_PCMode	db	'Systemmode              : ',0
	MSG_CPUInfo	db	'CPU ID Info             : ',0

	MSG_PMode	db	'Protected Mode',0
	MSG_RMode	db	'Real Mode',0


	CPU_1		db	'Intel (R) Pentium (R) Processor',0
	CPU_2		db	'Intel (R) Pentium (R) Pro/II/Celeron/P4',0
	CPU_3		db	'Intel (R) Pentium (R) 3',0
	CPU_4		db	'unknown CPU',0

;int 21h stuff
   absoluteSector      	DB  	0x00
   absoluteHead        	DB  	0x00
   absoluteTrack       	DB  	0x00
                    
   Cluster         	DW	0x0000
   ImageName 		DB	'TEST    BIN'
                    
   BytesPerSector      	DW	512 
   SectorsPerCluster   	DB	1 
   ReservedSectors     	DW	1
   FATTables       	DB	2
   RootEntries     	DW	224     	
   CountSectors       	DW	2880
   DiskMediaType      	DB	240
   FATTableSize        	DW	9
   SectorsPerTrack     	DW	18
   DriveHeads      	DW	2
   HiddenSectors       	DD	0
   LGSectors       	DD	0
   DriveNumber     	DB	0
   NTDrtyFlg       	DB	0
   ExBPSign        	DB	29h
   SerialNumber        	DD	0
   TSegment	        DW	0
   Rec_Segment		DB	0

   Shell_Fname		DB	'TEST    BIN'
   File_Name_Add	DW	0

   DataSector		DW	0

   MSG_CommandP		DB	13,10,'[CMD]>',0

   InputString	TIMES 8 DB 0
   FileName	TIMES 11 DB 0

   CRLF			DB	13,10,0
   Nums_Of_Procedures	db	0
   
[segment .bss]

   nCmdSize    resb 1
   VendorSign  resb    13
   rndseed     resw 1


;Int 21h variables	
   intDummy    resb 1

   
   
