.MODEL TINY

.STACK

.CODE
	mov 	ah,6h     ;this specifys we want a scroll
                          ;CH/CL specifies row & column
		          ;scroll region's upper left corner
	mov 	ch,0      ;row = 0
	mov 	cl,0      ;column = 0
        	          ;DH/DL does the same for lower
                          ;right corner.
 	mov 	dh,18h    ;row = 24
 	mov 	dl,4Fh    ;column = 79
                 	  ;BH specifies color to fill with
 	mov 	bh,7h     ;we'll use black
           		  ;AL specifies how far to scroll
 	mov 	al,0      ;0 means blank out entire region
 	int 	10h       ;call video_io

	mov 	ah,2      ;position cursor function
                          ;DH/DL specifies row and column
	mov 	dh,0      ;row = 0
    	mov 	dl,0      ;column = 0
                          ;BH specifies which display page
    	mov 	bh,0      ;page 0
    	int 	10h       ;call video_io

exit:	mov	ax,4C00h
	int	21h
	end