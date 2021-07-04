extern u16* buffer_sections[9];  // DMEM E08

extern u16 data_e14, data_e15, data_e16;
extern u16* data_e40, data_e41, data_e42, data_e43;
extern struct* structb80;

void (*extra_function_table[32])() = {

}

void (*pre_function_table[3])() = {

}

u16 setting_data[3] = {
    0x1000, 0x1200, 0x1400
}

void command_2(u16* &command_stream) {
    u32 mmaddr = ((*command_stream++) << 16) | (*command_stream++);

    // the DMAd data is not a simple array, but a struct
    dma_to_dmem(structb80, mmaddr, 0xc0);

    buffer_sections = {
        0x0, 0x140, 0x280, 0x400, 0x540, 0x680, 0x7c0, 0x900, 0xa40
    };
    wait_for_dma_finish();

    mmaddr = (structb80[0x27] << 16) | structb80[0x28];
    dma_to_dmem(0x3c0, mmaddr, 0x80);

    data_e15 = pre_function_table[structb80[0x4]];
    data_e16 = setting_data[structb80[0x5]];
    data_e14 = post_function_table[structb80[0x6]];

    if (structb80[0x1b]) {
        data_e40 = 0xcc0 + structb80[0x1e];
        data_e41 = 0xcc0 + structb80[0x1f];
        data_e42 = 0xce0;
        data_e43 = 0xce0;

        wait_for_dma_finish();

        mmaddr = (structb80[0x1c] << 16) | structb80[0x1d];
        dma_to_dmem(0xcc0, mmaddr, 0x40);
    }
    else {
        data_e40 = 0xce0;  // address
        data_e41 = 0xce0;  // address
        data_e42 = 0xce0;  // address
        data_e43 = 0xce0;  // address
        wait_for_dma_finish();
    }
}