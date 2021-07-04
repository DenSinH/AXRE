command_1:
IRAM:013E                 LRI            $IX1, 0xFFFF
IRAM:0140 ; read main memory address from command stream into AX0 (hi then lo)
IRAM:0140                 CLR'L          $ACC0 : $AX0.H, @$AR0
IRAM:0141                 CLR'L          $ACC1 : $AX0.L, @$AR0
IRAM:0142 ; load scale into AX1.L
IRAM:0142                 SET16'L        $AX1.L : @$AR0
IRAM:0143 ; save main memory address
IRAM:0143                 SR             cmd1_mmaddrh_temp_E17, $AX0.H
IRAM:0145                 SR             cmd1_mmaddrl_temp_E18, $AX0.L
IRAM:0147 ; this is going to process data in the buffers setup by command 0
IRAM:0147                 LRI            $AR1, 0
IRAM:0149                 CALL           transform_buffer
IRAM:014B ; restore mmaddr
IRAM:014B                 LR             $AX0.H, cmd1_mmaddrh_temp_E17
IRAM:014D                 LR             $AX0.L, cmd1_mmaddrl_temp_E18
IRAM:014F                 CLR'L          $ACC1 : $AX1.L, @$AR0
IRAM:0150                 LRI            $AR1, 0x400
IRAM:0152                 CALL           transform_buffer
IRAM:0154 ; restore mmaddr
IRAM:0154                 LR             $AX0.H, cmd1_mmaddrh_temp_E17
IRAM:0156                 LR             $AX0.L, cmd1_mmaddrl_temp_E18
IRAM:0158                 CLR'L          $ACC1 : $AX1.L, @$AR0
IRAM:0159                 LRI            $AR1, 0x7C0
IRAM:015B                 CALL           transform_buffer
IRAM:015D                 JMP            receive_command
IRAM:015D ; End of function command_1

...

transform_buffer:
IRAM:04F1                                         ; command_1+14↑p ...
IRAM:04F1                 SET16
IRAM:04F2 ; input ar1: pointer to data transferred by command_0
IRAM:04F2
IRAM:04F2 ; DMA 0xc0 bytes from input mmaddr to E44
IRAM:04F2                 LRI            $AX1.H, 0xE44
IRAM:04F4                 LRI            $AC1.L, 0xC0
IRAM:04F6                 CALL           start_DMA_to_DSP_mmaddr_AX0_dspaddr_AX1H_len_AC1L
IRAM:04F8 ; ac1: mmaddr + 0xc0
IRAM:04F8                 ADDAX          $ACC1, $AX0
IRAM:04F9 ; save (new) source address
IRAM:04F9                 SR             tf_buffer_mmaddr_temph_E1D, $AC1.M
IRAM:04FB                 SR             tf_buffer_mmaddr_templ_E1E, $AC1.L
IRAM:04FD                 CLR            $ACC1
IRAM:04FE                 CALL           wait_for_dma_finish_0
IRAM:0500 ; REPEAT 4 TIMES
IRAM:0500                 BLOOPI         4, loc_52C
IRAM:0502 ; restore mmaddr
IRAM:0502                 LR             $AX0.H, tf_buffer_mmaddr_temph_E1D
IRAM:0504                 LR             $AX0.L, tf_buffer_mmaddr_templ_E1E
IRAM:0506 ; DMA 0xc0 more bytes
IRAM:0506                 LRI            $AX1.H, 0xEA4
IRAM:0508                 LRI            $AC1.L, 0xC0
IRAM:050A                 CALL           start_DMA_to_DSP_mmaddr_AX0_dspaddr_AX1H_len_AC1L
IRAM:050C ; mmaddr += 0xc0
IRAM:050C                 ADDAX          $ACC1, $AX0
IRAM:050D ; save mmaddr
IRAM:050D                 SR             tf_buffer_mmaddr_temph_E1D, $AC1.M
IRAM:050F                 SR             tf_buffer_mmaddr_templ_E1E, $AC1.L
IRAM:0511                 LRI            $AR3, 0xE44
IRAM:0513                 CALL           transform_buffer_section
IRAM:0515                 CLR            $ACC1
IRAM:0516 ; restore mmaddr
IRAM:0516                 LR             $AX0.H, tf_buffer_mmaddr_temph_E1D
IRAM:0518                 LR             $AX0.L, tf_buffer_mmaddr_templ_E1E
IRAM:051A ; dma another 0xc0 bytes
IRAM:051A                 LRI            $AX1.H, 0xE44
IRAM:051C                 LRI            $AC1.L, 0xC0
IRAM:051E                 CALL           start_DMA_to_DSP_mmaddr_AX0_dspaddr_AX1H_len_AC1L
IRAM:0520 ; mmaddr += 0xc0
IRAM:0520                 ADDAX          $ACC1, $AX0
IRAM:0521 ; save mmaddr
IRAM:0521                 SR             tf_buffer_mmaddr_temph_E1D, $AC1.M
IRAM:0523                 SR             tf_buffer_mmaddr_templ_E1E, $AC1.L
IRAM:0525                 LRI            $AR3, 0xEA4
IRAM:0527                 CALL           transform_buffer_section
IRAM:0529                 NOP
IRAM:052A                 NOP
IRAM:052B                 SET16
IRAM:052C
IRAM:052C loc_52C:
IRAM:052C                 CLR            $ACC1
IRAM:052D ; BLOOPI_END
IRAM:052D
IRAM:052D ; restore mmaddr
IRAM:052D                 LR             $AX0.H, tf_buffer_mmaddr_temph_E1D
IRAM:052F                 LR             $AX0.L, tf_buffer_mmaddr_templ_E1E
IRAM:0531 ; DMA another 0xc0 words
IRAM:0531                 LRI            $AX1.H, 0xEA4
IRAM:0533                 LRI            $AC1.L, 0xC0
IRAM:0535                 CALL           start_DMA_to_DSP_mmaddr_AX0_dspaddr_AX1H_len_AC1L
IRAM:0537 ; mmaddr += 0xc0
IRAM:0537                 ADDAX          $ACC1, $AX0
IRAM:0538                 LRI            $AR3, 0xE44
IRAM:053A                 CALL           transform_buffer_section
IRAM:053C                 LRI            $AR3, 0xEA4
IRAM:053E                 CALL           transform_buffer_section
IRAM:0540                 RET
IRAM:0540 ; End of function transform_buffer
IRAM:0540
IRAM:0541
IRAM:0541 ; =============== S U B R O U T I N E =======================================
IRAM:0541
IRAM:0541
IRAM:0541 start_DMA_to_DSP_mmaddr_AX0_dspaddr_AX1H_len_AC1L:
IRAM:0541                                         ; CODE XREF: transform_buffer+5↑p
IRAM:0541                                         ; transform_buffer+19↑p ...
IRAM:0541                 SET16
IRAM:0542                 SR             DMAMMADDRH, $AX0.H
IRAM:0544                 SR             DMAMMADDRL, $AX0.L
IRAM:0546                 SR             DMADSPADDR, $AX1.H
IRAM:0548                 SI             DMAControl, 0
IRAM:054A                 SRS            DMALength, $AC1.L
IRAM:054B                 RET
IRAM:054B ; End of function start_DMA_to_DSP_mmaddr_AX0_dspaddr_AX1H_len_AC1L
IRAM:054B
IRAM:054C
IRAM:054C ; =============== S U B R O U T I N E =======================================
IRAM:054C
IRAM:054C
IRAM:054C transform_buffer_section:
IRAM:054C                                         ; transform_buffer+36↑p ...
IRAM:054C                 SET40
IRAM:054D                 SET15
IRAM:054E                 M2
IRAM:054F ; input AR3 is pointer to start of DMA'ed data in command 1
IRAM:054F ; input AR1 is pointer to start of DMA'ed data in command 0
IRAM:054F ; load 2 words (base)
IRAM:054F ; AX1.L = scale (from cmd1)
IRAM:054F ; IX1 = 0xffff (-1)
IRAM:054F                 LRRI           $AX0.H, @$AR3
IRAM:0550                 LRRI           $AX0.L, @$AR3
IRAM:0551 ; ac0 = (i16(base)) * scale;
IRAM:0551 ; prod = (i16(base >> 16)) * scale;
IRAM:0551                 MULX           $AX0.L, $AX1.L
IRAM:0552                 MULXMV         $AX0.H, $AX1.L, $ACC0
IRAM:0553 ; REPEAT 0x30 = 48 times
IRAM:0553                 BLOOPI         0x30, loc_55A
IRAM:0555 ; load word from AR1 stream to AC1.ml, don't change AR1
IRAM:0555 ; ac0 = (ac0 >> 16) + prod
IRAM:0555 ; fixed point?
IRAM:0555                 ASR16'L        $ACC0 : $AC1.M, @$AR1
IRAM:0556                 ADDP'LN        $ACC0 : $AC1.L, @$AR1
IRAM:0557 ; load new word from AR3 data stream
IRAM:0557                 LRRI           $AX0.H, @$AR3
IRAM:0558 ; ac1 += ac0
IRAM:0558 ; load new AX0.L from AR3 stream
IRAM:0558                 ADD'L          $ACC1, $ACC0 : $AX0.L, @$AR3
IRAM:0559 ; same product as above the loop
IRAM:0559 ; *(u32*)ar1++ = ac1.ml
IRAM:0559 ; this overwrites the previous value
IRAM:0559                 MULX'S         $AX0.L, $AX1.L : @$AR1, $AC1.M
IRAM:055A
IRAM:055A loc_55A:
IRAM:055A                 MULXMV'S       $AX0.H, $AX1.L, $ACC0 : @$AR1, $AC1.L
IRAM:055B ; BLOOPI_END
IRAM:055B                 RET
IRAM:055B ; End of function transform_buffer_section