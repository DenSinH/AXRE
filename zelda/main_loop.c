extern void (*callbacks[??])();  // at 0x62

u16 cmd_info_lo;
u8 cmd_info_hi;
void (*callback)();


void main_loop() {
    memset(0x0000, 0, 0x1000);  // words, not bytes
    read_mail_recv();  // clear mailbox mail ready bit
    send_mail(0x8888, 0x1111);
    wait_for_mail_sent();

    while (true) {
        u32 mail = wait_for_mail_recv();
        cmd_info_lo = (u16)mail;
        cmd_info_hi = (mail >> 16) & 0xff;
        u16 index = (mail >> (16 + 7)) & 0x7e;

        // in the assembly this is just a switch case
        // the offset is in 2 words, this shift does not happen
        callback = callbacks[index >> 1]
        callback();
    }
}