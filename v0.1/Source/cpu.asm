;-----------------------------------------------------
;Display CPU information
;I:    none
;O:    none
;-----------------------------------------------------
_get_cpuid:
    xor   EAX,EAX
    cpuid
    mov     DWORD [VendorSign],     EBX
    mov     DWORD [VendorSign+4],   EDX
    mov     DWORD [VendorSign+8], ECX
    mov     BYTE  [VendorSign+12],0x00
     
    mov     si,VendorSign
    mov     al,0x01
    int     0x021
    call    _display_endl
    ret
;-----------------------------------------------------
    
    

