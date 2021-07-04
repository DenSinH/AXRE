void (*cmd_f_table[4])() = {
    j_send_dcd10001_irq, debug_reset, j_rom_start, j_wait_for_babe
}

void command_f(u16* &command_stream) {
    send_mail(0xdcd1, 0x0002);
    send_irq();
    u32 mail = wait_for_mail_recv();

    // jump to callback from lower mail
    // the j_* callbacks jump to other parts in the program
    cmd_f_table[mail & 0xffff]();
}

void j_send_dcd10001_irq() {
    // in main_entry (soft reset)
    goto send_dcd10001_mail;
}

// used in ROM setup (calling transfer_ucode)
extern struct setup_data {
    u32 dma_mm_addr;   // IX0/IX1
    u16 dma_dsp_addr;  // IX2
    u16 dma_length;    // IX3
    u16 dma_control;   // AC0.M
    u16 entry_point;   // AR0
}

void debug_reset() {
    u32 mmaddr  = wait_for_mail_recv();       // AC0
    u16 length  = (u16)wait_for_mail_recv();  // AC1.L
    u16 dspaddr = (u16)wait_for_mail_recv();  // AC1.M
    dma_dmem_to_mmem(mmaddr, dspaddr, length);

    setup_data.dma_mm_addr  = wait_for_mail_recv();       // AC0 / IX0/1
    setup_data.dma_dsp_addr = (u16)wait_for_mail_recv();  // AC1.L / IX3
    setup_data.dma_length   = (u16)wait_for_mail_recv();  // AC1.M / IX2
    setup_data.dma_control  = 0;                          // AC0.M
    setup_data.entry_point  = (u16)wait_for_mail_recv();  // AC0.M / AR0

    mmaddr    = wait_for_mail_recv();       // AX0
    length    = (u16)wait_for_mail_recv();  // AX1.L
    dspaddr   = (u16)wait_for_mail_recv();  // AX1.H

    wait_for_dma_finish();

    // in ROM: (80b5)
    if (length) {
        dma_to_dmem(mmaddr, dspaddr, length);
        wait_for_dma_finish();
    }
    transfer_ucode();  // also calls entry point
}

void j_rom_start() {
    // in ROM 0x8000 (hard reset)
    goto rom_start;
}

void j_wait_for_babe() {
    // in main_entry (softer reset)
    goto wait_for_babe;
}