IRAM:043B command_e:
IRAM:043B                 CLR15
IRAM:043C                 M2
IRAM:043D                 CLR            $ACC0
IRAM:043E ; read mmaddr from command stream and DMA 0x280 bytes from 0x280
IRAM:043E                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:043F                 LRRI           $AC1.M, @$AR0
IRAM:0440                 SRS            DMAMMADDRH, $AC0.M
IRAM:0441                 SRS            DMAMMADDRL, $AC1.M
IRAM:0442                 SI             DMADSPADDR, 0x280
IRAM:0444                 SI             DMAControl, 1
IRAM:0446                 SI             DMALength, 0x280
IRAM:0448 ; load mmaddr AX0.HL from command stream
IRAM:0448                 SET40'L        $AX0.H : @$AR0
IRAM:0449                 CLR'L          $ACC0 : $AX0.L, @$AR0
IRAM:044A                 LRI            $AR1, 0x400 ; u16* buffer_400
IRAM:044C                 LRI            $AR3, 0  ; u16* buffer_0
IRAM:044E                 LRI            $AR2, 0x140 ; u16* buffer_140
IRAM:0450                 LRI            $AX1.L, 0x80
IRAM:0452                 CALL           wait_for_dma_finish_0
IRAM:0454 ; REPEAT 5 TIMES
IRAM:0454                 BLOOPI         5, loc_46C
IRAM:0456                 MRR            $AX1.H, $AR1 ; buffer400_loop_start
IRAM:0457 ;    REPEAT 0x20 TIMES
IRAM:0457                 BLOOPI         0x20, loc_45E
IRAM:0459 ; ac0.ml = *(u32*)buffer_140++;
IRAM:0459 ; ac0 <<= 16;
IRAM:0459 ; ac1.ml = *(u32*)buffer_0++;
IRAM:0459 ; ac1 <<= 16;
IRAM:0459 ; *buffer_400++ = ac0.m
IRAM:0459 ; *buffer_400++ = ac1.m
IRAM:0459                 CLR'L          $ACC1 : $AC0.M, @$AR2
IRAM:045A                 LRRI           $AC0.L, @$AR2
IRAM:045B                 LSL16'L        $ACC0 : $AC1.M, @$AR3
IRAM:045C                 LRRI           $AC1.L, @$AR3
IRAM:045D                 LSL16'S        $ACC1 : @$AR1, $AC0.M
IRAM:045E
IRAM:045E loc_45E:
IRAM:045E                 CLR'S          $ACC0 : @$AR1, $AC1.M
IRAM:045F ;     BLOOPI END
IRAM:045F                 CLR            $ACC1
IRAM:0460                 MOVAX          $ACC0, $AX0 ; mmaddr
IRAM:0461                 SRS            DMAMMADDRH, $AC0.M
IRAM:0462                 SRS            DMAMMADDRL, $AC0.L
IRAM:0463                 MRR            $AC1.M, $AX1.H ; buffer400_loop_start
IRAM:0464                 SRS            DMADSPADDR, $AC1.M
IRAM:0465                 LRIS           $AC1.M, 1
IRAM:0466                 SRS            DMAControl, $AC1.M
IRAM:0467                 MRR            $AC1.M, $AX1.L
IRAM:0468                 SRS            DMALength, $AC1.M
IRAM:0469                 ADDAXL         $ACC0, $AX1.L ; 0x80
IRAM:046A                 MRR            $AX0.H, $AC0.M ; mmaddr += 0x80
IRAM:046B                 MRR            $AX0.L, $AC0.L
IRAM:046C
IRAM:046C loc_46C:
IRAM:046C                 CLR            $ACC0
IRAM:046D ; BLOOPI END
IRAM:046D
IRAM:046D cmde_wait_for_dma_finish:
IRAM:046D                 LRS            $AC0.M, DMAControl
IRAM:046E                 ANDF           $AC0.M, 4
IRAM:0470                 JLNZ           cmde_wait_for_dma_finish
IRAM:0472                 JMP            receive_command
IRAM:0472 ; End of function command_e