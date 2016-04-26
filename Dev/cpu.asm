;-----------------------------------------------------
;CrOs v0.02
;Serge Meunier
;
;Display procedures
;-----------------------------------------------------
;
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
    mov     BYTE  [VendorSign+12],00h
     
    mov     si, VendorSign
    mov     ah, 01h
    int     21h
    call    _display_endl
    ret
;-----------------------------------------------------
    
    

