void receive_mail_to(u32* &addr) {
    // addr: AR0
    u32 mail = wait_for_mail_recv();
    *addr++ = mail;  // increments AR0 by 2
}

extern u32 mmaddrs[4];  // at 380
u16 cmd_info_lo_copy_cmd1;  // at 342

void command_1() {
    u32* addrs = mmaddrs;  // = 0x380

    // fill with 4 mmaddrs
    receive_mail_to(addrs);
    receive_mail_to(addrs);
    receive_mail_to(addrs);
    receive_mail_to(addrs);

    // DMA 0x200 words
    dma_from_at_ar1(&mmaddrs[1], 0, 0x200);
    // DMA 0x20 words
    dma_from_at_ar1(&mmaddrs[2], 0x300, 0x20);

    memcpy32(0xffa0, 0x300, 8);
    cmd_info_lo_copy_cmd1 = cmd_info_lo;

    command_0();
}