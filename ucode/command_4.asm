IRAM:0413 command_4:
IRAM:0413                 SET16
IRAM:0414 ; DMA 0x780 bytes to main mem from DSP DMEM 0x400
IRAM:0414 ; MMADDR read from command stream
IRAM:0414 ; then call mix_buffers with 0x400
IRAM:0414                 LRI            $IX2, 0x400
IRAM:0416                 CLR            $ACC0
IRAM:0417                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:0418                 LRRI           $AC0.L, @$AR0
IRAM:0419                 SRS            DMAMMADDRH, $AC0.M
IRAM:041A                 SRS            DMAMMADDRL, $AC0.L
IRAM:041B                 MRR            $AC0.M, $IX2
IRAM:041C                 SRS            DMADSPADDR, $AC0.M
IRAM:041D                 SI             DMAControl, 1
IRAM:041F                 SI             DMALength, 0x780
IRAM:0421                 CALL           wait_for_dma_finish_0
IRAM:0423                 CALL           mix_buffers
IRAM:0425                 JMP            receive_command