RAM:031D command_1_impl:
RAM:031D                 LRI            $AR0, 0x380
RAM:031F ; receive 4 dwords of mail, store to 0x380
RAM:031F                 CALL           wait_for_mail_recv_to_ar0
RAM:0321                 CALL           wait_for_mail_recv_to_ar0
RAM:0323                 CALL           wait_for_mail_recv_to_ar0
RAM:0325                 CALL           wait_for_mail_recv_to_ar0
RAM:0327 ; pointer to mmaddr
RAM:0327                 LRI            $AR1, 0x382
RAM:0329                 LRI            $AC1.M, 0 ; dspaddr
RAM:032B                 LRI            $AR0, 0x200 ; length 0x200 << 1
RAM:032D                 CALL           dma_from_@ar1
RAM:032F ; pointer to mmaddr
RAM:032F                 LRI            $AR1, 0x384
RAM:0331                 LRI            $AC1.M, 0x300
RAM:0333                 LRI            $AR0, 0x20
RAM:0335                 CALL           dma_from_@ar1
RAM:0337                 CALL           memcpy_8_dwords_300_to_ffa0_set_ac1m_e
RAM:0339                 LR             $AC0.M, cmd_info_lo
RAM:033B                 SR             cmd_info_lo_copy_cmd1, $AC0.M
RAM:033D                 CALL           set_some_values_3f0
RAM:033F                 JMP            command_0_impl

...

RAM:0051 wait_for_mail_recv_to_ar0:
RAM:0051                 LRS            $AC0.M, ToDSPMailHi
RAM:0052 ; *ar0++ = mail.hi
RAM:0052 ; *ar0++ = mail.lo
RAM:0052                 ANDCF          $AC0.M, 0x8000
RAM:0054                 JLNZ           wait_for_mail_recv_to_ar0
RAM:0056                 LRS            $AC0.L, ToDSPMailLo
RAM:0057                 SRRI           @$AR0, $AC0.M
RAM:0058                 SRRI           @$AR0, $AC0.L
RAM:0059                 RET

...

RAM:03A0 memcpy_8_dwords_300_to_ffa0_set_ac1m_e:
RAM:03A0                 LRI            $AR3 : unk_FFA0, , ,
RAM:03A2
RAM:03A2 memcpy_8_dwords_300_to_ar3_set_ac1m_e:
RAM:03A2                                       
RAM:03A2                 LRI            $AR0, 0x300
RAM:03A4                 LRI            $AC1.M, 0xE
RAM:03A6 ; REPEAT 8 TIMES
RAM:03A6                 BLOOPI         8, loc_3AB
RAM:03A8 ; copy a dword from AR0 to AR3
RAM:03A8                 LRRI           $AC0.M, @$AR0
RAM:03A9                 SRRI           @$AR3, $AC0.M
RAM:03AA                 LRRI           $AC0.M, @$AR0
RAM:03AB
RAM:03AB loc_3AB:                                ; CODE XREF: memcpy_8_dwords_300_to_ffa0_set_ac1m_e+6↑j
RAM:03AB                 SRRI           @$AR3, $AC0.M
RAM:03AC ; BLOOPI END
RAM:03AC                 RET

... 

RAM:0AB1 set_some_values_3f0:
RAM:0AB1                 LRI            $AC0.M, 0xFFFF
RAM:0AB3                 SR             byte_3F2, $AC0.M
RAM:0AB5                 CLR            $ACC0
RAM:0AB6                 SR             byte_3F0, $AC0.M
RAM:0AB8                 SR             byte_3F6, $AC0.M
RAM:0ABA                 LRI            $AC0.M, 0x100
RAM:0ABC                 SR             byte_3F7, $AC0.M
RAM:0ABE                 LR             $AX0.H, byte_3F7
RAM:0AC0                 LRI            $AC0.M, 0x8000
RAM:0AC2                 SUBR           $ACC0, $AX0.H
RAM:0AC3                 SR             byte_3F5, $AC0.M
RAM:0AC5                 LRI            $AC0.M, 0x30
RAM:0AC7                 SR             byte_3F3, $AC0.M
RAM:0AC9                 LRI            $AC0.M, 0x10
RAM:0ACB                 SR             byte_3F4, $AC0.M
RAM:0ACD                 LRI            $AC0.M, 0x96
RAM:0ACF                 SR             byte_3F1, $AC0.M
RAM:0AD1                 RET