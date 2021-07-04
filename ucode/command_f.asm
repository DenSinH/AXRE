command_f:
IRAM:047A
IRAM:047A ; FUNCTION CHUNK AT IRAM:0C91 SIZE 0000000D BYTES
IRAM:047A
IRAM:047A                 SI             ToCPUMailHi, 0xDCD1
IRAM:047C all jump table entries are some form of resetting
IRAM:047C
IRAM:047C send mail dcd10002 and trigger IRQ
IRAM:047C                 SI             ToCPUMailLo, 2
IRAM:047E                 SI             DIRQ, 1
IRAM:0480                 JMP            cmdf_jump_table_select

...

IRAM:0C8D cmd_f_table     .word j_send_dcd10001_irq, debug_reset, j_rom_start, j_wait_for_babe_0
IRAM:0C91 ; ---------------------------------------------------------------------------
IRAM:0C91 ; START OF FUNCTION CHUNK FOR command_f
IRAM:0C91
IRAM:0C91 cmdf_jump_table_select:
IRAM:0C91                 SET16
IRAM:0C92                 CLR            $ACC0
IRAM:0C93                 CLR            $ACC1
IRAM:0C94                 CALL           cmdf_wait_for_cpu_mail_ac0m
IRAM:0C96                 LRS            $AC1.M, FromCPUMailLo
IRAM:0C97                 LRI            $AC0.M, cmd_f_table
IRAM:0C99                 ADD            $ACC0, $ACC1
IRAM:0C9A                 MRR            $AR3, $AC0.M
IRAM:0C9B                 ILRR           $AC1.M, @$AR3
IRAM:0C9C                 MRR            $AR3, $AC1.M
IRAM:0C9D                 JMPR           $AR3
IRAM:0C9D ; END OF FUNCTION CHUNK FOR command_f
IRAM:0C9E ; ---------------------------------------------------------------------------
IRAM:0C9E                 HALT
IRAM:0C9F
IRAM:0C9F ; =============== S U B R O U T I N E =======================================
IRAM:0C9F
IRAM:0C9F ; Attributes: thunk
IRAM:0C9F
IRAM:0C9F j_send_dcd10001_irq:
IRAM:0C9F                 JMP            send_dcd10001_irq
IRAM:0C9F ; End of function j_send_dcd10001_irq
IRAM:0C9F
IRAM:0CA1 ; ---------------------------------------------------------------------------
IRAM:0CA1                 HALT
IRAM:0CA2
IRAM:0CA2 ; =============== S U B R O U T I N E =======================================
IRAM:0CA2
IRAM:0CA2
IRAM:0CA2 debug_reset:
IRAM:0CA2                 CLR            $ACC0
IRAM:0CA3                 CLR            $ACC1
IRAM:0CA4                 CALL           cmdf_wait_for_cpu_mail_ac0m
IRAM:0CA6                 LRS            $AC0.L, FromCPUMailLo
IRAM:0CA7                 CALL           wait_for_mail_from_cpu_ac1m
IRAM:0CA9                 LRS            $AC1.L, FromCPUMailLo
IRAM:0CAA                 CALL           wait_for_mail_from_cpu_ac1m
IRAM:0CAC                 LRS            $AC1.M, FromCPUMailLo
IRAM:0CAD                 SRS            DMAMMADDRH, $AC0.M
IRAM:0CAE                 SRS            DMAMMADDRL, $AC0.L
IRAM:0CAF                 SI             DMAControl, 1
IRAM:0CB1                 SRS            DMADSPADDR, $AC1.M
IRAM:0CB2                 SRS            DMALength, $AC1.L
IRAM:0CB3                 CLR            $ACC0
IRAM:0CB4                 CLR            $ACC1
IRAM:0CB5                 CALL           cmdf_wait_for_cpu_mail_ac0m
IRAM:0CB7                 LRS            $AC0.L, FromCPUMailLo
IRAM:0CB8                 MRR            $IX0, $AC0.M
IRAM:0CB9                 MRR            $IX1, $AC0.L
IRAM:0CBA                 CALL           wait_for_mail_from_cpu_ac1m
IRAM:0CBC                 LRS            $AC1.L, FromCPUMailLo
IRAM:0CBD                 CALL           wait_for_mail_from_cpu_ac1m
IRAM:0CBF                 LRS            $AC1.M, FromCPUMailLo
IRAM:0CC0                 MRR            $IX2, $AC1.M
IRAM:0CC1                 MRR            $IX3, $AC1.L
IRAM:0CC2                 CLR            $ACC0
IRAM:0CC3                 CALL           cmdf_wait_for_cpu_mail_ac0m
IRAM:0CC5                 LRS            $AC0.M, FromCPUMailLo
IRAM:0CC6                 MRR            $AR0, $AC0.M
IRAM:0CC7                 CLR            $ACC1
IRAM:0CC8                 CALL           wait_for_mail_from_cpu_ac1m
IRAM:0CCA                 LRS            $AX0.L, FromCPUMailLo
IRAM:0CCB                 MRR            $AX0.H, $AC1.M
IRAM:0CCC                 CALL           cmdf_wait_for_cpu_mail_ac0m
IRAM:0CCE                 LRS            $AX1.L, FromCPUMailLo
IRAM:0CCF                 CALL           cmdf_wait_for_cpu_mail_ac0m
IRAM:0CD1                 LRS            $AX1.H, FromCPUMailLo
IRAM:0CD2
IRAM:0CD2 cmdf_wait_for_dma_finish:
IRAM:0CD2                 LRS            $AC0.M, DMAControl
IRAM:0CD3                 ANDF           $AC0.M, 4
IRAM:0CD5                 JLNZ           cmdf_wait_for_dma_finish
IRAM:0CD7                 JMP            sub_80B5
IRAM:0CD7 ; End of function debug_reset
IRAM:0CD7
IRAM:0CD7 ; ---------------------------------------------------------------------------
IRAM:0CD9                 .word   0x21 ; !
IRAM:0CDA
IRAM:0CDA ; =============== S U B R O U T I N E =======================================
IRAM:0CDA
IRAM:0CDA ; Attributes: thunk
IRAM:0CDA
IRAM:0CDA j_rom_start:
IRAM:0CDA                 JMP            rom_start
IRAM:0CDA ; End of function j_rom_start
IRAM:0CDA
IRAM:0CDC ; ---------------------------------------------------------------------------
IRAM:0CDC                 HALT
IRAM:0CDD
IRAM:0CDD ; =============== S U B R O U T I N E =======================================
IRAM:0CDD
IRAM:0CDD ; Attributes: thunk
IRAM:0CDD
IRAM:0CDD j_wait_for_babe_0:
IRAM:0CDD                 JMP            wait_for_babe
IRAM:0CDD ; End of function j_wait_for_babe_0
IRAM:0CDD
IRAM:0CDF ; ---------------------------------------------------------------------------
IRAM:0CDF                 HALT
IRAM:0CE0
IRAM:0CE0 ; =============== S U B R O U T I N E =======================================
IRAM:0CE0
IRAM:0CE0
IRAM:0CE0 cmdf_wait_for_cpu_mail_ac0m:
IRAM:0CE0                                         ; debug_reset+2↑p ...
IRAM:0CE0                 LRS            $AC0.M, FromCPUMailHi
IRAM:0CE1                 ANDCF          $AC0.M, 0x8000
IRAM:0CE3                 JLNZ           cmdf_wait_for_cpu_mail_ac0m
IRAM:0CE5                 RET
IRAM:0CE5 ; End of function cmdf_wait_for_cpu_mail_ac0m
IRAM:0CE5
IRAM:0CE6
IRAM:0CE6 ; =============== S U B R O U T I N E =======================================
IRAM:0CE6
IRAM:0CE6
IRAM:0CE6 wait_for_mail_from_cpu_ac1m:
IRAM:0CE6                                         ; debug_reset+8↑p ...
IRAM:0CE6                 LRS            $AC1.M, FromCPUMailHi
IRAM:0CE7                 ANDCF          $AC1.M, 0x8000
IRAM:0CE9                 JLNZ           wait_for_mail_from_cpu_ac1m
IRAM:0CEB                 RET
IRAM:0CEB ; End of function wait_for_mail_from_cpu_ac1m

...

ROM:80B5 sub_80B5:
ROM:80B5
ROM:80B5 ; FUNCTION CHUNK AT ROM:80C4 SIZE 00000015 BYTES
ROM:80B5
ROM:80B5                 SET16
ROM:80B6                 CLR            $ACC0
ROM:80B7                 MRR            $AC0.M, $AX1.L
ROM:80B8                 ANDI           $AC0.M, 0xFFFF
ROM:80BA                 JZ             transfer_ucode
ROM:80BC                 LRIS           $AC0.M, 0
ROM:80BD                 SRS            DMAControl, $AC0.M
ROM:80BE                 SRS            DMAMMADDRH, $AX0.H
ROM:80BF                 SRS            DMAMMADDRL, $AX0.L
ROM:80C0                 SRS            DMADSPADDR, $AX1.H
ROM:80C1                 SRS            DMALength, $AX1.L
ROM:80C2                 CALL           wait_for_dma_finish
ROM:80C2 ; End of function sub_80B5
ROM:80C2
ROM:80C4 ; START OF FUNCTION CHUNK FOR rom_start
ROM:80C4 ;   ADDITIONAL PARENT FUNCTION sub_80B5
ROM:80C4
ROM:80C4 transfer_ucode:
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
ROM:80D5 jump to entrypoint
ROM:80D5 for MK5/AX: 0x0010
ROM:80D5
ROM:80D5 jump_to_entry:
ROM:80D5                 CLR            $ACC1
ROM:80D6                 LR             $AC1.M, DMALength
ROM:80D8                 JMPR           $AR0
ROM:80D8 ; END OF FUNCTION CHUNK FOR rom_start