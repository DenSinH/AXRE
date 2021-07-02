ROM:8000 ; =============== S U B R O U T I N E =======================================
ROM:8000
ROM:8000
ROM:8000 rom_start:                              ; CODE XREF: j_rom_start↑j
ROM:8000
ROM:8000 ; FUNCTION CHUNK AT ROM:80C4 SIZE 00000015 BYTES
ROM:8000
ROM:8000                 LRI            $CR, 0xFF
ROM:8002                 LRI            $SR, 0x2000
ROM:8004                 SI             ToCPUMailHi, 0x8071
ROM:8006                 SI             ToCPUMailLo, 0xFEED
ROM:8008
ROM:8008 receive_setup:                          ; CODE XREF: rom_start+19↓j
ROM:8008                                         ; rom_start+24↓j ...
ROM:8008                 CLR            $ACC1
ROM:8009                 CLR            $ACC0
ROM:800A                 CALL           wait_for_mail
ROM:800C                 LR             $AC1.M, FromCPUMailLo
ROM:800E                 LRI            $AC0.M, 0xA001
ROM:8010                 CMP
ROM:8011 ; if (mail.lo != 0xa001) jump -> check_c002
ROM:8011                 JNZ            check_c002
ROM:8013                 CALL           wait_for_mail
ROM:8015                 LR             $IX0, FromCPUMailHi
ROM:8017                 LR             $IX1, FromCPUMailLo
ROM:8019                 JMP            receive_setup
ROM:801B ; ---------------------------------------------------------------------------
ROM:801B
ROM:801B check_c002:                             ; CODE XREF: rom_start+11↑j
ROM:801B                 LRI            $AC0.M, 0xC002
ROM:801D                 CMP
ROM:801E ; if (mail.lo != 0xc002) jump -> check_a002
ROM:801E                 JNZ            check_a002
ROM:8020                 CALL           wait_for_mail
ROM:8022                 LR             $IX2, FromCPUMailLo
ROM:8024                 JMP            receive_setup
ROM:8026 ; ---------------------------------------------------------------------------
ROM:8026
ROM:8026 check_a002:                             ; CODE XREF: rom_start+1E↑j
ROM:8026                 LRI            $AC0.M, 0xA002
ROM:8028                 CMP
ROM:8029 ; if (mail.lo != 0xa002) jump -> check_b002
ROM:8029                 JNZ            check_b002
ROM:802B                 CALL           wait_for_mail
ROM:802D                 LR             $IX3, FromCPUMailLo
ROM:802F                 JMP            receive_setup
ROM:8031 ; ---------------------------------------------------------------------------
ROM:8031
ROM:8031 check_b002:                             ; CODE XREF: rom_start+29↑j
ROM:8031                 LRI            $AC0.M, 0xB002
ROM:8033                 CMP
ROM:8034 ; if (mail.lo != 0xb002) jump -> check_d001
ROM:8034                 JNZ            check_d001
ROM:8036                 CALL           wait_for_mail
ROM:8038                 LR             $AX0.L, FromCPUMailLo
ROM:803A                 JMP            receive_setup
ROM:803C ; ---------------------------------------------------------------------------
ROM:803C
ROM:803C check_d001:                             ; CODE XREF: rom_start+34↑j
ROM:803C                 LRI            $AC0.M, 0xD001
ROM:803E                 CMP
ROM:803F                 JNZ            receive_setup
ROM:8041                 CALL           wait_for_mail
ROM:8043                 LR             $AR0, FromCPUMailLo
ROM:8045                 JMP            transfer_ucode
ROM:8045 ; End of function rom_start
ROM:8045
ROM:8047
ROM:8047 ; =============== S U B R O U T I N E =======================================
ROM:8047
ROM:8047
ROM:8047 wait_for_dma_finish:                    ; CODE XREF: wait_for_dma_finish+3↓j
ROM:8047                                         ; sub_808B+6↓p ...
ROM:8047                 LRS            $AC0.M, DMAControl
ROM:8048                 ANDCF          $AC0.M, 4
ROM:804A                 JLZ            wait_for_dma_finish
ROM:804C                 RET
ROM:804C ; End of function wait_for_dma_finish

...


ROM:8078 ; =============== S U B R O U T I N E =======================================
ROM:8078
ROM:8078
ROM:8078 wait_for_mail:                          ; CODE XREF: rom_start+A↑p
ROM:8078                                         ; rom_start+13↑p ...
ROM:8078                 LRS            $AC0.M, FromCPUMailHi
ROM:8079                 ANDCF          $AC0.M, 0x8000
ROM:807B                 JLNZ           wait_for_mail
ROM:807D                 RET
ROM:807D ; End of function wait_for_mail

...

ROM:80C4 ; =============== S U B R O U T I N E =======================================
ROM:80C4 transfer_ucode:                         ; CODE XREF: rom_start+45↑j
ROM:80C4                                         ; sub_80B5+5↑j
ROM:80C4                 MRR            $AC0.M, $IX3
ROM:80C5 transfer the ucode from main mem -> DSP
ROM:80C5                 ANDI           $AC0.M, 0xFFFF
ROM:80C7                 JZ             jump_to_entry
ROM:80C9                 LRIS           $AC0.M, 2
ROM:80CA                 SRS            DMAControl, $AC0.M
ROM:80CB                 SR             DMAMMADDRH, $IX0
ROM:80CD                 SR             DMAMMADDRL, $IX1
ROM:80CF                 SR             DMADSPADDR, $IX2
ROM:80D1                 SR             DMALength, $IX3
ROM:80D3                 CALL           wait_for_dma_finish
ROM:80D5 ; jump to entrypoint
ROM:80D5 ; for MK5/AX: 0x0010
ROM:80D5
ROM:80D5 jump_to_entry:                          ; CODE XREF: rom_start+C7↑j
ROM:80D5                 CLR            $ACC1
ROM:80D6                 LR             $AC1.M, DMALength
ROM:80D8                 JMPR           $AR0
ROM:80D8 ; END OF FUNCTION CHUNK FOR rom_start