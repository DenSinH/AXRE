RAM:007E dma_from_@ar1:
RAM:007E                                         ; command_1_impl+10↓p ...
RAM:007E                 LRRI           $AC0.M, @$AR1
RAM:007F ; do command_f with input from ar1
RAM:007F                 LRRI           $AC0.L, @$AR1
RAM:0080
RAM:0080 dma_from_in_ac0:
RAM:0080                                         ; command_7_impl+E↓p ...
RAM:0080                 SRS            DMADSPAddr, $AC1.M
RAM:0081                 LRIS           $AC1.M, 0
RAM:0082
RAM:0082 dma_from_in_ac0_to_continuous:
RAM:0082                 SRS            DMAControl, $AC1.M
RAM:0083                 SRS            DMAMMAddrHi, $AC0.M
RAM:0084                 SRS            DMAMMAddrLo, $AC0.L
RAM:0085                 MRR            $AC1.M, $AR0
RAM:0086                 LSL            $ACC1, 1
RAM:0087                 SRS            DMALength, $AC1.M
RAM:0088                 CALL           wait_for_dma_finish
RAM:008A                 RET