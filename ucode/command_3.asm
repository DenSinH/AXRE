; =============== S U B R O U T I N E =======================================
IRAM:0248
IRAM:0248
IRAM:0248 command_3:                              ; CODE XREF: command_3+1B9↓j
IRAM:0248                                         ; command_3+1C9↓j
IRAM:0248                                         ; DATA XREF: ...
IRAM:0248                 SET16
IRAM:0249 ; save command_stream pointer
IRAM:0249                 SR             cmd3_temp_command_stream, $AR0
IRAM:024B ; AR0 holds pointer to address in region where cmd2 DMAs to
IRAM:024B ; AR1 holds pointer to start of region cmd2 DMAs to (second DMA)
IRAM:024B
IRAM:024B ; ar0: buffer_ba2
IRAM:024B ; ar1: buffer_3c0
IRAM:024B                 LRI            $AR0, 0xBA2
IRAM:024D                 LRI            $AR1, 0x3C0
IRAM:024F                 LRIS           $AC0.M, 5
IRAM:0250                 SR             cmd3_loop_counter, $AC0.M
IRAM:0252                 CLR            $ACC1
IRAM:0253 ; load loop length from buffer_ba2
IRAM:0253
IRAM:0253 cmd3_loop_5_start:                      ; CODE XREF: command_3+109↓j
IRAM:0253                 CLR'L          $ACC0 : $AX0.H, @$AR0
IRAM:0254                 LRI            $AC1.M, 0xB80
IRAM:0256                 BLOOP          $AX0.H, loc_25B
IRAM:0258 ; dest = *(buffer_3c0++) + 0xb80
IRAM:0258                 LRRI           $AC0.M, @$AR1
IRAM:0259                 ADD'L          $ACC0, $ACC1 : $AX1.L, @$AR1
IRAM:025A                 MRR            $AR2, $AC0.M
IRAM:025B ; *dest = *(buffer_3c0++)
IRAM:025B
IRAM:025B loc_25B:                                ; CODE XREF: command_3+E↑j
IRAM:025B                 SRR            @$AR2, $AX1.L
IRAM:025C ; BLOOP END
IRAM:025C
IRAM:025C ; save buffer_3c0 end pointer to E05
IRAM:025C ; save buffer_ba2 end pointer to E06 (should just be ba3)
IRAM:025C                 LRI            $AR3, cmd3_temp_AR1
IRAM:025E                 SRRI           @$AR3, $AR1
IRAM:025F                 SRRI           @$AR3, $AR0
IRAM:0260 ; check flag in struct from command 2
IRAM:0260                 LR             $AC0.M, cmd3_flag_B87
IRAM:0262                 CMPIS          $AC0.M, 1
IRAM:0263                 JZ             cmd3_struct_flag_1
IRAM:0265                 JMP            cmd3_struct_flag_0
IRAM:0267 ; ---------------------------------------------------------------------------
IRAM:0267 if [b87] == 1
IRAM:0267
IRAM:0267 cmd3_struct_flag_1:                     ; CODE XREF: command_3+1B↑j
IRAM:0267                 LR             $AC0.M, cmd2_DMEM_E42
IRAM:0269 ; load pointer setup by command 2
IRAM:0269 ; load value from E15 (from struct, setup by command 2)
IRAM:0269                 SR             byte_E1C, $AC0.M
IRAM:026B ; call pointer
IRAM:026B                 LR             $AR3, DMEM_E15
IRAM:026D                 CALLR          $AR3
IRAM:026E ; reset state
IRAM:026E                 SET16
IRAM:026F                 M2
IRAM:0270                 CLR            $ACC0
IRAM:0271                 CLR            $ACC1
IRAM:0272 ; load data from struct
IRAM:0272                 LR             $AC0.M, loc_BB3
IRAM:0274                 LR             $AC1.M, loc_BB2
IRAM:0276 ; ac1.m = [bb3] + [bb2]
IRAM:0276 ; ax0.l = [bb2]
IRAM:0276 ; ax1.h = [bb3] << 1
IRAM:0276 ; ac0.m = [bb2]
IRAM:0276 ; ax0.l = 0x8000
IRAM:0276                 MRR            $AX0.L, $AC1.M
IRAM:0277                 ADD            $ACC1, $ACC0
IRAM:0278                 ASL            $ACC0, 1
IRAM:0279                 SET15'MV       $AX1.H : $AC0.M
IRAM:027A                 MRR            $AC0.M, $AX0.L
IRAM:027B                 LRI            $AX0.L, 0x8000
IRAM:027D ; load pointer to e44
IRAM:027D                 LRI            $AR0, byte_E44
IRAM:027F ; prod = ax0.l * ax1.l
IRAM:027F ; *buffer_e44++ = ac0.m
IRAM:027F ; repeatedly:
IRAM:027F ;     ac0 += prod
IRAM:027F ;     prod = ax0.l * ax1.l
IRAM:027F ;     *buffer_e44++ = ac1.m
IRAM:027F ;     ac1 += prod
IRAM:027F ;     prod = ax0.l * ax1.l
IRAM:027F ;     *buffer_e44++ = ac0.m
IRAM:027F                 MULX'S         $AX0.L, $AX1.H : @$AR0, $AC0.M
IRAM:0280                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0281                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:0282                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0283                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:0284                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0285                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:0286                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0287                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:0288                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0289                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:028A                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:028B                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:028C                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:028D                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:028E                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:028F                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:0290                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0291                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:0292                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0293                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:0294                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0295                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:0296                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0297                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:0298                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:0299                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:029A                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:029B                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:029C                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:029D                 MULXAC'S       $AX0.L, $AX1.H, $ACC1 : @$AR0, $AC0.M
IRAM:029E                 MULXAC'S       $AX0.L, $AX1.H, $ACC0 : @$AR0, $AC1.M
IRAM:029F ; store final resulting ac0.m in struct
IRAM:029F                 SR             loc_BB2, $AC0.M
IRAM:02A1                 SET40
IRAM:02A2 ; pointer to buffer at 0xe44 again
IRAM:02A2 ; load second word stored by command 2
IRAM:02A2                 LRI            $AR0, byte_E44
IRAM:02A4                 LR             $AR1, cmd2_DMEM_E43
IRAM:02A6                 MRR            $AR3, $AR1
IRAM:02A7                 LRRI           $AX0.H, @$AR1
IRAM:02A8                 LRRI           $AX0.L, @$AR0
IRAM:02A9 ; AC[1 - d] = prod
IRAM:02A9 ; prod = AXd.l * AXd.h
IRAM:02A9 ; AX[1 - d].h = *buffer_pointed_by_e43
IRAM:02A9 ; AX[1 - d].l = *buffer_e44++
IRAM:02A9 ; *buffer_pointed_by_e43++ = AC[1 - d].m  // buffer_pointed_by_e43 in both ar1 and ar3
IRAM:02A9                 MUL'L          $AX0.L, $AX0.H : $AX1.H, @$AR1
IRAM:02AA                 LRRI           $AX1.L, @$AR0
IRAM:02AB                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02AC                 NX'LS          $AX0.L : $AC0.M
IRAM:02AD                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02AE                 NX'LS          $AX1.L : $AC1.M
IRAM:02AF                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02B0                 NX'LS          $AX0.L : $AC0.M
IRAM:02B1                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02B2                 NX'LS          $AX1.L : $AC1.M
IRAM:02B3                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02B4                 NX'LS          $AX0.L : $AC0.M
IRAM:02B5                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02B6                 NX'LS          $AX1.L : $AC1.M
IRAM:02B7                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02B8                 NX'LS          $AX0.L : $AC0.M
IRAM:02B9                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02BA                 NX'LS          $AX1.L : $AC1.M
IRAM:02BB                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02BC                 NX'LS          $AX0.L : $AC0.M
IRAM:02BD                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02BE                 NX'LS          $AX1.L : $AC1.M
IRAM:02BF                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02C0                 NX'LS          $AX0.L : $AC0.M
IRAM:02C1                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02C2                 NX'LS          $AX1.L : $AC1.M
IRAM:02C3                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02C4                 NX'LS          $AX0.L : $AC0.M
IRAM:02C5                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02C6                 NX'LS          $AX1.L : $AC1.M
IRAM:02C7                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02C8                 NX'LS          $AX0.L : $AC0.M
IRAM:02C9                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02CA                 NX'LS          $AX1.L : $AC1.M
IRAM:02CB                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02CC                 NX'LS          $AX0.L : $AC0.M
IRAM:02CD                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02CE                 NX'LS          $AX1.L : $AC1.M
IRAM:02CF                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02D0                 NX'LS          $AX0.L : $AC0.M
IRAM:02D1                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02D2                 NX'LS          $AX1.L : $AC1.M
IRAM:02D3                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02D4                 NX'LS          $AX0.L : $AC0.M
IRAM:02D5                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02D6                 NX'LS          $AX1.L : $AC1.M
IRAM:02D7                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02D8                 NX'LS          $AX0.L : $AC0.M
IRAM:02D9                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02DA                 NX'LS          $AX1.L : $AC1.M
IRAM:02DB                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02DC                 NX'LS          $AX0.L : $AC0.M
IRAM:02DD                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02DE                 NX'LS          $AX1.L : $AC1.M
IRAM:02DF                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02E0                 NX'LS          $AX0.L : $AC0.M
IRAM:02E1                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02E2                 NX'LS          $AX1.L : $AC1.M
IRAM:02E3                 MULMV'L        $AX1.L, $AX1.H, $ACC0 : $AX0.H, @$AR1
IRAM:02E4                 NX'LS          $AX0.L : $AC0.M
IRAM:02E5                 MULMV'L        $AX0.L, $AX0.H, $ACC1 : $AX1.H, @$AR1
IRAM:02E6                 NX'LS          $AX1.L : $AC1.M
IRAM:02E7                 MULMV          $AX1.L, $AX1.H, $ACC0
IRAM:02E8 ; last step is different
IRAM:02E8                 MOVP'S         $ACC1 : @$AR3, $AC0.M
IRAM:02E9                 SRRI           @$AR3, $AC1.M
IRAM:02EA ; call data from command 2
IRAM:02EA                 LR             $AR3, DMEM_E14
IRAM:02EC ; reset state
IRAM:02EC                 SET40
IRAM:02ED                 SET15
IRAM:02EE                 M2
IRAM:02EF                 CALLR          $AR3
IRAM:02F0                 CLR            $ACC0
IRAM:02F1 ; load data from struct
IRAM:02F1                 LR             $AC0.M, DMEM_B9B
IRAM:02F3                 TST            $ACC0
IRAM:02F4                 JZ             cmd3_struct_data_0
IRAM:02F6 ; transfer data from command 2
IRAM:02F6                 LR             $AC0.M, cmd2_DMEM_E42
IRAM:02F8                 SR             cmd2_DMEM_E43, $AC0.M
IRAM:02FA                 CLR            $ACC0
IRAM:02FB                 CLR            $ACC1
IRAM:02FC                 LR             $AC0.M, loc_B9E
IRAM:02FE                 LR             $AC1.M, loc_BA0
IRAM:0300                 CMP
IRAM:0301 ; if [b9e] <= [ba0]:
IRAM:0301 ;     [b9e]++
IRAM:0301 ; else:
IRAM:0301 ;     [b9e]--
IRAM:0301                 JLE            loc_306
IRAM:0303                 DECM           $AC0.M
IRAM:0304                 JMP            loc_309
IRAM:0306 ; ---------------------------------------------------------------------------
IRAM:0306
IRAM:0306 loc_306:                                ; CODE XREF: command_3+B9↑j
IRAM:0306                 JZ             loc_309
IRAM:0308                 INCM           $AC0.M
IRAM:0309
IRAM:0309 loc_309:                                ; CODE XREF: command_3+BC↑j
IRAM:0309                                         ; command_3:loc_306↑j
IRAM:0309                 SR             loc_B9E : $AC0.M,
IRAM:030B ; [e40] = [e43] + 0xe0 + [b9e]  // the incr/decr [b9e]
IRAM:030B                 LR             $AC1.M, cmd2_DMEM_E43
IRAM:030D                 ADDIS          $AC1.M, 0xE0
IRAM:030E                 ADD            $ACC0, $ACC1
IRAM:030F                 SR             cmd2_DMEM_E40_start, $AC0.M
IRAM:0311                 CLR            $ACC0
IRAM:0312                 CLR            $ACC1
IRAM:0313 ; if [b9f] <= [ba1]:
IRAM:0313 ;     [b9f]++
IRAM:0313 ; else:
IRAM:0313 ;     [b9f]--
IRAM:0313                 LR             $AC0.M, loc_B9F
IRAM:0315                 LR             $AC1.M, loc_BA1
IRAM:0317                 CMP
IRAM:0318                 JLE            loc_31D
IRAM:031A                 DECM           $AC0.M
IRAM:031B                 JMP            loc_320
IRAM:031D ; ---------------------------------------------------------------------------
IRAM:031D
IRAM:031D loc_31D:                                ; CODE XREF: command_3+D0↑j
IRAM:031D                 JZ             loc_320
IRAM:031F                 INCM           $AC0.M
IRAM:0320
IRAM:0320 loc_320:                                ; CODE XREF: command_3+D3↑j
IRAM:0320                                         ; command_3:loc_31D↑j
IRAM:0320                 SR             loc_B9F : $AC0.M,
IRAM:0322 ; [e41] = [e43] + 0xe0 + [b9f]
IRAM:0322                 LR             $AC1.M, cmd2_DMEM_E43
IRAM:0324                 ADDIS          $AC1.M, 0xE0
IRAM:0325                 ADD            $ACC0, $ACC1
IRAM:0326                 SR             cmd2_DMEM_E41_end, $AC0.M
IRAM:0328                 JMP            cmd3_struct_flag_0
IRAM:032A ; ---------------------------------------------------------------------------
IRAM:032A
IRAM:032A cmd3_struct_data_0:                     ; CODE XREF: command_3+AC↑j
IRAM:032A                 LR             $AC0.M, cmd2_DMEM_E42
IRAM:032C ; [e40] = [e41] = [e43] = [e42]
IRAM:032C                 SR             cmd2_DMEM_E40_start, $AC0.M
IRAM:032E                 SR             cmd2_DMEM_E41_end, $AC0.M
IRAM:0330                 SR             cmd2_DMEM_E43, $AC0.M
IRAM:0332 if [b87] != 1
IRAM:0332
IRAM:0332 cmd3_struct_flag_0:                     ; CODE XREF: command_3+1D↑j
IRAM:0332                                         ; command_3+E0↑j
IRAM:0332                 CLR            $ACC0
IRAM:0333 ; reset state
IRAM:0333                 SET16
IRAM:0334                 CLRP
IRAM:0335                 CLR            $ACC1
IRAM:0336                 MRR            $PROD.M2, $AC0.M
IRAM:0337                 LRIS           $AC0.M, 0x40
IRAM:0338 ; prod.m = 0x40
IRAM:0338 ; ac1.m - 0x40
IRAM:0338 ; ar0 = ar3 = 0xe08
IRAM:0338                 MRR            $PROD.M1, $AC0.M
IRAM:0339                 LRI            $AR3, buffer_sections_E08
IRAM:033B                 MRR            $AR0, $AR3
IRAM:033C                 MRR            $AC1.M, $PROD.M1
IRAM:033D ; ax0.h = *buffer_sections_e08++;
IRAM:033D ; first step is slightly different
IRAM:033D ; repeatedly:
IRAM:033D ;    ac0.hm = prod.m (=0x40) + ax0.h
IRAM:033D ;    ax1.h = *buffer_sections_e08;
IRAM:033D ;    *buffer_sections_e08 = ac1.m;
IRAM:033D ;    buffer_sections_e08++;   // both AR0 and AR3
IRAM:033D ;    ac1.hm = prod.m (=0x40) + ax1.h
IRAM:033D ;    ax0.h = *buffer_sections_e08;
IRAM:033D ;    *buffer_sections_e08 = ac0.m;
IRAM:033D ;    buffer_sections_e08++;   // both AR0 and AR3
IRAM:033D
IRAM:033D                 LRRI           $AX0.H, @$AR0
IRAM:033E                 ADDPAXZ'L      $ACC0, $AX0 : $AX1.H, @$AR0
IRAM:033F                 ADDPAXZ'LS     $ACC1, $AX1 : $AX0.H, $AC0.M
IRAM:0340                 ADDPAXZ'LS     $ACC0, $AX0 : $AX1.H, $AC1.M
IRAM:0341                 ADDPAXZ'LS     $ACC1, $AX1 : $AX0.H, $AC0.M
IRAM:0342                 ADDPAXZ'LS     $ACC0, $AX0 : $AX1.H, $AC1.M
IRAM:0343                 ADDPAXZ'LS     $ACC1, $AX1 : $AX0.H, $AC0.M
IRAM:0344                 ADDPAXZ'LS     $ACC0, $AX0 : $AX1.H, $AC1.M
IRAM:0345                 ADDPAXZ'LS     $ACC1, $AX1 : $AX0.H, $AC0.M
IRAM:0346                 ADDPAXZ'S      $ACC0, $AX0 : @$AR3, $AC1.M
IRAM:0347                 SRRI           @$AR3, $AC0.M
IRAM:0348 ; ac0.m = (*buffer_e04++) - 1;
IRAM:0348 ; ar1 = *buffer_e04++;
IRAM:0348 ; ar0 = *buffer_e04++;
IRAM:0348                 LRI            $AR3, cmd3_loop_counter
IRAM:034A                 CLR            $ACC0
IRAM:034B                 CLR'L          $ACC1 : $AC0.M, @$AR3
IRAM:034C                 LRRI           $AR1, @$AR3 ; data_E05
IRAM:034D                 LRRI           $AR0, @$AR3 ; cmd3_temp_AR0
IRAM:034E                 DECM           $AC0.M
IRAM:034F                 SR             cmd3_loop_counter, $AC0.M
IRAM:0351 ; while (loop_counter)
IRAM:0351                 JNZ            cmd3_loop_5_start
IRAM:0353                 SET16
IRAM:0354                 CLR            $ACC0
IRAM:0355                 LR             $AC0.M, DMEM_B9B
IRAM:0357                 TST            $ACC0
IRAM:0358 ; if ([b9b] == 0)
IRAM:0358                 JZ             cmd3_b9b_zero
IRAM:035A ; DMA to MMEM from address stored in [e1c]
IRAM:035A                 LR             $AC0.M, DMEM_B9C
IRAM:035C                 LR             $AC0.L, DMEM_B9D
IRAM:035E                 SRS            DMAMMADDRH, $AC0.M
IRAM:035F                 SRS            DMAMMADDRL, $AC0.L
IRAM:0360                 CLR            $ACC0
IRAM:0361                 LR             $AC0.M, byte_E1C
IRAM:0363                 SRS            DMADSPADDR, $AC0.M
IRAM:0364                 SI             DMAControl, 1
IRAM:0366                 SI             DMALength, 0x40
IRAM:0368                 CALL           wait_for_dma_finish_0
IRAM:036A ; same sort of setup as in command 2
IRAM:036A
IRAM:036A cmd3_b9b_zero:                          ; CODE XREF: command_3+110↑j
IRAM:036A                 CLR            $ACC0
IRAM:036B                 CLR            $ACC1
IRAM:036C                 LR             $AC0.M, loc_B82
IRAM:036E                 LR             $AC1.M, loc_B83
IRAM:0370                 SRS            DMAMMADDRH, $AC0.M
IRAM:0371                 SRS            DMAMMADDRL, $AC1.M
IRAM:0372                 SI             DMADSPADDR, 0xB80
IRAM:0374                 SI             DMAControl, 1
IRAM:0376                 SI             DMALength, 0xC0
IRAM:0378                 CALL           wait_for_dma_finish_0
IRAM:037A                 CLR            $ACC0
IRAM:037B                 LR             $AC0.M, loc_B80
IRAM:037D                 LR             $AC0.L, loc_B81
IRAM:037F                 TST            $ACC0
IRAM:0380                 JNZ            loc_386
IRAM:0382 ; restore command_stream pointer
IRAM:0382                 LR             $AR0, cmd3_temp_command_stream
IRAM:0384                 JMP            receive_command
IRAM:0386 ; ---------------------------------------------------------------------------
IRAM:0386
IRAM:0386 loc_386:                                ; CODE XREF: command_3+138↑j
IRAM:0386                 SRS            DMAMMADDRH, $AC0.M
IRAM:0387                 SRS            DMAMMADDRL, $AC0.L
IRAM:0388                 SI             DMADSPADDR, 0xB80
IRAM:038A                 SI             DMAControl, 0
IRAM:038C                 SI             DMALength, 0xC0
IRAM:038E                 LRI            $AR2, buffer_sections_E08
IRAM:0390                 LRI            $AC1.M, 0
IRAM:0392                 SRRI           @$AR2, $AC1.M
IRAM:0393                 LRI            $AC1.M, 0x140
IRAM:0395                 SRRI           @$AR2, $AC1.M
IRAM:0396                 LRI            $AC1.M, 0x280
IRAM:0398                 SRRI           @$AR2, $AC1.M
IRAM:0399                 LRI            $AC1.M, 0x400
IRAM:039B                 SRRI           @$AR2, $AC1.M
IRAM:039C                 LRI            $AC1.M, 0x540
IRAM:039E                 SRRI           @$AR2, $AC1.M
IRAM:039F                 LRI            $AC1.M, 0x680
IRAM:03A1                 SRRI           @$AR2, $AC1.M
IRAM:03A2                 LRI            $AC1.M, 0x7C0
IRAM:03A4                 SRRI           @$AR2, $AC1.M
IRAM:03A5                 LRI            $AC1.M, 0x900
IRAM:03A7                 SRRI           @$AR2, $AC1.M
IRAM:03A8                 LRI            $AC1.M, 0xA40
IRAM:03AA                 SRRI           @$AR2, $AC1.M
IRAM:03AB                 CALL           wait_for_dma_finish_0
IRAM:03AD                 LR             $AC0.M, loc_BA6+1
IRAM:03AF                 LR             $AC1.M, DMEM_BA8
IRAM:03B1                 SRS            DMAMMADDRH, $AC0.M
IRAM:03B2                 SRS            DMAMMADDRL, $AC1.M
IRAM:03B3                 SI             DMADSPADDR, 0x3C0
IRAM:03B5                 SI             DMAControl, 0
IRAM:03B7                 SI             DMALength, 0x80
IRAM:03B9                 CLR            $ACC0
IRAM:03BA                 CLR            $ACC1
IRAM:03BB                 LR             $AC0.M, DMEM_B84
IRAM:03BD                 LRI            $AC1.M, 0xB31
IRAM:03BF                 ADD            $ACC0, $ACC1
IRAM:03C0                 MRR            $AR3, $AC0.M
IRAM:03C1                 ILRR           $AC0.M, @$AR3
IRAM:03C2                 SR             DMEM_E15, $AC0.M
IRAM:03C4                 LR             $AC0.M, DMEM_B85
IRAM:03C6                 LRI            $AC1.M, 0xB34
IRAM:03C8                 ADD            $ACC0, $ACC1
IRAM:03C9                 MRR            $AR3, $AC0.M
IRAM:03CA                 ILRR           $AC0.M, @$AR3
IRAM:03CB                 SR             DMEM_E16, $AC0.M
IRAM:03CD                 LR             $AC0.M, DMEM_B86
IRAM:03CF                 LRI            $AC1.M, 0xB11
IRAM:03D1                 ADD            $ACC0, $ACC1
IRAM:03D2                 MRR            $AR3, $AC0.M
IRAM:03D3                 ILRR           $AC0.M, @$AR3
IRAM:03D4                 SR             DMEM_E14, $AC0.M
IRAM:03D6                 CLR            $ACC0
IRAM:03D7                 LR             $AC0.M, DMEM_B9B
IRAM:03D9                 TST            $ACC0
IRAM:03DA                 JZ             loc_403
IRAM:03DC                 CLR            $ACC1
IRAM:03DD                 LR             $AC1.M, loc_B9E
IRAM:03DF                 ADDI           $AC1.M, 0xCC0
IRAM:03E1                 SR             cmd2_DMEM_E40_start, $AC1.M
IRAM:03E3                 LR             $AC1.M, loc_B9F
IRAM:03E5                 ADDI           $AC1.M, 0xCC0
IRAM:03E7                 SR             cmd2_DMEM_E41_end, $AC1.M
IRAM:03E9                 LRI            $AC1.M, 0xCE0
IRAM:03EB                 SR             cmd2_DMEM_E42, $AC1.M
IRAM:03ED                 SR             cmd2_DMEM_E43, $AC1.M
IRAM:03EF                 CALL           wait_for_dma_finish_0
IRAM:03F1                 LR             $AC0.M, DMEM_B9C
IRAM:03F3                 SRS            DMAMMADDRH, $AC0.M
IRAM:03F4                 LR             $AC0.M, DMEM_B9D
IRAM:03F6                 SRS            DMAMMADDRL, $AC0.M
IRAM:03F7                 SI             DMADSPADDR, 0xCC0
IRAM:03F9                 SI             DMAControl, 0
IRAM:03FB                 SI             DMALength, 0x40
IRAM:03FD                 CALL           wait_for_dma_finish_0
IRAM:03FF ; restore command_stream pointer
IRAM:03FF                 LR             $AR0, cmd3_temp_command_stream
IRAM:0401                 JMP            command_3
IRAM:0403 ; ---------------------------------------------------------------------------
IRAM:0403
IRAM:0403 loc_403:                                ; CODE XREF: command_3+192↑j
IRAM:0403                 LRI            $AC1.M, 0xCE0
IRAM:0405                 SR             cmd2_DMEM_E42, $AC1.M
IRAM:0407                 SR             cmd2_DMEM_E40_start, $AC1.M
IRAM:0409                 SR             cmd2_DMEM_E41_end, $AC1.M
IRAM:040B                 SR             cmd2_DMEM_E43, $AC1.M
IRAM:040D                 CALL           wait_for_dma_finish_0
IRAM:040F                 LR             $AR0, cmd3_temp_command_stream
IRAM:0411                 JMP            command_3