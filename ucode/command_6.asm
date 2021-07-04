IRAM:0165 command_6:
IRAM:0165                 CLR            $ACC0
IRAM:0166                 SET16
IRAM:0167 DMA 0x780 bytes from DSP DMEM[0] to main mem address from command stream
IRAM:0167                 LRRI           $AC0.M, @$AR0
IRAM:0168                 LRRI           $AC0.L, @$AR0
IRAM:0169                 SRS            DMAMMADDRH, $AC0.M
IRAM:016A                 SRS            DMAMMADDRL, $AC0.L
IRAM:016B                 SI             DMADSPADDR, 0
IRAM:016D                 SI             DMAControl, 1
IRAM:016F                 SI             DMALength, 0x780
IRAM:0171                 CALL           wait_for_dma_finish_0
IRAM:0173                 JMP            receive_command
IRAM:0173 ; End of function command_6