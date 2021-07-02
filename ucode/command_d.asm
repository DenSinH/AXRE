IRAM:01A9 command_d:                              ; DATA XREF: IRAM:command_jump_table↓o
IRAM:01A9                 SET16'L        $AC0.M : @$AR0
IRAM:01AA ; load main memory address and length from command stream
IRAM:01AA                 CLR'L          $ACC1 : $AC0.L, @$AR0
IRAM:01AB                 LRRI           $AC1.M, @$AR0
IRAM:01AC ; DMA to command stream address
IRAM:01AC                 SRS            DMAMMADDRH, $AC0.M
IRAM:01AD                 SRS            DMAMMADDRL, $AC0.L
IRAM:01AE                 SI             DMADSPADDR, 0xC00
IRAM:01B0                 SI             DMAControl, 0
IRAM:01B2                 ADDIS          $AC1.M, 3
IRAM:01B3                 ANDI           $AC1.M, 0xFFF0
IRAM:01B5 ; round to 16 byte blocks
IRAM:01B5 ; DMALen = (len_from_stream + 3) & 0xfff0
IRAM:01B5                 SRS            DMALength, $AC1.M
IRAM:01B6                 CALL           wait_for_dma_finish_0
IRAM:01B8                 LRI            $AR0, 0xC00
IRAM:01BA                 JMP            receive_command