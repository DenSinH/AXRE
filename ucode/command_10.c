void command_10(u16* &command_stream) {
    u32 mmaddr = ((*command_stream++) << 16) | *command_stream++;
    
    dma_dmem_to_mmem(mmaddr, 0x7c0, 0x500);
    wait_for_dma_finish();
    
    mmaddr = ((*command_stream++) << 16) | *command_stream++;
    // DMA first part of buffer
    dma_to_dmem(0x7c0, mmaddr, 0x20);
    mmaddr += 0x20;
    wait_for_dma_finish();

    u16* buffer_7c0 = 0x7c0;  // AR0
    u16* buffer_0 = 0;  // AR2/AR3
    
    // DMA the rest while processing
    dma_to_dmem(0x7d0, mmaddr, 0x4e0);

    // in assembly: 0x4f iterations, 2 dword loads/stores per iteration
    // last iteration special case
    for (int i = 0; i < 0xa0; i++) {
        u32 data_7c0 = *(u32*)buffer_7c0;
        buffer_7c0 += 2;
        *(u32*)buffer_0 += data_7c0;
        buffer_0 += 2;
    }

    // in assembly: 0x4f iterations, 2 dword loads/stores per iteration
    // last iteration special case
    for (int i = 0; i < 0xa0; i++) {
        u32 data_7c0 = *(u32*)buffer_7c0;
        buffer_7c0 += 2;
        *(u32*)buffer_0 = -(*(u32*)buffer_0) + data_7c0;
        buffer_0 += 2;
    }
    // we have now processed 2 * 0xa0 dwords = 0x280 words of data (entire buffer)
}