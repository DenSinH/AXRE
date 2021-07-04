; =============== S U B R O U T I N E =======================================
IRAM:01BC
IRAM:01BC
IRAM:01BC command_2:
IRAM:01BC                 CLR            $ACC0
IRAM:01BD ; read mmaddr from command stream
IRAM:01BD                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:01BE                 SET16'L        $AC1.M : @$AR0
IRAM:01BF ; start DMA to DSP DMEM 0xb80 of length 0xc0
IRAM:01BF ; this probably holds some settings or a struct
IRAM:01BF                 SRS            DMAMMADDRH, $AC0.M
IRAM:01C0                 SRS            DMAMMADDRL, $AC1.M
IRAM:01C1                 SI             DMADSPADDR, 0xB80
IRAM:01C3                 SI             DMAControl, 0
IRAM:01C5                 SI             DMALength, 0xC0
IRAM:01C7                 LRI            $AR2, buffer_sections_E08
IRAM:01C9 ; store addresses of buffer sections to DMEM 0xe08
IRAM:01C9                 LRI            $AC1.M, 0
IRAM:01CB                 SRRI           @$AR2, $AC1.M
IRAM:01CC                 LRI            $AC1.M, 0x140
IRAM:01CE                 SRRI           @$AR2, $AC1.M
IRAM:01CF                 LRI            $AC1.M, 0x280
IRAM:01D1                 SRRI           @$AR2, $AC1.M
IRAM:01D2                 LRI            $AC1.M, 0x400
IRAM:01D4                 SRRI           @$AR2, $AC1.M
IRAM:01D5                 LRI            $AC1.M, 0x540
IRAM:01D7                 SRRI           @$AR2, $AC1.M
IRAM:01D8                 LRI            $AC1.M, 0x680
IRAM:01DA                 SRRI           @$AR2, $AC1.M
IRAM:01DB                 LRI            $AC1.M, 0x7C0
IRAM:01DD                 SRRI           @$AR2, $AC1.M
IRAM:01DE                 LRI            $AC1.M, 0x900
IRAM:01E0                 SRRI           @$AR2, $AC1.M
IRAM:01E1                 LRI            $AC1.M, 0xA40
IRAM:01E3                 SRRI           @$AR2, $AC1.M
IRAM:01E4                 CALL           wait_for_dma_finish_0
IRAM:01E6 ; load address from DMA'ed settings and start DMA to DSP 0x3c0
IRAM:01E6 of length 0x80
IRAM:01E6                 LR             $AC0.M, loc_BA6+1
IRAM:01E8                 LR             $AC1.M, DMEM_BA8
IRAM:01EA                 SRS            DMAMMADDRH, $AC0.M
IRAM:01EB                 SRS            DMAMMADDRL, $AC1.M
IRAM:01EC                 SI             DMADSPADDR, 0x3C0
IRAM:01EE                 SI             DMAControl, 0
IRAM:01F0                 SI             DMALength, 0x80
IRAM:01F2                 CLR            $ACC0
IRAM:01F3                 CLR            $ACC1
IRAM:01F4 ; load offset from DMA'ed data and copy value from 0xb31 + offset to E15
IRAM:01F4                 LR             $AC0.M, DMEM_B84
IRAM:01F6                 LRI            $AC1.M, 0xB31
IRAM:01F8                 ADD            $ACC0, $ACC1
IRAM:01F9                 MRR            $AR3, $AC0.M
IRAM:01FA                 ILRR           $AC0.M, @$AR3
IRAM:01FB                 SR             DMEM_E15, $AC0.M
IRAM:01FD ; load offset from DMA'ed data and copy value from 0xb34 + offset to E16
IRAM:01FD                 LR             $AC0.M, DMEM_B85
IRAM:01FF                 LRI            $AC1.M, 0xB34
IRAM:0201                 ADD            $ACC0, $ACC1
IRAM:0202                 MRR            $AR3, $AC0.M
IRAM:0203                 ILRR           $AC0.M, @$AR3
IRAM:0204 ; load offset from DMA'ed data and copy value from 0xb11 + offset to E14
IRAM:0204                 SR             DMEM_E16, $AC0.M
IRAM:0206                 LR             $AC0.M, DMEM_B86
IRAM:0208                 LRI            $AC1.M, 0xB11
IRAM:020A                 ADD            $ACC0, $ACC1
IRAM:020B                 MRR            $AR3, $AC0.M
IRAM:020C                 ILRR           $AC0.M, @$AR3
IRAM:020D                 SR             DMEM_E14, $AC0.M
IRAM:020F ; if [B9B] == 0: jump
IRAM:020F                 CLR            $ACC0
IRAM:0210                 LR             $AC0.M, DMEM_B9B
IRAM:0212                 TST            $ACC0
IRAM:0213                 JZ             b9b_zero
IRAM:0215 ; else
IRAM:0215                 CLR            $ACC1
IRAM:0216 ; store offsets relative to cc0 (command stream start) to E40/41/42/43
IRAM:0216                 LR             $AC1.M, loc_B9E
IRAM:0218                 ADDI           $AC1.M, 0xCC0
IRAM:021A                 SR             cmd2_DMEM_E40_start, $AC1.M
IRAM:021C                 LR             $AC1.M, loc_B9F
IRAM:021E                 ADDI           $AC1.M, 0xCC0
IRAM:0220                 SR             cmd2_DMEM_E41_end, $AC1.M
IRAM:0222                 LRI            $AC1.M, 0xCE0
IRAM:0224                 SR             cmd2_DMEM_E42, $AC1.M
IRAM:0226                 SR             cmd2_DMEM_E43, $AC1.M
IRAM:0228                 CALL           wait_for_dma_finish_0
IRAM:022A ; load DMA address from transferred data and start DMA to DSP DMEM CC0 of length 0x40
IRAM:022A                 LR             $AC0.M, DMEM_B9C
IRAM:022C                 SRS            DMAMMADDRH, $AC0.M
IRAM:022D                 LR             $AC0.M, DMEM_B9D
IRAM:022F                 SRS            DMAMMADDRL, $AC0.M
IRAM:0230                 SI             DMADSPADDR, 0xCC0
IRAM:0232                 SI             DMAControl, 0
IRAM:0234                 SI             DMALength, 0x40
IRAM:0236                 CALL           wait_for_dma_finish_0
IRAM:0238                 JMP            receive_command
IRAM:023A ; ---------------------------------------------------------------------------
IRAM:023A ; store end of command stream (?) to E40/41/42/43
IRAM:023A
IRAM:023A b9b_zero:
IRAM:023A                 LRI            $AC1.M, 0xCE0
IRAM:023C                 SR             cmd2_DMEM_E42, $AC1.M
IRAM:023E                 SR             cmd2_DMEM_E40_start, $AC1.M
IRAM:0240                 SR             cmd2_DMEM_E41_end, $AC1.M
IRAM:0242                 SR             cmd2_DMEM_E43, $AC1.M
IRAM:0244                 CALL           wait_for_dma_finish_0
IRAM:0246                 JMP            receive_command
IRAM:0246 ; End of function command_2