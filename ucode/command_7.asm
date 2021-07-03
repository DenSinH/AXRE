command_7:                              ; DATA XREF: IRAM:command_jump_table↓o
IRAM:0574                 CLR            $ACC0
IRAM:0575                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:0576                 SET16'L        $AC0.L : @$AR0
IRAM:0577 ; DMA 0x20 bytes from mmaddr read from command stream to buffer at 0xe44
IRAM:0577                 SRS            DMAMMADDRH, $AC0.M
IRAM:0578                 SRS            DMAMMADDRL, $AC0.L
IRAM:0579                 SI             DMADSPADDR, 0xE44
IRAM:057B                 SI             DMAControl, 0
IRAM:057D                 CLR            $ACC1
IRAM:057E                 LRIS           $AC1.L, 0x20
IRAM:057F                 SRS            DMALength, $AC1.L
IRAM:0580 ; mmaddr += 0x20
IRAM:0580                 ADD            $ACC0, $ACC1
IRAM:0581 ; save command_stream pointer
IRAM:0581                 MRR            $IX0, $AR0
IRAM:0582                 LRI            $AR0, 0x280
IRAM:0584                 LRI            $AR1, 0
IRAM:0586                 LRI            $AR2, 0x140
IRAM:0588                 LRI            $AR3, 0xE44
IRAM:058A                 LRIS           $AX0.H, 0
IRAM:058B ; wait for DMA to finish
IRAM:058B
IRAM:058B loc_58B:                                ; CODE XREF: command_7+1A↓j
IRAM:058B                 LRS            $AC1.M, DMAControl
IRAM:058C                 ANDF           $AC1.M, 4
IRAM:058E                 JLNZ           loc_58B
IRAM:0590 ; DMA 0x260 bytes from mmaddr to 0xe54 (contiguous with previous section)
IRAM:0590                 SRS            DMAMMADDRH, $AC0.M
IRAM:0591                 SRS            DMAMMADDRL, $AC0.L
IRAM:0592                 SI             DMADSPADDR, 0xE54
IRAM:0594                 SI             DMAControl, 0
IRAM:0596                 SI             DMALength, 0x260
IRAM:0598                 LRI            $AC1.M, 0xA0
IRAM:059A                 SET40
IRAM:059B ; REPEAT 0xa0 = 160 TIMES
IRAM:059B ; initially:
IRAM:059B ; AR0-AR3: sections in 0x3c0 buffer at 0x0000
IRAM:059B ; AR0 = 0x280
IRAM:059B ; AR1 = 0
IRAM:059B ; AR2 = 0x140
IRAM:059B ; AR3 = 0xe44  // buffered data
IRAM:059B                 BLOOP          $AC1.M, loc_5A4
IRAM:059D                 LRRI           $AC0.M, @$AR3
IRAM:059E ; clear out section at 0x280
IRAM:059E ; copy words from 0xe44 to 0x000 and 0x140
IRAM:059E                 SRRI           @$AR0, $AX0.H
IRAM:059F                 LRRI           $AC0.L, @$AR3
IRAM:05A0                 SRRI           @$AR0, $AX0.H
IRAM:05A1                 SRRI           @$AR2, $AC0.M
IRAM:05A2                 SRRI           @$AR2, $AC0.L
IRAM:05A3                 SRRI           @$AR1, $AC0.M
IRAM:05A4
IRAM:05A4 loc_5A4:                                ; CODE XREF: command_7+27↑j
IRAM:05A4                 SRRI           @$AR1, $AC0.L
IRAM:05A5 ; BLOOP END
IRAM:05A5
IRAM:05A5 ; restore command_stream pointer
IRAM:05A5                 MRR            $AR0, $IX0
IRAM:05A6                 JMP            receive_command