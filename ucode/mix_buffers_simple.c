
void sub_484(u16* &command_stream, u16* const buffer) {
    // buffer in IX2

    u32 mmaddr = ((*command_stream++) << 16) | *command_stream++;
    dma_to_dmem(buffer, mmaddr, 0xc0);
    wait_for_dma_finish();

    u16* buffer_e44 = 0xe44;
    mmaddr += 0xc0;

    // push addresses
    *buffer_e44++ = mmaddr >> 16;
    *buffer_e44++ = u16(mmaddr);
    *buffer_e44++ = buffer + 0x60;

    buffer_e44 = 0xe44;  // AR1

    u16* buffer_0_3, buffer_0_2 = 0;  // AR3/AR2
    u16* _buffer = buffer; // AR0

    u16 dspaddr;
    for (int i = 0; i < 9; i++) {
        // pop addresses
        mmaddr = ((*buffer_e44++) << 16) | *buffer_e44++;
        dspaddr = *buffer_e44++;

        dma_to_dmem(dspaddr, mmaddr, 0xc0);
        buffer_e44 = 0xe44;

        // push addresses
        *buffer_e44++ = (mmaddr + 0xc0) >> 16;
        *buffer_e44++ = u16(mmaddr + 0xc0);
        *buffer_e44++ = dspaddr + 0x60;
        buffer_e44 = 0xe44;

        // first and last iteration unrolled in assembly
        // in assembly: a of 0x17 iterations + 1 last iteration case
        // in the loop: 2 32 bit values transferred every iteration
        // this results in 0x18 * 2 * 2 = 0x60 words transferred
        for (int j = 0; j < 0x30; j++) {
            u32 word_buffer = ((*_buffer++) << 16) | *_buffer++;
            u32 word_0 = ((*buffer_0_3++) << 16) | *buffer_0_3++;
            u32 sum = word_buffer + word_0;
            *buffer_0_2++ = sum >> 16;
            *buffer_0_2++ = u16(sum);
        }
    }

    // do the same thing for the last transferred block of 0x60 words
    for (int j = 0; j < 0x30; j++) {
        u32 word_buffer = ((*_buffer++) << 16) | *_buffer++;
        u32 word_0 = ((*buffer_0_3++) << 16) | *buffer_0_3++;
        u32 sum = word_buffer + word_0;
        *buffer_0_2++ = sum >> 16;
        *buffer_0_2++ = u16(sum);
    }
}
