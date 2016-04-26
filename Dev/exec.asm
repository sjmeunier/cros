;-----------------------------------------------------
;CrOs v0.02
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
    call _display_string
    call     _display_endl
    mov     si,info1
    call _display_string
    call     _display_endl
    mov     si,info2
    call _display_string
    call     _display_endl
    ret
;-----------------------------------------------------  
;-----------------------------------------------------
;Clear screen
;I:    none
;O:    none
;-----------------------------------------------------    
_do_cls:
    mov 	ah,06h      ;this specifys we want a scroll
                        ;CH/CL specifies row & column
	    	            ;scroll region's upper left corner
    mov 	ch,00h      ;row = 0
    mov 	cl,00h      ;column = 0
        	            ;DH/DL does the same for lower
                        ;right corner.
    mov 	dh,18h      ;row = 24
    mov 	dl,4Fh      ;column = 79
                 	    ;BH specifies color to fill with
    mov 	bh,07h      ;we'll use black
           		        ;AL specifies how far to scroll
    mov 	al,00h      ;0 means blank out entire region
    int 	10h         ;call video_io

    mov 	ah,02h      ;position cursor function
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
    mov     bl, 04h
    call _display_string_col
    ret 
;-----------------------------------------------------     