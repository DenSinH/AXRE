extern u16 callback;

void command_0() {
    send_cpu_mail(0x8000, callback);
    wait_for_mail_sent();
}