extern u16* data_E1B;


void command_8(u16* &command_stream) {
    u32 mmaddr = ((*command_stream++) << 16) | *command_stream++;
    dma_to_dmem(0xe80, mmaddr, 0x100);
    wait_for_dma_finish();

    mmaddr = ((*command_stream++) << 16) | *command_stream++;
    dma_to_dmem(0x280, mmaddr, 0x280);
    wait_for_dma_finish();
    
    u16* buffer_280 = 0x280;
    u16* const ptr_E1B = data_E1B;  // set by main_entry to 0xe80
    u16* buffer_f00 = 0xf00;

    buffer_280++;
    *ptr_E1B = *buffer_280;

    // first and last iterations are unrolled in assembly
    for (int i = 0; i < 0xa0; i++) {
        u16* coef = 0x16b4;  // in DSP_COEF memory region

        i16 current_coef = *coef++;
        i64 prod = 0;
        for (int j = 0; j < 0x7f; j++) {
            prod += current_coef * current_coef;
            current_coef = *coef++;
        }
        
        *buffer_f00++ = prod >> 16;
        buffer_280++;
        *ptr_E1B = *data_ptr++;
    }

    *ptr_E1B = buffer_f00;

    buffer_280 = 0x280;
    buffer_f00 = 0xf00;
    u16* buffer_140 = 0x140;
    u16* buffer_000 = 0x000;

    i32 value;
    for (int i = 0; i < 0xa0; i++) {
        value = EXTS16(*buffer_f00++);
        *(u32*)buffer_280++ = 0;      // increment by 2 as well
        *(u32*)buffer_000++ = value;  // increment by 2 as well
        *(u32*)buffer_140++ = -value; // increment by 2 as well
    }

    dma_dmem_to_mmem(mmadr, 0xe80, 0x100);
    wait_for_dma_finish();
}