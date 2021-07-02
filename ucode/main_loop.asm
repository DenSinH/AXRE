main_entry: ; 0x10
IRAM:0010                 SBSET          2
IRAM:0011                 SBSET          3
IRAM:0012                 SBCLR          4
IRAM:0013                 SBSET          5
IRAM:0014                 SBSET          6
IRAM:0015                 SET16
IRAM:0016                 CLR15
IRAM:0017                 M0
IRAM:0018                 LRI            $CR, 0xFF
IRAM:001A                 CLR            $ACC0
IRAM:001B                 CLR            $ACC1
IRAM:001C                 LRI            $AC0.M, 0xE80
IRAM:001E                 SR             byte_E1B, $AC0.M
IRAM:0020                 CLR            $ACC0
IRAM:0021                 SR             byte_E31, $AC0.M
IRAM:0023 ; send initial mail (0x8000dcd1)
IRAM:0023                 SI             ToCPUMailHi, 0xDCD1
IRAM:0025                 SI             ToCPUMailLo, 0
IRAM:0027                 SI             DIRQ, 1
IRAM:0029
IRAM:0029 wait_for_mail:                          ; CODE XREF: main_entry+1C↓j
IRAM:0029                 LRS            $AC0.M, ToCPUMailHi
IRAM:002A                 ANDF           $AC0.M, 0x8000
IRAM:002C                 JLNZ           wait_for_mail
IRAM:002E                 JMP            mail_sent
IRAM:0030 ; ---------------------------------------------------------------------------
IRAM:0030
IRAM:0030 send_dcd10001_irq:                      ; CODE XREF: j_send_dcd10001_irq↓j
IRAM:0030                 SBSET          2
IRAM:0031                 SBSET          3
IRAM:0032                 SBCLR          4
IRAM:0033                 SBSET          5
IRAM:0034                 SBSET          6
IRAM:0035                 SET16
IRAM:0036                 CLR15
IRAM:0037                 M0
IRAM:0038                 LRI            $CR, 0xFF
IRAM:003A                 SI             ToCPUMailHi, 0xDCD1
IRAM:003C                 SI             ToCPUMailLo, 1
IRAM:003E                 SI             DIRQ, 1
IRAM:0040
IRAM:0040 wait_for_mail_sent:                     ; CODE XREF: main_entry+33↓j
IRAM:0040                 LRS            $AC0.M, ToCPUMailHi
IRAM:0041                 ANDF           $AC0.M, 0x8000
IRAM:0043                 JLNZ           wait_for_mail_sent
IRAM:0045
IRAM:0045 mail_sent:                            ; CODE XREF: main_entry+1E↑j
IRAM:0045                                         ; IRAM:0482↓j ...
IRAM:0045                 SET16
IRAM:0046                 CLR            $ACC0
IRAM:0047                 CLR            $ACC1
IRAM:0048                 LRI            $AC1.M, 0xBABE
IRAM:004A
IRAM:004A wait_for_babe:                          ; CODE XREF: main_entry+3D↓j
IRAM:004A                                         ; main_entry+40↓j
IRAM:004A                 LRS            $AC0.M, FromCPUMailHi
IRAM:004B                 ANDCF          $AC0.M, 0x8000
IRAM:004D                 JLNZ           wait_for_babe
IRAM:004F                 CMP
IRAM:0050                 JNZ            wait_for_babe
IRAM:0052 ; AX1.H contains the low part of the babe mail
IRAM:0052 ; this holds the DMA length
IRAM:0052                 LRS            $AX1.H, FromCPUMailLo
IRAM:0053                 CLR            $ACC0
IRAM:0054 ; wait for DMA mm address to be sent over mail
IRAM:0054 ; mail lo -> ac1 -> addr lo
IRAM:0054 ; mail hi -> ac0 -> addr hi
IRAM:0054
IRAM:0054 wait_for_dma_mm_addr:                   ; CODE XREF: main_entry+47↓j
IRAM:0054                 LRS            $AC0.M, FromCPUMailHi
IRAM:0055                 ANDCF          $AC0.M, 0x8000
IRAM:0057                 JLNZ           wait_for_dma_mm_addr
IRAM:0059                 LRS            $AC1.M, FromCPUMailLo
IRAM:005A                 ANDI           $AC0.M, 0x7FFF
IRAM:005C ; start the DMA
IRAM:005C ; length from babe mail
IRAM:005C ; mm address from second mail
IRAM:005C ; DMA control 0: to DSP DMEM
IRAM:005C                 SRS            DMAMMADDRH, $AC0.M
IRAM:005D                 SRS            DMAMMADDRL, $AC1.M
IRAM:005E                 SI             DMADSPADDR, 0xC00
IRAM:0060                 CLR            $ACC0
IRAM:0061                 SRS            DMAControl, $AC0.M ; set DMA control to 0
IRAM:0062                 MRR            $AC1.M, $AX1.H
IRAM:0063                 SRS            DMALength, $AC1.M
IRAM:0064                 CALL           wait_for_dma_finish_0
IRAM:0066                 LRI            $AR0, 0xC00
IRAM:0068
IRAM:0068 ; at the start of the commands:
IRAM:0068 ; ar0: word* cmd_stream_ptr
IRAM:0068
IRAM:0068 receive_command:                        ; CODE XREF: command_0:cmd0_done↓j
IRAM:0068                                         ; command_1+1F↓j ...
IRAM:0068                 SET16
IRAM:0069                 CLR            $ACC0
IRAM:006A                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:006B                 TST            $ACC0
IRAM:006C ; check current stream word
IRAM:006C ; jump if less than (top bit set, invalid command)
IRAM:006C                 JL             bad_mail
IRAM:006E                 LRIS           $AX0.H, 0x12
IRAM:006F                 CMPAR          $ACC0, $AX0.H
IRAM:0070 ; jump if word > 0x12
IRAM:0070                 JG             bad_mail
IRAM:0072 ; ar3 : addr = word + 0xaff // command_jump_table
IRAM:0072 ; ar3 : ac0.m : call_addr = [addr++]
IRAM:0072 ; jump call_addr
IRAM:0072                 LRI            $AC1.M, 0xAFF ; command_jump_table
IRAM:0074                 ADD            $ACC0, $ACC1 ; first word += 0xaff
IRAM:0075                 MRR            $AR3, $AC0.M
IRAM:0076                 ILRR           $AC0.M, @$AR3
IRAM:0077                 MRR            $AR3, $AC0.M
IRAM:0078                 JMPR           $AR3
IRAM:0079 ; ---------------------------------------------------------------------------
IRAM:0079 ; 0x8080FBAD mail [UNUSED]
IRAM:0079                 SI             ToCPUMailHi, 0xFBAD
IRAM:007B                 SI             ToCPUMailLo, 0x8080
IRAM:007D                 HALT
IRAM:007E ; ---------------------------------------------------------------------------
IRAM:007E
IRAM:007E bad_mail:                               ; CODE XREF: main_entry+5C↑j
IRAM:007E                                         ; main_entry+60↑j
IRAM:007E                 SI             ToCPUMailHi, 0xBAAD
IRAM:0080                 SRS            ToCPUMailLo, $AC0.M
IRAM:0081                 HALT
IRAM:0081 ; End of function main_entry