void command_e(u16* &command_stream) {
    u32 mmaddr = ((*command_stream++) << 16) | *command_stream++;
    
    dma_dmem_to_mmem(mmaddr, 0x280, 0x280);
    wait_for_dma_finish();

    mmaddr = ((*command_stream++) << 16) | *command_stream++;

    u16* buffer_400 = 0x400;
    u16* buffer_0 = 0x0;
    u16* buffer_140 = 0x140;

    for (int i = 0; i < 5; i++) {
        u16* buffer_400_loop_start = buffer_400;
        for (int j = 0; j < 0x20; j++) {
            u32 data_140 = ((*buffer_140++) << 16) | *buffer_140++;
            u32 data_0 = ((*buffer_0++) << 16) | *buffer_0++;
            *buffer_400++ = (u16)data_140;  // only bottom bits
            *buffer_400++ = (u16)data_0;  // only bottom bits
        }
        dma_dmem_to_mmem(mmaddr, buffer_400_loop_start, 0x80);
        mmaddr += 0x80;
    }
    wait_for_dma_finish();
}