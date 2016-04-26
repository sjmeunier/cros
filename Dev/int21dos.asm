;-----------------------------------------------------
;CrOs v0.02
;Serge Meunier
;
;Int 21 DOS compatible routine definitions
;-----------------------------------------------------
;
_int21h:

do00	DW OFFSET error_dos
do01	DW OFFSET dos_read_key_echo
do02	DW OFFSET dos_write_char
do03	DW OFFSET error_dos
do04	DW OFFSET error_dos
do05	DW OFFSET error_dos
do06	DW OFFSET dos_con_io
do07	DW OFFSET dos_read_key
do08	DW OFFSET dos_read_key
do09	DW OFFSET display_string
do0A	DW OFFSET key_io
do0B	DW OFFSET dos_key_state
do0C	DW OFFSET dos_io_flush
do0D	DW OFFSET error_dos
do0E	DW OFFSET select_drive
do0F	DW OFFSET error_dos
do10	DW OFFSET error_dos
do11	DW OFFSET error_dos
do12	DW OFFSET error_dos
do13	DW OFFSET error_dos
do14	DW OFFSET error_dos
do15	DW OFFSET error_dos
do16	DW OFFSET error_dos
do17	DW OFFSET error_dos
do18	DW OFFSET error_dos
do19	DW OFFSET get_drive
do1A	DW OFFSET set_dta
do1B	DW OFFSET error_dos
do1C	DW OFFSET error_dos
do1D	DW OFFSET error_dos
do1E	DW OFFSET error_dos
do1F	DW OFFSET error_dos
do20	DW OFFSET error_dos
do21	DW OFFSET error_dos
do22	DW OFFSET error_dos
do23	DW OFFSET error_dos
do24	DW OFFSET error_dos
do25	DW OFFSET set_dos_int
do26	DW OFFSET create_psp
do27	DW OFFSET error_dos
do28	DW OFFSET error_dos
do29	DW OFFSET error_dos
do2A	DW OFFSET get_system_date
do2B	DW OFFSET set_system_date
do2C	DW OFFSET get_system_time
do2D	DW OFFSET set_system_time
do2E	DW OFFSET error_dos
do2F	DW OFFSET get_dta
do30	DW OFFSET dos_version
do31	DW OFFSET keep_process
do32	DW OFFSET error_dos
do33	DW OFFSET control_c_check
do34	DW OFFSET get_indos_flag
do35	DW OFFSET get_dos_int
do36	DW OFFSET get_drive_allocation
do37	DW OFFSET switch_char
do38	DW OFFSET country_data
do39	DW OFFSET make_dir
do3A	DW OFFSET remove_dir
do3B	DW OFFSET set_cur_dir
do3C	DW OFFSET create_handle
do3D	DW OFFSET open_handle
do3E	DW OFFSET close_handle
do3F	DW OFFSET read_handle
do40	DW OFFSET write_handle
do41	DW OFFSET delete_file
do42	DW OFFSET move_pointer
do43	DW OFFSET file_attribute
do44	DW OFFSET ioctl
do45	DW OFFSET dupl_handle
do46	DW OFFSET force_dupl_handle
do47	DW OFFSET get_cur_dir
do48	DW OFFSET allocate_memory
do49	DW OFFSET free_memory
do4A	DW OFFSET resize_memory
do4B	DW OFFSET load_program
do4C	DW OFFSET end_program
do4D	DW OFFSET exit_code
do4E	DW OFFSET find_first
do4F	DW OFFSET find_next
do50	DW OFFSET dos_set_psp
do51	DW OFFSET dos_get_psp
do52	DW OFFSET sysvars
do53	DW OFFSET error_dos
do54	DW OFFSET error_dos
do55	DW OFFSET create_psp
do56	DW OFFSET rename_file
do57	DW OFFSET date_time_handle
do58	DW OFFSET strategy
do59	DW OFFSET error_dos
do5A	DW OFFSET error_dos
do5B	DW OFFSET error_dos
do5C	DW OFFSET error_dos
do5D	DW OFFSET dos5d
do5E	DW OFFSET error_dos
do5F	DW OFFSET error_dos
do60	DW OFFSET error_dos
do61	DW OFFSET error_dos
do62	DW OFFSET dos_get_psp
do63	DW OFFSET error_dos
do64	DW OFFSET error_dos
do65	DW OFFSET extended_country_data
do66	DW OFFSET error_dos
do67	DW OFFSET error_dos
do68	DW OFFSET error_dos
do69	DW OFFSET error_dos
do6A	DW OFFSET error_dos
do6B	DW OFFSET error_dos
do6C	DW OFFSET error_dos
do6D	DW OFFSET error_dos
do6E	DW OFFSET error_dos
do6F	DW OFFSET error_dos
doend	DW OFFSET error_dos
    iret

;-----------------------------------------------------
;service 00h
;exit program to OS (obselete)
;I:    ah    0    
;O:    none
;-----------------------------------------------------
_int21_ah00:

	mov     bx, 1
	push    word 0050h
	push    word 0000h

	iret
;-----------------------------------------------------
;-----------------------------------------------------
;service 01h
;exit program to OS (obselete)
;I:    ah    0    
;O:    none
;-----------------------------------------------------
_int21_ah01:
	ReadKeyboardSerial
	WriteChar
	and byte ptr [bp].vm_eflags, NOT 1
	iret	