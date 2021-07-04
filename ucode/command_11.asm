IRAM:0175 command_11:
IRAM:0175                 CLR            $ACC0
IRAM:0176                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:0177                 SET16'L        $AC0.L : @$AR0
IRAM:0178 ; DMA 0x20 bytes to 0xe44 from main memory address from command stream
IRAM:0178                 SRS            DMAMMADDRH, $AC0.M
IRAM:0179                 SRS            DMAMMADDRL, $AC0.L
IRAM:017A                 SI             DMADSPADDR, 0xE44
IRAM:017C                 SI             DMAControl, 0
IRAM:017E                 CLR            $ACC1
IRAM:017F                 LRIS           $AC1.L, 0x20
IRAM:0180                 SRS            DMALength, $AC1.L
IRAM:0181 ; ac0 = mmaddr + 0x20
IRAM:0181                 ADD            $ACC0, $ACC1
IRAM:0182 ; save command stream pointer
IRAM:0182                 MRR            $IX0, $AR0
IRAM:0183 ; ar0: dest280 = 0x280
IRAM:0183 ; ar1 = 0
IRAM:0183 ; ar2: dest140 = 0x140
IRAM:0183 ; ar3: srce44 = 0xe44
IRAM:0183                 LRI            $AR0, 0x280
IRAM:0185                 LRI            $AR1, 0
IRAM:0187                 LRI            $AR2, 0x140
IRAM:0189                 LRI            $AR3, 0xE44
IRAM:018B                 LRIS           $AX0.H, 0
IRAM:018C
IRAM:018C ; cmd11_wait_for_dma_finish:
IRAM:018C                 LRS            $AC1.M, DMAControl
IRAM:018D                 ANDF           $AC1.M, 4
IRAM:018F                 JLNZ           cmd11_wait_for_dma_finish
IRAM:0191 ; DMA 0x260 bytes from mmaddr + 0x20 to DSP DMEM 0xe54 (contiguous)
IRAM:0191                 SRS            DMAMMADDRH, $AC0.M
IRAM:0192                 SRS            DMAMMADDRL, $AC0.L
IRAM:0193                 SI             DMADSPADDR, 0xE54
IRAM:0195                 SI             DMAControl, 0
IRAM:0197                 SI             DMALength, 0x260
IRAM:0199                 LRI            $AC1.M, 0xA0
IRAM:019B                 SET40
IRAM:019C ; REPEAT 0xa0 = 160 TIMES
IRAM:019C                 BLOOP          $AC1.M, loc_1A5
IRAM:019E ; ac0.ml = *(u32*)srce44++
IRAM:019E                 LRRI           $AC0.M, @$AR3
IRAM:019F ; *dest280++ = 0
IRAM:019F                 SRRI           @$AR0, $AX0.H
IRAM:01A0                 LRRI           $AC0.L, @$AR3
IRAM:01A1 ; *dest280++ = 0
IRAM:01A1                 SRRI           @$AR0, $AX0.H
IRAM:01A2 ; *dest140++ = ac0.ml
IRAM:01A2                 SRRI           @$AR2, $AC0.M
IRAM:01A3                 NEG'S          $ACC0 : @$AR2, $AC0.L
IRAM:01A4 ; *dest0++ = -ac0.ml
IRAM:01A4                 SRRI           @$AR1, $AC0.M
IRAM:01A5
IRAM:01A5 loc_1A5:
IRAM:01A5                 SRRI           @$AR1, $AC0.L
IRAM:01A6 ; BLOOP END
IRAM:01A6
IRAM:01A6 ; restore command stream pointer
IRAM:01A6                 MRR            $AR0, $IX0
IRAM:01A7                 JMP            receive_command