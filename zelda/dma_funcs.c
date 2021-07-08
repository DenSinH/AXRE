void dma_from_at_ar1(u32* mmaddrptr, u16 dspaddr, u16 len) {
    // mmaddrptr: ar1
    // dspaddr: ac1.m
    // len: ar0
    u32 mmaddr = *mmaddrptr;
    dma_from_in_ac0(mmaddr, dspaddr, len)
}

void dma_from_in_ac0(u32 mmaddr, u16 dspaddr, u16 len) {
    // mmaddr: ac0
    // dspaddr: ac1.m
    // len: ar0
    *DMADSPAddr = dspaddr;
    continuous_dma(mmaddr, 0, len);
}

void continuous_dma(u32 mmaddr, u16 dma_control, u16 len) {
    // mmaddr: ac0
    // len: ar0
    *DMAControl = dma_control;
    *DMAMMAddrHi = mmaddr >> 16;
    *DMAMMaddrLo = (u16)mmaddr;
    *DMALength = len << 1;
    wait_for_dma_finish();
}