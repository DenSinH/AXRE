command_0:
IRAM:0082                 CLR            $ACC0
IRAM:0083 ; load next two words from stream into ac0 and ac1
IRAM:0083                 CLR'L          $ACC1 : $AC0.M, @$AR0
IRAM:0084                 SET16'L        $AC1.M : @$AR0
IRAM:0085 ; store DMA address
IRAM:0085                 SRS            DMAMMADDRH, $AC0.M
IRAM:0086                 SRS            DMAMMADDRL, $AC1.M
IRAM:0087 ; DSPADDR = 0xe44
IRAM:0087                 LRI            $AC0.M, 0xE44
IRAM:0089                 SRS            DMADSPADDR, $AC0.M
IRAM:008A ; DMAControl = 0
IRAM:008A ; to DSP DMEM
IRAM:008A                 LRIS           $AC0.M, 0
IRAM:008B                 SRS            DMAControl, $AC0.M
IRAM:008C ; length = 0x40 8bit bytes
IRAM:008C                 LRI            $AC0.M, 0x40
IRAM:008E                 SRS            DMALength, $AC0.M
IRAM:008F ; setup registers and wait for DMA
IRAM:008F                 LRI            $AR1, 0xE44
IRAM:0091                 LRI            $AR2, 0
IRAM:0093                 LRI            $AX1.H, 0x9F
IRAM:0095                 LRI            $AX0.H, 0x140
IRAM:0097                 CLR            $ACC0
IRAM:0098                 CLR            $ACC1
IRAM:0099                 SET40
IRAM:009A                 CALL           wait_for_dma_finish_0
IRAM:009C ; Load 2 words from 0x40 byte stream (BASE)
IRAM:009C                 LRRI           $AC0.M, @$AR1
IRAM:009D                 LRRI           $AC0.L, @$AR1
IRAM:009E                 TST            $ACC0
IRAM:009F ; load third word from stream (INCR)
IRAM:009F                 LRRI           $AC1.M, @$AR1
IRAM:00A0 ; if BASE is not 0: jump
IRAM:00A0                 JNZ            cmd0_BASE_not_0 ; AC1.M ASR16 -> AC1.L
IRAM:00A2 ; zero out 0x140 words at the start of ARAM (AR2 set to 0)
IRAM:00A2 ; for (i = 0; i < 0x140; i++) *dest++ = 0;
IRAM:00A2                 LOOP           $AX0.H
IRAM:00A3                 SRRI           @$AR2, $AC0.M
IRAM:00A4                 JMP            cmd0_dmem_140_words_filled
IRAM:00A6 ; ---------------------------------------------------------------------------
IRAM:00A6
IRAM:00A6 cmd0_BASE_not_0:
IRAM:00A6                 ASR16          $ACC1    ; AC1.M ASR16 -> AC1.L
IRAM:00A7 ; BASE to buffer at 0x0000
IRAM:00A7                 SRRI           @$AR2, $AC0.M
IRAM:00A8                 SRRI           @$AR2, $AC0.L
IRAM:00A9 ; loop 0x9f times
IRAM:00A9                 BLOOP          $AX1.H, loc_AD
IRAM:00AB ; BASE += INCR
IRAM:00AB
IRAM:00AB                 ADD            $ACC0, $ACC1
IRAM:00AC ; store BASE (with INCR added every loop)
IRAM:00AC ; 32 bit value
IRAM:00AC                 SRRI           @$AR2, $AC0.M
IRAM:00AD
IRAM:00AD loc_AD:
IRAM:00AD                 SRRI           @$AR2, $AC0.L
IRAM:00AE ; dest is now 0x140
IRAM:00AE ; load 2 more words from the DMA'ed stream (new BASE)
IRAM:00AE
IRAM:00AE cmd0_dmem_140_words_filled:
IRAM:00AE                 LRRI           $AC0.M, @$AR1
IRAM:00AF                 LRRI           $AC0.L, @$AR1
IRAM:00B0                 TST            $ACC0
IRAM:00B1 ; and another INCR word
IRAM:00B1                 LRRI           $AC1.M, @$AR1
IRAM:00B2 ; if BASE != 0: jump
IRAM:00B2                 JNZ            loc_B8   ; INCR ac1.m asr16 -> ac2.l
IRAM:00B4 ; zero out another 0x140 words if BASE is 0
IRAM:00B4                 LOOP           $AX0.H
IRAM:00B5                 SRRI           @$AR2, $AC0.M
IRAM:00B6                 JMP            cmd0_another_140_words_filled
IRAM:00B8 ; ---------------------------------------------------------------------------
IRAM:00B8
IRAM:00B8 loc_B8:
IRAM:00B8                 ASR16          $ACC1    ; INCR ac1.m asr16 -> ac2.l
IRAM:00B9 ; store BASE to dest
IRAM:00B9                 SRRI           @$AR2, $AC0.M
IRAM:00BA                 SRRI           @$AR2, $AC0.L
IRAM:00BB ; for (int i = 0; i < 0x9f; i++, BASE += INCR) {
IRAM:00BB ;     *dest++ = BASE >> 16;
IRAM:00BB ;     *dest++ = (word)BASE
IRAM:00BB ; }
IRAM:00BB                 BLOOP          $AX1.H, loc_BF
IRAM:00BD                 ADD            $ACC0, $ACC1
IRAM:00BE                 SRRI           @$AR2, $AC0.M
IRAM:00BF
IRAM:00BF loc_BF:
IRAM:00BF                 SRRI           @$AR2, $AC0.L
IRAM:00C0 ; dest is now 0x280
IRAM:00C0 ; same thing again
IRAM:00C0
IRAM:00C0 cmd0_another_140_words_filled:
IRAM:00C0                 LRRI           $AC0.M, @$AR1
IRAM:00C1                 LRRI           $AC0.L, @$AR1
IRAM:00C2                 TST            $ACC0
IRAM:00C3                 LRRI           $AC1.M, @$AR1
IRAM:00C4                 JNZ            loc_CA
IRAM:00C6                 LOOP           $AX0.H
IRAM:00C7                 SRRI           @$AR2, $AC0.M
IRAM:00C8                 JMP            cmd0_another_140_words_filled_1
IRAM:00CA ; ---------------------------------------------------------------------------
IRAM:00CA
IRAM:00CA loc_CA:
IRAM:00CA                 ASR16          $ACC1
IRAM:00CB                 SRRI           @$AR2, $AC0.M
IRAM:00CC                 SRRI           @$AR2, $AC0.L
IRAM:00CD                 BLOOP          $AX1.H, loc_D1
IRAM:00CF                 ADD            $ACC0, $ACC1
IRAM:00D0                 SRRI           @$AR2, $AC0.M
IRAM:00D1
IRAM:00D1 loc_D1:
IRAM:00D1                 SRRI           @$AR2, $AC0.L
IRAM:00D2 ; At this point, 3 * 0x140 = 0x3c0 words are filled at the start of DMEM
IRAM:00D2 ; ar2: dest = 0x400 // skip 0x40 bytes
IRAM:00D2
IRAM:00D2 cmd0_another_140_words_filled_1:
IRAM:00D2                 LRI            $AR2, 0x400
IRAM:00D4 ; again, load BASE and INCR
IRAM:00D4                 LRRI           $AC0.M, @$AR1
IRAM:00D5                 LRRI           $AC0.L, @$AR1
IRAM:00D6                 TST'L          $ACC0 : $AC1.M, @$AR1
IRAM:00D7                 JNZ            loc_DD
IRAM:00D9                 LOOP           $AX0.H
IRAM:00DA                 SRRI           @$AR2, $AC0.M
IRAM:00DB                 JMP            cmd0_140_filled_at_400
IRAM:00DD ; ---------------------------------------------------------------------------
IRAM:00DD
IRAM:00DD loc_DD:
IRAM:00DD                 ASR16          $ACC1
IRAM:00DE                 SRRI           @$AR2, $AC0.M
IRAM:00DF                 SRRI           @$AR2, $AC0.L
IRAM:00E0                 BLOOP          $AX1.H, loc_E4
IRAM:00E2                 ADD            $ACC0, $ACC1
IRAM:00E3                 SRRI           @$AR2, $AC0.M
IRAM:00E4
IRAM:00E4 loc_E4:
IRAM:00E4                 SRRI           @$AR2, $AC0.L
IRAM:00E5 ; again load BASE and INCR and fill 140 words
IRAM:00E5
IRAM:00E5 cmd0_140_filled_at_400:
IRAM:00E5                 LRRI           $AC0.M, @$AR1
IRAM:00E6                 LRRI           $AC0.L, @$AR1
IRAM:00E7                 TST'L          $ACC0 : $AC1.M, @$AR1
IRAM:00E8                 JNZ            loc_EE
IRAM:00EA                 LOOP           $AX0.H
IRAM:00EB                 SRRI           @$AR2, $AC0.M
IRAM:00EC                 JMP            cmd0_140_filled_at_540
IRAM:00EE ; ---------------------------------------------------------------------------
IRAM:00EE
IRAM:00EE loc_EE:
IRAM:00EE                 ASR16          $ACC1
IRAM:00EF                 SRRI           @$AR2, $AC0.M
IRAM:00F0                 SRRI           @$AR2, $AC0.L
IRAM:00F1                 BLOOP          $AX1.H, loc_F5
IRAM:00F3                 ADD            $ACC0, $ACC1
IRAM:00F4                 SRRI           @$AR2, $AC0.M
IRAM:00F5
IRAM:00F5 loc_F5:
IRAM:00F5                 SRRI           @$AR2, $AC0.L
IRAM:00F6 ; same thing again
IRAM:00F6
IRAM:00F6 cmd0_140_filled_at_540:
IRAM:00F6                 LRRI           $AC0.M, @$AR1
IRAM:00F7                 LRRI           $AC0.L, @$AR1
IRAM:00F8                 TST'L          $ACC0 : $AC1.M, @$AR1
IRAM:00F9                 JNZ            loc_FF
IRAM:00FB                 LOOP           $AX0.H
IRAM:00FC                 SRRI           @$AR2, $AC0.M
IRAM:00FD                 JMP            cmd0_140_filled_at_680
IRAM:00FF ; ---------------------------------------------------------------------------
IRAM:00FF
IRAM:00FF loc_FF:
IRAM:00FF                 ASR16          $ACC1
IRAM:0100                 SRRI           @$AR2, $AC0.M
IRAM:0101                 SRRI           @$AR2, $AC0.L
IRAM:0102                 BLOOP          $AX1.H, loc_106
IRAM:0104                 ADD            $ACC0, $ACC1
IRAM:0105                 SRRI           @$AR2, $AC0.M
IRAM:0106
IRAM:0106 loc_106:
IRAM:0106                 SRRI           @$AR2, $AC0.L
IRAM:0107 ; at this point, dest is already 0x7c0, not sure why the DSP loads it directly
IRAM:0107 ; going to do the same thing yet again
IRAM:0107
IRAM:0107 cmd0_140_filled_at_680:
IRAM:0107                 LRI            $AR2, 0x7C0
IRAM:0109                 LRRI           $AC0.M, @$AR1
IRAM:010A                 LRRI           $AC0.L, @$AR1
IRAM:010B                 TST'L          $ACC0 : $AC1.M, @$AR1
IRAM:010C                 JNZ            loc_112
IRAM:010E                 LOOP           $AX0.H
IRAM:010F                 SRRI           @$AR2, $AC0.M
IRAM:0110                 JMP            cmd0_140_filled_at_7c0
IRAM:0112 ; ---------------------------------------------------------------------------
IRAM:0112
IRAM:0112 loc_112:
IRAM:0112                 ASR16          $ACC1
IRAM:0113                 SRRI           @$AR2, $AC0.M
IRAM:0114                 SRRI           @$AR2, $AC0.L
IRAM:0115                 BLOOP          $AX1.H, loc_119
IRAM:0117                 ADD            $ACC0, $ACC1
IRAM:0118                 SRRI           @$AR2, $AC0.M
IRAM:0119
IRAM:0119 loc_119:
IRAM:0119                 SRRI           @$AR2, $AC0.L
IRAM:011A ; going to do the same thing again
IRAM:011A ; dest is now 0x900
IRAM:011A
IRAM:011A cmd0_140_filled_at_7c0:
IRAM:011A                 LRRI           $AC0.M, @$AR1
IRAM:011B                 LRRI           $AC0.L, @$AR1
IRAM:011C                 TST'L          $ACC0 : $AC1.M, @$AR1
IRAM:011D                 JNZ            loc_123
IRAM:011F                 LOOP           $AX0.H
IRAM:0120                 SRRI           @$AR2, $AC0.M
IRAM:0121                 JMP            cmd0_140_filled_at_900
IRAM:0123 ; ---------------------------------------------------------------------------
IRAM:0123
IRAM:0123 loc_123:
IRAM:0123                 ASR16          $ACC1
IRAM:0124                 SRRI           @$AR2, $AC0.M
IRAM:0125                 SRRI           @$AR2, $AC0.L
IRAM:0126                 BLOOP          $AX1.H, loc_12A
IRAM:0128                 ADD            $ACC0, $ACC1
IRAM:0129                 SRRI           @$AR2, $AC0.M
IRAM:012A
IRAM:012A loc_12A:
IRAM:012A                 SRRI           @$AR2, $AC0.L
IRAM:012B ; dest is now 0xa40
IRAM:012B ; same thing again
IRAM:012B
IRAM:012B cmd0_140_filled_at_900:
IRAM:012B                 LRRI           $AC0.M, @$AR1
IRAM:012C                 LRRI           $AC0.L, @$AR1
IRAM:012D                 TST'L          $ACC0 : $AC1.M, @$AR1
IRAM:012E                 JNZ            loc_134
IRAM:0130                 LOOP           $AX0.H
IRAM:0131                 SRRI           @$AR2, $AC0.M
IRAM:0132                 JMP            cmd0_done
IRAM:0134 ; ---------------------------------------------------------------------------
IRAM:0134
IRAM:0134 loc_134:
IRAM:0134                 ASR16          $ACC1
IRAM:0135                 SRRI           @$AR2, $AC0.M
IRAM:0136                 SRRI           @$AR2, $AC0.L
IRAM:0137                 BLOOP          $AX1.H, loc_13B
IRAM:0139                 ADD            $ACC0, $ACC1
IRAM:013A                 SRRI           @$AR2, $AC0.M
IRAM:013B
IRAM:013B loc_13B:
IRAM:013B                 SRRI           @$AR2, $AC0.L
IRAM:013C ; dest should end up at 0xb80
IRAM:013C
IRAM:013C cmd0_done:
IRAM:013C                 JMP            receive_command
IRAM:013C ; End of function command_0