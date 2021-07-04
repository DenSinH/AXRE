IRAM:0484 mix_buffers:
IRAM:0484                                         ; command_4+10↑p ...
IRAM:0484                 SET16
IRAM:0485 ; IX2 holds some address:
IRAM:0485 ;     0x400 for cmd4
IRAM:0485 ;     0x7c0 for cmd9/5
IRAM:0485
IRAM:0485 ; read main memory address from command stream
IRAM:0485 ; store in AC1.ml and AX0.hl
IRAM:0485                 LRRI           $AC1.M, @$AR0
IRAM:0486                 LRRI           $AC1.L, @$AR0
IRAM:0487                 MRR            $AX0.H, $AC1.M
IRAM:0488                 MRR            $AX0.L, $AC1.L
IRAM:0489 ; start DMA from main memory address to DSP DMEM 0x400 length 0xc0
IRAM:0489                 SRS            DMAMMADDRH, $AC1.M
IRAM:048A                 SRS            DMAMMADDRL, $AC1.L
IRAM:048B                 CLR            $ACC1
IRAM:048C                 MRR            $AC1.L, $IX2
IRAM:048D                 SRS            DMADSPADDR, $AC1.L
IRAM:048E                 LRIS           $AC0.M, 0
IRAM:048F                 SRS            DMAControl, $AC0.M
IRAM:0490                 CLR            $ACC0
IRAM:0491                 LRI            $AC0.L, 0xC0
IRAM:0493                 SRS            DMALength, $AC0.L
IRAM:0494 ; save command stream pointer
IRAM:0494                 MRR            $IX1, $AR0
IRAM:0495 ; ar1: 0xe44
IRAM:0495 ; ac0: mmaddr + 0xc0
IRAM:0495                 LRI            $AR1, 0xE44
IRAM:0497                 ADDAX          $ACC0, $AX0
IRAM:0498 ; *(u32*)0xe44 = ac0  (mmaddr + 0xc0)
IRAM:0498                 SRRI           @$AR1, $AC0.M
IRAM:0499                 SRRI           @$AR1, $AC0.L
IRAM:049A                 LRIS           $AX1.H, 0
IRAM:049B                 LRI            $AX1.L, 0x60
IRAM:049D ac1 = 0x400 + 0x60
IRAM:049D                 ADDAX          $ACC1, $AX1
IRAM:049E *0xe46 = ac1
IRAM:049E                 SRRI           @$AR1, $AC1.L
IRAM:049F ar1 = 0xe44
IRAM:049F ar0 = 0x400
IRAM:049F ar2 = ar3 = 0
IRAM:049F                 LRI            $AR1, 0xE44
IRAM:04A1                 MRR            $AR0, $IX2
IRAM:04A2                 LRI            $AR3, 0
IRAM:04A4                 MRR            $AR2, $AR3
IRAM:04A5
IRAM:04A5 cmdf_wait_for_dma_finish:
IRAM:04A5                 LRS            $AC1.M, DMAControl
IRAM:04A6                 ANDF           $AC1.M, 4
IRAM:04A8                 JLNZ           cmdf_wait_for_dma_finish
IRAM:04AA REPEAT 9 TIMES
IRAM:04AA                 BLOOPI         9, loc_4DA
IRAM:04AC                 SET16
IRAM:04AD read mmaddr from 0xe44
IRAM:04AD     recall: we stored one right before this
IRAM:04AD                 LRRI           $AX0.H, @$AR1
IRAM:04AE                 LRRI           $AX0.L, @$AR1
IRAM:04AF AX0 still holds initial MMADDR
IRAM:04AF                 MOVAX          $ACC1, $AX0
IRAM:04B0                 SRS            DMAMMADDRH, $AC1.M
IRAM:04B1                 SRS            DMAMMADDRL, $AC1.L
IRAM:04B2                 CLR            $ACC1
IRAM:04B3 read dsp address from 0xe44 buffer
IRAM:04B3     recal: we stored one right before this
IRAM:04B3                 LRRI           $AC1.L, @$AR1
IRAM:04B4                 SRS            DMADSPADDR, $AC1.L
IRAM:04B5                 SI             DMAControl, 0
IRAM:04B7 DMA length 0xc0
IRAM:04B7                 CLR            $ACC0
IRAM:04B8                 LRI            $AC0.L, 0xC0
IRAM:04BA                 SRS            DMALength, $AC0.L
IRAM:04BB restore ar1 pointer to address data
IRAM:04BB                 LRI            $AR1, 0xE44
IRAM:04BD ac0 = mmaddr + 0xc0
IRAM:04BD                 ADDAX          $ACC0, $AX0
IRAM:04BE store mmaddr + 0xc0 again (keep incrementing)
IRAM:04BE                 SRRI           @$AR1, $AC0.M
IRAM:04BF                 SRRI           @$AR1, $AC0.L
IRAM:04C0 store dspaddr + 0x60 again (keep incrementing)
IRAM:04C0                 LRIS           $AX1.H, 0
IRAM:04C1                 LRIS           $AX1.L, 0x60
IRAM:04C2                 ADDAX          $ACC1, $AX1
IRAM:04C3                 SRRI           @$AR1, $AC1.L
IRAM:04C4 restore ar1 pointer to address data
IRAM:04C4                 LRI            $AR1, 0xE44
IRAM:04C6                 SET40
IRAM:04C7 ; ar0 holds 0x400 in first iteration
IRAM:04C7 ; ar3 holds 0 in first iteration
IRAM:04C7                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:04C8                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:04C9                 MOVAX          $ACC0, $AX1
IRAM:04CA                 ADDAX          $ACC0, $AX0
IRAM:04CB ;     REPEAT 0x17 TIMES
IRAM:04CB                 BLOOPI         0x17, loc_4D4
IRAM:04CD                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:04CE                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:04CF                 MOVAX'S        $ACC1, $AX1 : @$AR2, $AC0.M
IRAM:04D0                 ADDAX'S        $ACC1, $AX0 : @$AR2, $AC0.L
IRAM:04D1                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:04D2                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:04D3                 MOVAX'S        $ACC0, $AX1 : @$AR2, $AC1.M
IRAM:04D4
IRAM:04D4 loc_4D4:
IRAM:04D4                 ADDAX'S        $ACC0, $AX0 : @$AR2, $AC1.L
IRAM:04D5 ;     BLOOPI END
IRAM:04D5                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:04D6                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:04D7                 MOVAX'S        $ACC1, $AX1 : @$AR2, $AC0.M
IRAM:04D8                 ADDAX'S        $ACC1, $AX0 : @$AR2, $AC0.L
IRAM:04D9                 SRRI           @$AR2, $AC1.M
IRAM:04DA
IRAM:04DA loc_4DA:
IRAM:04DA                 SRRI           @$AR2, $AC1.L
IRAM:04DB ; BLOOPI END
IRAM:04DB                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:04DC                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:04DD                 MOVAX          $ACC0, $AX1
IRAM:04DE                 ADDAX          $ACC0, $AX0
IRAM:04DF                 BLOOPI         0x17, loc_4E8
IRAM:04E1                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:04E2                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:04E3                 MOVAX'S        $ACC1, $AX1 : @$AR2, $AC0.M
IRAM:04E4                 ADDAX'S        $ACC1, $AX0 : @$AR2, $AC0.L
IRAM:04E5                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:04E6                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:04E7                 MOVAX'S        $ACC0, $AX1 : @$AR2, $AC1.M
IRAM:04E8
IRAM:04E8 loc_4E8:
IRAM:04E8                 ADDAX'S        $ACC0, $AX0 : @$AR2, $AC1.L
IRAM:04E9                 NX'LD          $AX0.H : $AX1.H, @$AR0
IRAM:04EA                 NX'LD          $AX0.L : $AX1.L, @$AR0
IRAM:04EB                 MOVAX'S        $ACC1, $AX1 : @$AR2, $AC0.M
IRAM:04EC                 ADDAX'S        $ACC1, $AX0 : @$AR2, $AC0.L
IRAM:04ED                 SRRI           @$AR2, $AC1.M
IRAM:04EE                 SRRI           @$AR2, $AC1.L
IRAM:04EF ; restore command stream pointer
IRAM:04EF                 MRR            $AR0, $IX1
IRAM:04F0                 RET