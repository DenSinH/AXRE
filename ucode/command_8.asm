command_8:                              ; DATA XREF: IRAM:command_jump_table↑o
IRAM:0B37                 SET16
IRAM:0B38                 CLR            $ACC0
IRAM:0B39 ; read mmaddr from command stream
IRAM:0B39 ; DMA 0x100 bytes to 0xe80 from mmaddr
IRAM:0B39                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:0B3A                 LRRI           $AC0.L, @$AR0
IRAM:0B3B                 SRS            DMAMMADDRH, $AC0.M
IRAM:0B3C                 SRS            DMAMMADDRL, $AC0.L
IRAM:0B3D                 SI             DMADSPADDR, 0xE80
IRAM:0B3F                 SI             DMAControl, 0
IRAM:0B41                 SI             DMALength, 0x100
IRAM:0B43 ; save mmaddr in AX1
IRAM:0B43                 MRR            $AX1.H, $AC0.M
IRAM:0B44                 MRR            $AX1.L, $AC0.L
IRAM:0B45                 CLR            $ACC0
IRAM:0B46 ; wait for DMA to finish
IRAM:0B46
IRAM:0B46 loc_B46:                                ; CODE XREF: IRAM:0B49↓j
IRAM:0B46                 LRS            $AC0.M, DMAControl
IRAM:0B47                 ANDF           $AC0.M, 4
IRAM:0B49                 JLNZ           loc_B46
IRAM:0B4B ; read another mmaddr from command stream and DMA 0x280 bytes to 0x280
IRAM:0B4B                 LRRI           $AC0.M, @$AR0
IRAM:0B4C                 LRRI           $AC0.L, @$AR0
IRAM:0B4D                 SRS            DMAMMADDRH, $AC0.M
IRAM:0B4E                 SRS            DMAMMADDRL, $AC0.L
IRAM:0B4F                 SI             DMADSPADDR, 0x280
IRAM:0B51                 SI             DMAControl, 0
IRAM:0B53                 SI             DMALength, 0x280
IRAM:0B55 ; save command stream pointer
IRAM:0B55                 MRR            $IX0, $AR0
IRAM:0B56 ; ar0: data_ptr, pointer to DMAd data
IRAM:0B56                 LRI            $AR0, 0x280
IRAM:0B58                 LR             $AR1, byte_E1B ; written to in main_entry (0xe80)
IRAM:0B5A ; IX1 = 0
IRAM:0B5A ; WR1 = 0x7f
IRAM:0B5A ; AR2 = 0xf00
IRAM:0B5A ; IX3 = AR3 = 0x16b4 (in DSP_COEF)
IRAM:0B5A ; AR1: buffer_f00, wrap every 0x80 bytes
IRAM:0B5A ; AR3: coef
IRAM:0B5A                 LRI            $IX1, 0
IRAM:0B5C                 LRI            $WR1, 0x7F
IRAM:0B5E                 LRI            $AR2, 0xF00
IRAM:0B60                 LRI            $AR3, 0x16B4
IRAM:0B62                 MRR            $IX3, $AR3
IRAM:0B63                 CLR            $ACC0
IRAM:0B64 ; wait for DMA to finish
IRAM:0B64
IRAM:0B64 loc_B64:                                ; CODE XREF: IRAM:0B67↓j
IRAM:0B64                 LRS            $AC0.M, DMAControl
IRAM:0B65                 ANDF           $AC0.M, 4
IRAM:0B67                 JLNZ           loc_B64
IRAM:0B69                 SET40
IRAM:0B6A ; u32 data = *(u32*)data_ptr++;
IRAM:0B6A                 M2'L           $AC1.M : @$AR0
IRAM:0B6B                 CLR15'L        $AC1.L : @$AR0
IRAM:0B6C                 LSL16          $ACC1
IRAM:0B6D ; *ptr_E1B = data.lo
IRAM:0B6D                 SRR            @$AR1, $AC1.M
IRAM:0B6E ; AX0.H = AX1.L = *coef++
IRAM:0B6E                 CLRP'LD        $AX0.H : $AX1.L, @$AR3
IRAM:0B6F ; prod = 0
IRAM:0B6F                 LOOPI          0x7E
IRAM:0B70 ; WHAT IS AX0.L INITIALLY??
IRAM:0B70
IRAM:0B70 ; repeat 0x7e:
IRAM:0B70 ;     prod += AX0.L * AX0.H
IRAM:0B70 ;     AX0.H = AX1.L = *coef++
IRAM:0B70                 MADD'LD        $AX0.L, $AX0.H : $AX0.H, $AX1.L, @$AR3 ; REPEAT 0x7e = 126 times
IRAM:0B71 ; prod += AX0.L * AX0.H
IRAM:0B71 ; AX0.H = AX1.L = *coef
IRAM:0B71 ; coef += 0x16b4 (this doesnt matter because ar3 is reloaded after this)
IRAM:0B71                 MADD'LDN       $AX0.L, $AX0.H : $AX0.H, $AX1.L, @$AR3
IRAM:0B72 ; ac0 = prod + AX0.L * AX0.H
IRAM:0B72 ; ac1.ml = *(u32*)data_ptr++
IRAM:0B72                 MADD'L         $AX0.L, $AX0.H : $AC1.M, @$AR0
IRAM:0B73                 MOVP'L         $ACC0 : $AC1.L, @$AR0
IRAM:0B74 ; ac1 <<= 16
IRAM:0B74 ; *buffer_f00++ = ac0.m
IRAM:0B74                 LSL16'S        $ACC1 : @$AR2, $AC0.M
IRAM:0B75                 SRR            @$AR1, $AC1.M
IRAM:0B76 ; REPEAT 0x9e = 158 TIMES
IRAM:0B76                 BLOOPI         0x9E, loc_B80
IRAM:0B78 ; coef = 0x16b4
IRAM:0B78                 MRR            $AR3, $IX3
IRAM:0B79 ; same thing as before
IRAM:0B79                 CLRP'LD        $AX0.H : $AX1.L, @$AR3
IRAM:0B7A                 LOOPI          0x7E
IRAM:0B7B                 MADD'LD        $AX0.L, $AX0.H : $AX0.H, $AX1.L, @$AR3
IRAM:0B7C                 MADD'LDN       $AX0.L, $AX0.H : $AX0.H, $AX1.L, @$AR3
IRAM:0B7D                 MADD'L         $AX0.L, $AX0.H : $AC1.M, @$AR0
IRAM:0B7E                 MOVP'L         $ACC0 : $AC1.L, @$AR0
IRAM:0B7F                 LSL16'S        $ACC1 : @$AR2, $AC0.M
IRAM:0B80                 SRR            @$AR1, $AC1.M
IRAM:0B81 ; BLOOPI END
IRAM:0B81                 MRR            $AR3, $IX3
IRAM:0B82 ; restore coef = 0x16b4
IRAM:0B82 ; same thing as before
IRAM:0B82                 CLRP'LD        $AX0.H : $AX1.L, @$AR3
IRAM:0B83                 LOOPI          0x7E
IRAM:0B84                 MADD'LD        $AX0.L, $AX0.H : $AX0.H, $AX1.L, @$AR3
IRAM:0B85                                         ; command_3+17C↑r
IRAM:0B85                 MADD'LDN       $AX0.L, $AX0.H : $AX0.H, $AX1.L, @$AR3
IRAM:0B86                 MADD           $AX0.L, $AX0.H
IRAM:0B87                 MOVP           $ACC0
IRAM:0B88                 SRRI           @$AR2, $AC0.M
IRAM:0B89 ; store end of 0xf00 buffer to e1b
IRAM:0B89                 SR             byte_E1B, $AR1
IRAM:0B8B                 LRI            $AR0, 0x280
IRAM:0B8D                 LRI            $AR3, 0xF00
IRAM:0B8F                 LRI            $AR1, 0
IRAM:0B91                 LRI            $AR2, 0x140
IRAM:0B93                 LRI            $WR1, 0xFFFF
IRAM:0B95                 CLR            $ACC1
IRAM:0B96                 CLR            $ACC0
IRAM:0B97                 SET40
IRAM:0B98 REPEAT 0xa0 = 160 TIMES
IRAM:0B98                 BLOOPI         0xA0, loc_BA0
IRAM:0B9A ; ac1.ml = EXTS16(*buffer_f00++)
IRAM:0B9A ; *buffer_280++ = 0
IRAM:0B9A ; *buffer_280++ = 0
IRAM:0B9A                 LRRI           $AC1.M, @$AR3
IRAM:0B9B                 ASR16'S        $ACC1 : @$AR0, $AC0.M
IRAM:0B9C                 SRRI           @$AR0, $AC0.M
IRAM:0B9D ; store ac1.ml to *buffer_0++, *buffer_0++
IRAM:0B9D                 SRRI           @$AR1, $AC1.M
IRAM:0B9E                 NEG'S          $ACC1 : @$AR1, $AC1.L
IRAM:0B9F ; store -ac1.ml to *buffer_140++, *buffer_140++
IRAM:0B9F                 SRRI           @$AR2, $AC1.M
IRAM:0BA0                 SRRI           @$AR2, $AC1.L
IRAM:0BA1 ; BLOOPI END
IRAM:0BA1                 SET16
IRAM:0BA2 ; restore mmaddr
IRAM:0BA2                 MRR            $AC0.M, $AX1.H
IRAM:0BA3                 MRR            $AC0.L, $AX1.L
IRAM:0BA4 ; DMA DMEM 0xe80 back to main memory
IRAM:0BA4                 SRS            DMAMMADDRH, $AC0.M
IRAM:0BA5                 SRS            DMAMMADDRL, $AC0.L
IRAM:0BA6
IRAM:0BA6 loc_BA6:                                ; DATA XREF: command_2+2A↑r
IRAM:0BA6                                         ; command_3+165↑r
IRAM:0BA6                 SI             DMADSPADDR, 0xE80
IRAM:0BA8
IRAM:0BA8 DMEM_BA8:                               ; DATA XREF: command_2+2C↑r
IRAM:0BA8                                         ; command_3+167↑r
IRAM:0BA8                 SI             DMAControl, 1
IRAM:0BAA                 SI             DMALength, 0x100
IRAM:0BAC                 CALL           wait_for_dma_finish_0
IRAM:0BAE ; restore command_stream pointer
IRAM:0BAE                 MRR            $AR0, $IX0
IRAM:0BAF                 JMP            receive_comman