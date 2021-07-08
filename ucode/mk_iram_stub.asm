RAM:0010 loc_10:
RAM:0010                 SBCLR          6
RAM:0011                 SBCLR          3
RAM:0012                 SBCLR          4
RAM:0013                 SBCLR          5
RAM:0014                 LRI            $AR0, 0x8000
RAM:0016                 LRI            $WR0, 0xFFFF
RAM:0018                 LRI            $IX0, 0x1000
RAM:001A ; REPEAT 0x1000 TIMES
RAM:001A ; this reads the first 0x1000 words of the ROM
RAM:001A ; does this enable the ROM addressing space?
RAM:001A                 BLOOP          $IX0, loc_1D
RAM:001C                 ILRRI          $AC0.M, @$AR0
RAM:001D
RAM:001D loc_1D:                                 ; CODE XREF: RAM:001A↑j
RAM:001D                 NOP
RAM:001E ; BLOOP END
RAM:001E                 CLR            $ACC0
RAM:001F                 MRR            $AR0, $AC0.M
RAM:0020 ; REPEAT SRRI @$AR0, $AC0.M 0x1000 TIMES
RAM:0020 ; clears out DMEM
RAM:0020                 LOOP           $IX0
RAM:0021                 SRRI           @$AR0, $AC0.M
RAM:0022                 LRI            $IX0, 0x800
RAM:0024 ; REPEAT 0x800 TIMES
RAM:0024 ; read from uncleared DMEM and do nothing
RAM:0024                 BLOOP          $IX0, loc_27
RAM:0026                 LRRI           $AC0.M, @$AR0
RAM:0027
RAM:0027 loc_27:                                 ; CODE XREF: RAM:0024↑j
RAM:0027                 NOP
RAM:0028 ; BLOOPI END
RAM:0028
RAM:0028 ; WAIT FOR MAIL SENT
RAM:0028
RAM:0028 loc_28:                                 ; CODE XREF: RAM:002C↓j
RAM:0028                 LR             $AC0.M, 0xFFFC
RAM:002A                 ANDF           $AC0.M, 0x8000
RAM:002C                 JLNZ           loc_28
RAM:002E ; send CPU 0xc3480054
RAM:002E                 SI             0xFFFC, 0x54
RAM:0030                 SI             0xFFFD, 0x4348
RAM:0032                 HALT