;-----------------------------------------------------
;CrOs v0.02
;Serge Meunier
;
;Int 21 routine definitions
;-----------------------------------------------------
;
_int21h:
    cmp     ah, 00h             
    je      _int21h_00h
    cmp     ah, 01h            
    je      _int21h_01h
    cmp     ah, 02h            
    je      _int21h_02h
    cmp     ah, 03h            
    je near _int21h_03h
    cmp     ah, 04h            
    je near _int21h_04h
    cmp     ah, 05h            
    je near _int21h_05h
    cmp     ah, 06h            
    je near _int21h_06h
    cmp     ah, 07h            
    je near _int21h_07h
    cmp     ah, 08h            
    je near _int21h_08h
    cmp     ah, 09h            
    je near _int21h_09h
    cmp     ah, 0Ah            
    je near _int21h_0Ah
    cmp     ah, 0Bh            
    je near _int21h_0Bh
    cmp     ah, 0Ch            
    je near _int21h_0Ch
    cmp     ah, 0Dh            
    je near _int21h_0Dh
    cmp     ah, 0Eh            
    je near _int21h_0Eh
    cmp     ah, 0Fh            
    je near _int21h_0Fh
    cmp     ah, 10h          
    je near _int21h_10h

    
    
    jmp     _int21h_end         ;goto next check (now it is end)



;-----------------------------------------------------
;service 00h
;exit program to OS
;I:    ah    0    
;O:    none
;-----------------------------------------------------
_int21h_00h:

	mov     bx, 1
	push    word 0050h
	push    word 0000h

	iret

;-----------------------------------------------------
;Service 01h
;Display a string on screen
;I:    si    address of first char of null terminated string
;      bl    text color
;O:    none
;-----------------------------------------------------
_int21h_01h:               ;service 01h

  _int21h_01h_start:
    lodsb                       ; load next character
    or      al, al              ; test for NUL character
    jz      _int21h_01h_end
    mov     ah, 0x0E            ; BIOS teletype
    mov     bh, 0x00            ; display page 0
    int     0x10                ; invoke BIOS
    jmp     _int21h_01h_start
    
  _int21h_01h_end:
    iret


;-----------------------------------------------------
;service 02h
;Read a string on screen
;I:    di    destination address
;      ah    02h
;O:    di
;-----------------------------------------------------
_int21h_02h:
	mov     dx, di		    ; Offset merken
	cld		    			; Position 1, Eingabe von links
							; nach rechts

  int21h_ah2_1:

	xor     ah, ah
	int     16h				; Auf Tastendruck warten
	mov     ch, ah			; Scancode nach DH kopieren
	cmp     al, 8			; Wurde Backspace eingegeben?
	je     int21h_ah2_2		; Wenn ja dann ein Sprung
	mov     ah, 0Eh			; Funktion Zeichenschreiben
	mov     bh, 0			; Bildschirmseite 0
	int     10h				; Zeichen auf dem Bildschirm ausgeben
	stosb	    			; Zeichen in den String schreiben
	cmp     ch, 1Ch			; Enter oder Return?
	jne     int21h_ah2_1	; Wenn nicht dann neuer Durchlauf
	mov     al, 0			; Null terminieren
	stosb		    		; Zeichen in den String schreiben
	iret

  int21h_ah2_2:

	cmp     di, dx			; Anfang des Strings?
	je      int21h_ah2_1	; Wenn ja dann Rücksprung
	dec     di				; DI = DI - 1
	mov     al, 8			; Backspace
	mov     ah, 0Eh			; Funktion Zeichenschreiben
	mov     bx, 0			; Bildschirmseite 0
	int     10h				; Zeichen schreiben
	mov     al, 32			; Leerzeichen
	mov     ah, 0Eh			; Funktion Zeichenschreiben
	mov     bx, 0			; Bildschirmseite 0
	int     10h				; Zeichen schreiben
	mov     al, 8			; Backspace
	mov     ah, 0Eh			; Funktion Zeichenschreiben
	mov     bx, 0			; Bildschirmseite 0
	int     10h				; Zeichen schreiben
	jmp     int21h_ah2_1	; Rücksprung	

;-----------------------------------------------------
;service 03h
;Get version info
;I:    ah    03h
;O:    al    major version
;      ah    minor version
;      bl    revision
;      cl    century
;      ch    year
;      dl    month
;      dh    day
;-----------------------------------------------------
_int21h_03h:
	mov al, 0			; major version
	mov ah, 0			; minor version
	mov bl, 3			; Revision
	mov bh, 0			; set to zero

	mov cl, 20			; 200
	mov ch, 02			; CL + 3
	mov dl, 1			; Jan
	mov dh, 25			; 25
		
	iret
;-----------------------------------------------------
;Clear screen
;I:    ah    04h
;O:    none
;-----------------------------------------------------
_int21h_04h:
	pusha

	mov ah, 6			; Funktion 6
	mov al, 0			; CLS
	mov bh, 7			; Grau auf Schwarz
	xor cx, cx			; Zeile und Spalte (0:0)
	mov dh, 80			; Zeilen
	mov dl, 80			; Spalten = (80:80)
	int 10h				; Interrupt 10h
	mov ah, 2			; Cursor versetzten
	xor bh, bh			; Bildschirmseite 0
	xor dh, dh			; Zeile 0
	xor dl, dl			; Spalte 0
	int 10h				; Interrupt 10h

	popa
	iret
;-----------------------------------------------------
;Reboot machine
;I:    ah    05
;      al    0    Fast reboot
;            1    Cold reboot
;            2    Warm reboot
;            3    Shut down
;O:    none
;-----------------------------------------------------
_int21h_05h:
	cmp     al, 0
	je      int21h_ah5_0
	cmp     al, 1
	je      int21h_ah5_1
    cmp     al, 2
	je      int21h_ah5_2
	cmp     al, 3
	je      int21h_ah5_3

	stc
	mov     ah, 1
	iret

  int21h_ah5_0:
	int     19h			; fast boot
	iret

  int21h_ah5_1:
	mov     ax, 0040h		; cold boot
	mov     es, ax		
	mov     WORD [es:00072h], 0h
	jmp     0FFFFh:0000h
	iret

  int21h_ah5_2:
	mov     ax, 0040h		; warm boot
	mov     es, ax		
	mov     WORD [es:00072h], 01234h
	jmp     0FFFFh:0000h
	iret

  int21h_ah5_3:
	mov     ax, 5300h		; Fährt einen APM Rechner her-
	xor     bx, bx		    ; unter neuere Rechner schalten  
	int     15h		    	; sich automatisch ab
	mov     ax, 5304h				
	xor     bx, bx
	int     15h			    ; Der Interrupt 15h wurde ur-
	mov     ax, 5301h		; sprünglich für Kassetten ver-
	xor     bx, bx		    ; wendet, wird jedoch heute für
	int     15h			    ; die verschiedensten Anwendungs-
	mov     ax, 5307h		; bereiche gebraucht
	mov     bx, 1
	mov     cx, 3
	int     15h				
	iret
;-----------------------------------------------------
;Keypress value
;I:    ah    06h
;O:    al    ASCII value
;      ch    Scancode    
;-----------------------------------------------------
_int21h_06h:
	xor ah, ah			; Funktion 0
	int 16h				; Warte auf Tastendruck

	mov ah, 11
	int 21h

	iret
;-----------------------------------------------------
;Convert word value to byte value
;I:    ah    07h
;      bx    word value < 258
;O:    bl    byte value
;-----------------------------------------------------
_int21h_07h:
	cmp     bx, 257			; ist es überhaupt eine 8 Bit Zahl?
	jb      int21h_ah7_1

	stc				; Fehler
	mov     ah, 2			; Fehlernummer 2 (Falscher Typ)
	iret

  int21h_ah7_1:
	mov     [intDummy], bx
	xor     bx, bx
	mov     bl, [intDummy]
	iret
;-----------------------------------------------------
;Convert byte value to word value
;I:    ah    08h
;      bl    byte value 
;O:    bx    word value
;-----------------------------------------------------
_int21h_08h:
	push cx				; CX sichern
	xor cx, cx			; CX = 0
	mov cl, bl			; CX = BL
	xor bx, bx			; BX = 0
	mov bx, cx			; BX = CX
	pop cx				; CX zurück
	iret
;-----------------------------------------------------
;Read data from file
;I:    ah    09h
;      bx    segment 
;      al    laufwerk
;      dx    dateiname 
;O:    bx    
;-----------------------------------------------------
_int21h_09h:

	MOV [File_Name_Add], DX
	MOV BYTE [DriveNumber], AL
	MOV [TSegment], CX
	MOV [Rec_Segment], BX

	XOR CX, CX				; Errechne die Länge des 
							; Hauptverzeichnisses
	XOR DX, DX
	MOV AX, 32				; Ein Eintrag hat 32 Bytes
	MUL WORD [RootEntries]			; Maximale Größe des Root
	DIV WORD [BytesPerSector]		; Anzahl der zu ladenen Sektoren
							; errechnen
	XCHG AX, CX				; AX = CX; CX = AX(alt)



	MOV AL, BYTE [FATTables]		; Errechne die Position des Roots
							; und schreibe es in AX
	MUL WORD [FATTableSize]			; Größe der FAT
	ADD AX, WORD [ReservedSectors]		; für den Bootsector (?)
	MOV WORD [DataSector], AX		; Rootverzeichnis
	ADD WORD [DataSector], CX

	MOV BX, 0x1200				; Lade das ROOT DIR nach 0x020
	CALL ReadSectors

	MOV CX, WORD [RootEntries]		; Suche nach der Datei
	MOV DI, 0x1200				; Suche von Anfang an

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Suche die Datei
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.LOOP:
    PUSH CX
    MOV CX, 11				; 11 Zeichen pro Dateiname

    PUSH AX

    MOV AX, [File_Name_Add]
    MOV SI, AX

    POP AX

    PUSH DI
		
    REP CMPSB				; Vergleiche Dateinamen <> RootDIR

    POP DI
    JE SHORT LOAD_FAT			; Dateigefunden?
    POP CX
    ADD DI, 32				; Nächster Eintrag

    LOOP .LOOP				; Schleife

    JMP FAILURE
                    
  LOAD_FAT:
    MOV DX, WORD [DI+0x001A]
    MOV WORD [Cluster], DX          	; Erster Cluster der Datei
    XOR AX, AX              		; Errechne die Größe von FAT
                               		; und schreibe es in CX
    MOV AL, BYTE [FATTables]        	; Anzahl der FATs
    MUL WORD [FATTableSize]         	; Gebrauchte Sektoren
    MOV CX, AX
    MOV AX, WORD [ReservedSectors]      ; Bootsektor
    MOV BX, 0x1200
    Call ReadSectors

    MOV AX, [Rec_Segment]
				
    MOV ES, AX				; Quelle für das Image
    XOR BX, BX
    PUSH BX

  LOAD_IMAGE:
    MOV AX, WORD [Cluster]          	; Zu ladener Cluster
    POP BX
    CALL ClusterLBA             	; Cluster in LBA
    XOR CX, CX
    MOV CL, BYTE [SectorsPerCluster]    ; Anzahl d. zu ladenen 
							; Sektoren
    Call ReadSectors
    PUSH BX
                    
    MOV AX, WORD [Cluster]          	; ermittle aktuellen 
								; Cluster
    MOV CX, AX              		; kopieren
    MOV DX, AX              		; kopieren
    SHR DX, 0x0001			; durch 2 teilen
    ADD CX, DX				; (3/2)
    MOV BX, 0x1200			; FAT im Speicher

    ADD BX, CX				; Index in der FAT
    MOV DX, WORD [BX]			; Lese 2 Bytes der FAT
    TEST AX, 0x0001
    JNZ .ODD_CLUSTER
                    
  .EVEN_CLUSTER:
    AND DX, 0000111111111111b		; 12 Low Bits
    JMP .DONE
                    
  .ODD_CLUSTER:
    SHR DX, 4				; 12 High Bits
                            
  .DONE:
    MOV WORD [Cluster], DX
    CMP DX, 0x0FF0			; Ende des Files?
    JB LOAD_IMAGE
                    
  DONE:
    MOV AX, [Rec_Segment]

    PUSH WORD AX
    PUSH WORD 0x0000

    MOV AH, 0
    CLC

    IRET
                    
  FAILURE:
    MOV AH, 3				; Datei nicht gefunden
    STC
    IRET
                    
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Sektor öffnen
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ReadSectors:
 .MAIN
	;MOV AX, DS
	;PUSH AX

    MOV DI, 0x0005              	; 5 Versuche vor 
	                                ; einem Fehler
  .SECTORLOOP
    PUSH AX
    PUSH BX
    PUSH CX
                    
    Call LBACHS
                    
    MOV AH, 2               		; Sektor lesen
    MOV AL, 1               		; 1 Sektor
    MOV CH, BYTE [absoluteTrack]        ; Spur
    MOV CL, BYTE [absoluteSector]       ; Sektor
    MOV DH, BYTE [absoluteHead]     	; Kopf
    MOV DL, BYTE [DriveNumber]      	; Laufwerk
    INT 13h
                    
    JNC .SUCCESS
    XOR AX, AX              		; AH = 0; Disk Reset
    INT 13h
    DEC DI
    POP CX
    POP BX
    POP AX
    JNZ .SECTORLOOP             	; weiterer Versuch
    Call Point
    RET
 
 .SUCCESS
    POP CX
    POP BX
    POP AX
    ADD BX, WORD [BytesPerSector]
    INC AX
    LOOP .MAIN


   RET
                    
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; ClusterLBA
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    
  ClusterLBA:
    SUB AX, 2               		; 0-basierte Sektornummer
    XOR CX, CX
    MOV CL, BYTE [SectorsPerCluster]    ; BYTE > WORD
    MUL CX
    ADD AX, WORD [DataSector]
    RET
                    
                    
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; LBACHS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 LBACHS:
    XOR DX, DX              		; DX, AX vorbereiten
    DIV WORD [SectorsPerTrack]      	; rechne...
    INC DL                  		; für Sektor 0
    MOV BYTE [absoluteSector], dl
    XOR DX, DX              		; DX, AX vorbereiten
    DIV WORD [DriveHeads]           	; rechne...
    MOV BYTE [absoluteHead], DL
    MOV BYTE [absoluteTrack], al
    RET
                  
	IRET

;-----------------------------------------------------
;Send keystroke
;I:    ah    0Ah
;O:    ax    
;-----------------------------------------------------
_int21h_0Ah:
	xor     ax, ax
	int     16h
	iret
;-----------------------------------------------------
;Print character
;I:    ah    0Bh
;      al char code
;O:    none   
;-----------------------------------------------------
_int21h_0Bh:
	pusha
	mov     ah, 0x0E			; Bildschirmausgabe
	mov     bh, 0
	mov     bl, 7
	int     10h
	popa
	iret
;-----------------------------------------------------
;Convert WORD to string
;I:    ah    0Ch
;	   BX = Zahl
;	   DI = Ausgabestring
;O:    di   
;-----------------------------------------------------
_int21h_0Ch:
	PUSH AX				; Register sichern
	PUSH BX
	PUSH CX
	PUSH DX
	MOV SI, DI			; DI nach SI
	MOV AX, BX			; Zahl nach AX kopieren (BX = Offset)
	OR AX, AX
	JNZ @s1				; Wenn das Zeroflag (ZF) NICHT gesetzt ist,
    					; dann spring zu @s1
	MOV BYTE [SI], 48		; 48 = "0" (ASCI)
	INC SI				; SI = SI + 1
	JMP SHORT @fertig		; Zahl wurde ermittelt (= 0)
  @s1:
	MOV CX, 5
	MOV BX, 10000
	XOR DI, DI			; DI = 0
  @nochmal:
	XOR DX, DX		; DX = 0
	DIV BX			; AX / BX
	OR DI, DI
	JNZ @s4			; Wenn das ZF NICHT gesetzt ist, dann @s4			
	OR AL, AL
	JZ @s5			; Wenn das ZF gesetzt ist, dann @s5			
  @s4:
	ADD AL, 48		; AL in ein ASCI Zeichen umwandeln
	MOV [SI], AL		; AL in den String schreiben
	INC SI			; SI = SI + 1
	INC DI			; DI = DI + 1
  @s5:
	PUSH DX			; DX sichern
	MOV AX, BX		; AX = BX
	XOR DX, DX		; DX = 0
	MOV BX, 10
	DIV BX			; AX / 10
	MOV BX, AX		; BX = AX
	POP AX			; den gesicherten Wert von DX nach AX schreiben
    LOOP @nochmal			; Schleife noch mal
  @fertig:
	MOV BYTE [SI], 0		; Null Terminieren
	POP DX				; Register zurückholen
	POP CX
	POP BX
	POP AX
	IRET
;-----------------------------------------------------
;Convert string to WORD
;I:    ah    0Dh
;	   SI = String
;O:    bx
;-----------------------------------------------------
_int21h_0Dh:
		
	xor     dx, dx				; DX = 0
	xor     bx, bx				; BX = 0
	mov     cl, 10				; Für die Multiplikation vorbereiten

  int21h_ah13_1:
	lodsb			        	; Lädt das aktuelle Zeiche in AL
	cmp     al, 0			    ; wurde das Ende des Strings erreicht?
	jz     int21h_ah13_2
	cmp     al, 48			    ; Wenn AL >= "0" und <= "9" ist
	jb     int21h_ah13_3		; Fehler! Ungültige Zahl
	cmp     al, 57
	ja     int21h_ah13_3		; Fehler! Ungültige Zahl
	sub     al, 48		    	; Aktuelles Zeichen von ASCI in INT
	mov     dl, al		    	; AL kopieren
	mov     ax, bx			    ; BX nach AX
	mul     cl			    	; AX * CL (CL = 10), Ergebnis in AX
	add     ax, dx			    ; AX + DX
	mov     bx, ax		    	; BX nach AX
	jmp     int21h_ah13_1		; Nächster Durchlauf
  
  int21h_ah13_2:
	mov     ax, 0
	iret

  int21h_ah13_3:
	mov     ax, 1			    ; AX = 1, aber Fehler!
	iret
;-----------------------------------------------------
;Get system information
;I:    ah    0Eh
;O:    ax    convential memory (KB)
;      bl    1 = Protected mode
;            0 = Real mode
;      cx    free memory  
;-----------------------------------------------------
_int21h_0Eh:
    int     12h

	push    ax

	mov     eax, cr0			; CR0 nach EAX	
	and     al, 1			; Ist Protected Mode gesetzt?
	jnz     int21h_ah14_1
	mov     bl, 0

	jmp     int21h_ah14_2

  int21h_ah14_1:
	mov     bl, 1		; PMode

  int21h_ah14_2:
	mov     ah, 88h			; Funktion 88h
	int     15h				; Interrupt 15h -> Ermittelt den Erweiterungs-
						; speicher
	mov     cx, ax
	pop     ax
	iret
;-----------------------------------------------------
;Get processor information
;I:    ah    0Fh
;O:    AL    1h = Pentium
;		     2h = P Pro, P II, P Celeron, P 4
;		     3h = P 3
;		     4h = unknown 
;-----------------------------------------------------
_int21h_0Fh:
	xor     eax, eax
	mov     eax, 0h
	CPUID

	cmp     eax, 1h
	je      int21h_ah15_1
	cmp     eax, 2h
	je      int21h_ah15_2
	cmp     eax, 3h
	je      int21h_ah15_3
	jmp     int21h_ah15_4

  int21h_ah15_1:
	mov     al, 1h
	jmp     int21h_ah15_5
			
  int21h_ah15_2:
	mov     al, 2h
	jmp     int21h_ah15_5

  int21h_ah15_3:
	mov     al, 3h
	jmp     int21h_ah15_5
		
  int21h_ah15_4:
	mov     al, 4h
	jmp     int21h_ah15_5

  int21h_ah15_5:
	iret

;-----------------------------------------------------
;Get processor information
;I:    ah    10h
;      BX    Speicher Segment Start
;	   CX    Speicher Segment Größe
;	   DH    Typ
;	   SI    Name des Programms
;O:	   AX    Prozessnummer 
;-----------------------------------------------------
_int21h_10h:
		; Lese die Anzahl der Prozesse ein:
	mov     ax, 500h		; Speicherstelle 500h
	mov     si, ax
	mov     ax, [si]
	mov     [Nums_Of_Procedures], ax

			; Start des Speicherdatenblock @ SI:510h
	mov     si, 510h
			
			; Ein leerer Datenblock hat die PID = 0

			; 2 Byte PID
			; 2 Byte Start
			; 2 Byte Größe
			; 11 Byte Name
			; 1 Byte Typ (0=Anwendung,1=System,2=Dienst)
			; 14 Byte Rest

			
  int21h_ah16_loop1:
	lodsw
	cmp     ax, 0
	je      int21h_ah16_1
	add     si, 30	; 32 Einträge insgesamt
	jmp     int21h_ah16_loop1

  int21h_ah16_1:

			; Leerer Block wurde gefunden
	mov     ax,0 
	iret 


;-----------------------------------------------------
 _int21h_end:
    iret
;-----------------------------------------------------
;-----------------------------------------------------
;Read data from file
;I:    none
;O:    none   
;-----------------------------------------------------    
Point:
	pusha

    mov     al, '|'
	mov     ah, 0x0E				; Bildschirmausgabe
	mov     bh, 0
	mov     bl, 7
	int     10h	

	popa

	ret
    