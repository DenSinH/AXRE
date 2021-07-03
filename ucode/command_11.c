void command_11(u16* &command_stream) {
    u32 mmaddr = ((*command_stream++) << 16) | *command_stream++;
    
    dma_to_dmem(0xe44, mmaddr, 0x20);
    mmaddr += 0x20;
    wait_for_dma_finish();

    u16* buffer_e44 = 0xe44;
    u16* buffer_280 = 0x280;
    u16* buffer_0   = 0x0;
    u16* buffer_140 = 0x140;

    // DMA rest of the data to process in parallel
    dma_to_dmem(0xe54, mmaddr, 0x60);

    for (int i = 0; i < 0xa0; i++) {
        u32 data_e44 = *(u32*)buffer_e44;
        buffer_e44 += 2;
        *(u32*)buffer_140 = data_e44;
        buffer_140 += 2;
        *(u32*)buffer_0 = -data_e44;
        buffer_0 += 2;
    }
    // does not wait for DMA to finish (seems like a bad idea)
}