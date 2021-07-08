RAM:0010 main_entry:
RAM:0010                 SBSET          2 : ,
RAM:0011                 SBSET          3
RAM:0012                 SBCLR          4
RAM:0013                 SBSET          5
RAM:0014                 SBSET          6
RAM:0015                 SET16
RAM:0016                 CLR15
RAM:0017                 M0
RAM:0018                 LRI            $AC0.M, 0xFFFF
RAM:001A                 MRR            $WR0, $AC0.M
RAM:001B                 MRR            $WR1, $AC0.M
RAM:001C                 MRR            $WR2, $AC0.M
RAM:001D                 MRR            $WR3, $AC0.M
RAM:001E                 LRI            $CR, 0xFF
RAM:0020 ; clear DMEM
RAM:0020                 CLR            $ACC0
RAM:0021                 LRI            $AC1.M, 0x1000
RAM:0023                 LRI            $AR0, 0
RAM:0025                 LOOP           $AC1.M
RAM:0026                 SRRI           @$AR0, $AC0.M
RAM:0027 ; read mail from cpu (why?)
RAM:0027                 LRS            $AC0.M, ToDSPMailLo
RAM:0028 ; send CPU mail 0x88881111
RAM:0028                 SI             ToCPUMailHi, 0x8888
RAM:002A                 SI             ToCPUMailLo, 0x1111
RAM:002C
RAM:002C wait_for_mail_sent:
RAM:002C                 LRS            $AC0.M : ToCPUMailHi,
RAM:002D                 ANDF           $AC0.M, 0x8000
RAM:002F                 JLNZ           wait_for_mail_sent
RAM:0031 receive_command:
RAM:0031 ; receive mail from CPU
RAM:0031                 CLR            $ACC0 : ,
RAM:0032                 CLR            $ACC1
RAM:0033                 LRS            $AC0.M, ToDSPMailHi
RAM:0034                 ANDCF          $AC0.M, 0x8000
RAM:0036                 JLNZ           receive_command
RAM:0038                 LRS            $AC1.M, ToDSPMailLo
RAM:0039                 SR             cmd_info_lo, $AC1.M ; cmd_info_lo = mail.lo
RAM:003B                 MRR            $AC1.M, $AC0.M
RAM:003C                 ANDI           $AC1.M, 0xFF
RAM:003E                 SR             cmd_info_hi, $AC1.M ; cmd_info_hi = mail.hi & 0xff
RAM:0040 ; callback = ((mail.hi >> 8) & 0x7e) + 0x62
RAM:0040                 LSR            $ACC0, 0x39 ; -EXTS6(0x39) = 7
RAM:0041                 ANDI           $AC0.M, 0x7E
RAM:0043                 ADDI           $AC0.M, 0x62
RAM:0045                 SR             callback, $AC0.M
RAM:0047                 MRR            $AR0, $AC0.M
RAM:0048                 JMPR           $AR0