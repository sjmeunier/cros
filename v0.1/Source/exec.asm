;-----------------------------------------------------
;CrOs v0.01
;Serge Meunier
;
;Internal shell commands
;-----------------------------------------------------
;
;-----------------------------------------------------
;Get OS info
;I:    none
;O:    none
;-----------------------------------------------------  
_get_info:
    call    _display_endl
    mov     si,OsName
    mov     al,0x01
    int     0x21
    call     _display_endl
    mov     si,info1
    mov     al,0x01
    int     0x21
    call     _display_endl
    mov     si,info2
    mov     al,0x01
    int     0x21
    call     _display_endl
    ret
;-----------------------------------------------------  
;-----------------------------------------------------
;Clear screen
;I:    none
;O:    none
;-----------------------------------------------------    
_do_cls:
    mov 	ah,0x06     ;this specifys we want a scroll
                        ;CH/CL specifies row & column
	    	            ;scroll region's upper left corner
    mov 	ch,0x00     ;row = 0
    mov 	cl,0x00     ;column = 0
        	            ;DH/DL does the same for lower
                        ;right corner.
    mov 	dh,0x18     ;row = 24
    mov 	dl,0x4F     ;column = 79
                 	    ;BH specifies color to fill with
    mov 	bh,0x07     ;we'll use black
           		        ;AL specifies how far to scroll
    mov 	al,0x00     ;0 means blank out entire region
    int 	10h         ;call video_io

    mov 	ah,0x02     ;position cursor function
                        ;DH/DL specifies row and column
    mov 	dh,0        ;row = 0
    mov 	dl,0        ;column = 0
                        ;BH specifies which display page
    mov 	bh,0        ;page 0
    int 	0x10        ;call video_io
    ret
;-----------------------------------------------------  
;-----------------------------------------------------
;Display unknown command error
;I:    none
;O:    none
;-----------------------------------------------------  
_unknown_cmd
    mov     si, strUnknown
    mov     al, 0x01
    int     0x21
    ret 
;-----------------------------------------------------     