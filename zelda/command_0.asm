RAM:0049 command_0_impl:
RAM:0049                 LRI            $AC0.M, 0x8000
RAM:004B                 LR             $AC0.L, callback
RAM:004D ; send_cpu_mail(0x8000, callback)
RAM:004D                 CALL           send_cpu_mail_ac0
RAM:004F                 JMP            receive_command

...

RAM:005A send_cpu_mail_ac0:                      ; CODE XREF: command_0_impl+4↑p
RAM:005A                                         ; command_2_impl+6↓p ...
RAM:005A                 SRS            ToCPUMailHi, $AC0.M
RAM:005B                 SRS            ToCPUMailLo, $AC0.L
RAM:005C
RAM:005C wait_for_mail_sent:                     ; CODE XREF: send_cpu_mail_ac0+5↓j
RAM:005C                 LRS            $AC0.M, ToCPUMailHi
RAM:005D                 ANDF           $AC0.M, 0x8000
RAM:005F                 JLNZ           wait_for_mail_sent
RAM:0061                 RET