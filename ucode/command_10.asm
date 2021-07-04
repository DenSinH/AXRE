IRAM:0BB1 command_10:
IRAM:0BB1                 SET16
IRAM:0BB2
IRAM:0BB2 loc_BB2:
IRAM:0BB2                                         ; command_3+57↑r
IRAM:0BB2                 CLR            $ACC0
IRAM:0BB3
IRAM:0BB3 loc_BB3:
IRAM:0BB3                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:0BB4 ; DMA buffer 0x7c0 to main memory address from command stream
IRAM:0BB4                 LRRI           $AC0.L, @$AR0
IRAM:0BB5                 SRS            DMAMMADDRH, $AC0.M
IRAM:0BB6                 SRS            DMAMMADDRL, $AC0.L
IRAM:0BB7
IRAM:0BB7 DMEM_BB7:
IRAM:0BB7                                         ; sub_C50+4↓r
IRAM:0BB7                 SI             DMADSPADDR, 0x7C0
IRAM:0BB9                 SI             DMAControl, 1
IRAM:0BBB                 SI             DMALength, 0x500
IRAM:0BBD                 CALL           wait_for_dma_finish_0
IRAM:0BBF ; DMA 0x20 bytes from main memory to buffer 0x7c0 from address in command stream
IRAM:0BBF                 CLR            $ACC0
IRAM:0BC0                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:0BC1                 LRRI           $AC0.L, @$AR0
IRAM:0BC2                 SRS            DMAMMADDRH, $AC0.M
IRAM:0BC3                 SRS            DMAMMADDRL, $AC0.L
IRAM:0BC4                 SI             DMADSPADDR, 0x7C0
IRAM:0BC6                 SI             DMAControl, 0
IRAM:0BC8                 CLR            $ACC1
IRAM:0BC9                 LRIS           $AC1.L, 0x20
IRAM:0BCA                 SRS            DMALength, $AC1.L
IRAM:0BCB ; mmaddr += 0x20, save in IX0
IRAM:0BCB                 ADD            $ACC0, $ACC1
IRAM:0BCC                 MRR            $IX0, $AR0
IRAM:0BCD ; ar0: buffer_7c0
IRAM:0BCD ; ar3, ar2: buffer_0
IRAM:0BCD                 LRI            $AR0, 0x7C0
IRAM:0BCF                 LRI            $AR3, 0
IRAM:0BD1                 MRR            $AR2, $AR3
IRAM:0BD2                 LRIS           $AX0.H, 0
IRAM:0BD3
IRAM:0BD3 cmd10_wait_for_dma_finish:
IRAM:0BD3                 LRS            $AC1.M, DMAControl
IRAM:0BD4                 ANDF           $AC1.M, 4
IRAM:0BD6                 JLNZ           cmd10_wait_for_dma_finish
IRAM:0BD8 ; DMA another 0x20 bytes (same staggering as other commands)
IRAM:0BD8                 SRS            DMAMMADDRH, $AC0.M
IRAM:0BD9                 SRS            DMAMMADDRL, $AC0.L
IRAM:0BDA
IRAM:0BDA loc_BDA:
IRAM:0BDA                                         ; sub_C50:loc_C71↓r ...
IRAM:0BDA                 SI
IRAM:0BDC
IRAM:0BDC loc_BDC:
IRAM:0BDC                                         ; sub_C50+29↓r ...
IRAM:0BDC                 SI             DMAControl, 0
IRAM:0BDE                 SI             DMALength, 0x4E0
IRAM:0BE0                 SET40
IRAM:0BE1 ; load dwords from buffer_7c0
IRAM:0BE1 ; add them to words from buffer_0
IRAM:0BE1 ; store them to buffer_0
IRAM:0BE1                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:0BE2                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:0BE3                 MOVAX          $ACC0, $AX1
IRAM:0BE4                 ADDAX          $ACC0, $AX0
IRAM:0BE5 ; REPEAT 0x4F TIMES
IRAM:0BE5                 BLOOPI         0x4F, loc_BEE
IRAM:0BE7                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:0BE8                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:0BE9                 MOVAX'S        $ACC1, $AX1 : @$AR2, $AC0.M
IRAM:0BEA                 ADDAX'S        $ACC1, $AX0 : @$AR2, $AC0.L
IRAM:0BEB                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:0BEC                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:0BED                 MOVAX'S        $ACC0, $AX1 : @$AR2, $AC1.M
IRAM:0BEE
IRAM:0BEE loc_BEE:
IRAM:0BEE                 ADDAX'S        $ACC0, $AX0 : @$AR2, $AC1.L
IRAM:0BEF ; BLOOPI END
IRAM:0BEF                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:0BF0                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:0BF1                 MOVAX'S        $ACC1, $AX1 : @$AR2, $AC0.M
IRAM:0BF2                 ADDAX'S        $ACC1, $AX0 : @$AR2, $AC0.L
IRAM:0BF3                 SRRI           @$AR2, $AC1.M
IRAM:0BF4                 SRRI           @$AR2, $AC1.L
IRAM:0BF5 ; same thing as above starts here, except theres a negative
IRAM:0BF5                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:0BF6                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:0BF7                 MOVAX          $ACC0, $AX0
IRAM:0BF8                 NEG            $ACC0
IRAM:0BF9                 ADDAX          $ACC0, $AX1
IRAM:0BFA ; REPEAT 0x4F TIMES
IRAM:0BFA                 BLOOPI         0x4F, loc_C05
IRAM:0BFC                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:0BFD                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:0BFE                 MOVAX'S        $ACC1, $AX0 : @$AR2, $AC0.M
IRAM:0BFF                 NEG            $ACC1
IRAM:0C00                 ADDAX'S        $ACC1, $AX1 : @$AR2, $AC0.L
IRAM:0C01                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:0C02                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:0C03                 MOVAX'S        $ACC0, $AX0 : @$AR2, $AC1.M
IRAM:0C04                 NEG            $ACC0
IRAM:0C05
IRAM:0C05 loc_C05:
IRAM:0C05                 ADDAX'S        $ACC0, $AX1 : @$AR2, $AC1.L
IRAM:0C06 ; BLOOPI END
IRAM:0C06                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:0C07                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:0C08                 MOVAX'S        $ACC1, $AX0 : @$AR2, $AC0.M
IRAM:0C09                 NEG            $ACC1
IRAM:0C0A                 ADDAX'S        $ACC1, $AX1 : @$AR2, $AC0.L
IRAM:0C0B                 SRRI           @$AR2, $AC1.M
IRAM:0C0C                 SRRI           @$AR2, $AC1.L
IRAM:0C0D                 MRR            $AR0, $IX0
IRAM:0C0E                 JMP            receive_command