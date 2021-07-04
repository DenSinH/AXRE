extern u16* buffer_sections[9];  // DMEM E08

extern u16 data_e14, data_e15, data_e16;
extern u16* data_e40, data_e41, data_e42, data_e43;
extern struct* structb80;
extern struct* struct3c0;


void command_3(u16* &command_stream) {
    while (true) {
        u16* buffer_ar0 = &structb80[0x22];
        u16* buffer_ar1 = struct3c0;
        u16* ptr_e1c;

        // loop counter stored at 0E04
        for (int i = 0; i < 5; i++) {
            
            const u16 times = *buffer_ar0++;
            for (int j = 0; j < times; j++) {
                structb80[*buffer_ar1++] = *buffer_ar1++;
            }

            u16* dest_buffer;
            if (structb80[0x7] == 1) {
                byte_e1c = data_e42;
                ((void (*)())data_e15)();

                dest_buffer = 0xe44;
                i32 step = i16(structb80[0x32]) * i16(structb80[0x33] << 1);
                u32 value0 = structb80[0x32] << 16;
                u32 value1 = value0 + (structb80[0x33] << 16);

                for (int j = 0; j < 16; j++) {
                    *dest_buffer++ = value0 >> 16;
                    value0 += step;
                    *dest_buffer++ = value1 >> 16;
                    value1 += step;
                }

                structb80[0x32] = value0;
                u16* src_buffer = 0xe44;  // AR0
                dest_buffer = data_e43;   // AR3

                for (int j = 0; j < 32; j++) {
                    *dest_buffer = (*src_buffer * *dest_buffer) >> 16;
                    dest_buffer++;
                    src_buffer++;
                }

                ((void (*)())data_e14)();

                if (structb80[0x1b]) {
                    data_e43 = data_e42;
                    if (structb80[0x1e] <= structb80[0x20]) {
                        structb80[0x1e]++
                    }
                    else {
                        structb80[0x1e]--;
                    }
                    data_e40 = data_e43 - 0x20 + structb80[0x1e];

                    if (structb80[0x1f] <= structb80[0x21]) {
                        structb80[0x1f]++
                    }
                    else {
                        structb80[0x1f]--;
                    }
                    data_e41 = data_e43 - 0x20 + structb80[0x1f];
                }
                else {
                    data_e40 = data_e41 = data_e43 = data_e42;
                }
            }

            for (int j = 0; j < 9; j++) {
                buffer_sections[j] += 0x40;
            }
        }

        u32 mmaddr;
        if (structb80[0x1b]) {
            mmaddr = (structb80[0x1c] << 16) | structb80[0x1d];
            dma_dmem_to_mmem(mmaddr, ptr_e1c, 0x40);
            wait_for_dma_finish();
        }

        // DMA struct back to main memory
        mmaddr = (structb80[0x2] << 16) | structb80[0x3];
        dma_dmem_to_mmem(mmaddr, 0xb80, 0xc0);
        wait_for_dma_finish();

        mmaddr = (structb80[0x0] << 16) | structb80[0x1];
        if (!mmaddr) {
            return;
        }

        if (mmaddr) {
            // same setup as command 2
            dma_to_dmem(structb80, mmaddr, 0xc0);

            buffer_sections = {
                0x0, 0x140, 0x280, 0x400, 0x540, 0x680, 0x7c0, 0x900, 0xa40
            };
            wait_for_dma_finish();

            mmaddr = (structb80[0x27] << 16) | structb80[0x28];
            dma_to_dmem(0x3c0, mmaddr, 0x80);

            data_e15 = (structb80[0x4]) + 0xb31;
            data_e16 = (structb80[0x5]) + 0xb34;
            data_e14 = (structb80[0x6]) + 0xb11;

            if (structb80[0x1b)] {
                data_e40 = 0xcc0 + (structb80[0x1e)];
                data_e41 = 0xcc0 + (structb80[0x1f)];
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
    }
}