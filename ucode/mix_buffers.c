void mix_buffers(u16* &command_stream, u16* const buffer) {
    // buffer in IX2
    u32 mmaddr = ((*command_stream++) << 16) | *command_stream++;
    u16* dspaddr = buffer;
    dma_to_dmem(dspaddr, mmaddr, 0xc0);
    wait_for_dma_finish();

    u16* buffer_0_3, buffer_0_2 = 0;  // AR3/AR2
    u16* _buffer; // AR0

    for (int i = 0; i < 9; i++) {
        _buffer = dspaddr;

        // start DMA for next section
        mmaddr  += 0xc0;
        dspaddr += 0x60;
        dma_to_dmem(dspaddr, mmaddr, 0xc0);

        // process current section
        for (int j = 0; j < 0x30; j++) {
            *(u32*)buffer_0 += *(u32*)_buffer;
            _buffer += 2;
            buffer_0 += 2;
        }
    }
    // process last section
    for (int j = 0; j < 0x30; j++) {
        *(u32*)buffer_0 += *(u32*)_buffer;
        _buffer += 2;
        buffer_0 += 2;
    }
}