extern u16* buffer_sections[9]; // DMEM E08
extern u16* data_e40, data_e41, data_e42, data_e43;
extern struct* structb80;


// return in AX0.L and AX1.H
(u16, u16) sub_80e7(u16* cc0_buffer_current_e40, u16* structb80_9, u16* buffer_section, u16* cc0_buffer_current_e41, u16 buffer_section_1) {
    // cc0_buffer_current_e40: ar0
    // structb80_9: ar1
    // buffer_sections: ar2, ar3
    // cc0_buffer_current_e41: IX0
    // buffer_section_1: IX1
    u16 ret_e40 = sub_81f9(cc0_buffer_current_e40, structb80_9, buffer_section);
    structb80_9++;  // should point to structb80[0xb] now, incremented in sub_81f9
    u16 ret_e41 = sub_81f9(cc0_buffer_current_e41, structb80_9, buffer_section_1);
    return (ret_e40, ret_e41);  // (AX0.L, AX1.H)
}

u16 sub_81f9(u16* cc0_buffer_current, u16* &structb80_9, u16* buffer_section) {
    // cc0_buffer_current: ar0
    // structb80_9: ar1
    // buffer_section: ar2, ar3
    i16 constant_factor = *structb80_9++;
    i64 buffer_data;
    for (int i = 0; i < 0x20; i++) {
        buffer_data = EXTS40((*(u32*)buffer_section) << 16);
        i16 stream_factor = *cc0_buffer_current++;
        buffer_data += constant_factor * stream_factor;
        buffer_data >>= 16;
        *(u32*)buffer_section = buffer_data >> 16;  // mh part
        buffer_section += 2;
    }
    return buffer_data >> 16;  // mid part
}

// @768
void pre_0() {
    u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    structb80[0x29] = left;
    structb80[0x2c] = right;
}

// @77a
void pre_1() {
    u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    structb80[0x29] = left;
    structb80[0x2c] = right;
    
    left, right = sub_80e7(*data_e40, &structb80[0xd], buffer_sections[3], *data_e41, buffer_sections[4]);
    structb80[0x2a] = left;
    structb80[0x2d] = right;
}

// @79d
void pre_2() {
    u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    structb80[0x29] = left;
    structb80[0x2c] = right;
    
    left, right = sub_80e7(*data_e40, &structb80[0x11], buffer_sections[6], *data_e41, buffer_sections[7]);
    structb80[0x2b] = left;
    structb80[0x2e] = right;
}

// @7c0
void pre_3() {
    u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    structb80[0x29] = left;
    structb80[0x2c] = right;
    
    left, right = sub_80e7(*data_e40, &structb80[0xd], buffer_sections[3], *data_e41, buffer_sections[4]);
    structb80[0x2a] = left;
    structb80[0x2d] = right;

    left, right = sub_80e7(*data_e40, &structb80[0x11], buffer_sections[6], *data_e41, buffer_sections[7]);
    structb80[0x2b] = left;
    structb80[0x2e] = right;
}

// @7f4
void pre_4() {
    u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    structb80[0x29] = left;
    structb80[0x2c] = right;
    
    // not all arguments loaded
    left, right = sub_80e7(*data_e43, &structb80[0x17], buffer_sections[2], *data_e41, buffer_sections[1]);
    structb80[0x2f] = left;
}

// @811
void pre_5() {
    u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    structb80[0x29] = left;
    structb80[0x2c] = right;
    
    left, right = sub_80e7(*data_e40, &structb80[0xd], buffer_sections[3], *data_e41, buffer_sections[4]);
    structb80[0x2a] = left;
    structb80[0x2d] = right;

    left, right = sub_80e7(*data_e43, &structb80[0x17], buffer_sections[2], *data_e43, buffer_sections[5]);
    structb80[0x2f] = left;
    structb80[0x30] = right;
}

// @844
void pre_6() {
    u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    structb80[0x29] = left;
    structb80[0x2c] = right;
    
    left, right = sub_80e7(*data_e40, &structb80[0x11], buffer_sections[6], *data_e41, buffer_sections[7]);
    structb80[0x2b] = left;
    structb80[0x2e] = right;

    left, right = sub_80e7(*data_e43, &structb80[0x15], buffer_sections[8], *data_e43, buffer_sections[2]);
    structb80[0x2f] = left;
    structb80[0x31] = right;
}

// @877
void pre_7() {
    u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    structb80[0x29] = left;
    structb80[0x2c] = right;

    left, right = sub_80e7(*data_e40, &structb80[0xd], buffer_sections[3], *data_e41, buffer_sections[4]);
    structb80[0x2a] = left;
    structb80[0x2d] = right;
    
    left, right = sub_80e7(*data_e40, &structb80[0x11], buffer_sections[6], *data_e41, buffer_sections[7]);
    structb80[0x2b] = left;
    structb80[0x2e] = right;

    left, right = sub_80e7(*data_e43, &structb80[0x17], buffer_sections[2], *data_e43, buffer_sections[5]);
    structb80[0x2f] = left;
    structb80[0x30] = right;

    left, right = sub_80e7(*data_e43, &structb80[0x15], buffer_sections[8], *data_e43, buffer_sections[2]);
    structb80[0x31] = left;
}

// @8c6
void pre_8() {
    // calls 8282
    // u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    // structb80[0x29] = left;
    // structb80[0x2c] = right;
}

// @79d
void pre_x() {
    u16 left, right = sub_80e7(*data_e40, &structb80[9], buffer_sections[0], *data_e41, buffer_sections[1]);
    structb80[0x29] = left;
    structb80[0x2c] = right;
    
    left, right = sub_80e7(*data_e40, &structb80[0xd], buffer_sections[6], *data_e41, buffer_sections[7]);
    structb80[0x2b] = left;
    structb80[0x2e] = right;
}