extern struct* structb80;

void accov_handler() {
    if (structb80[0x7] != 1) {
        structb80[0x7] = 0;
        return;
    }
    if (structb80[0x8] != 1) {
        IO[0xda] = structb80[0x5a];  // bda
        IO[0xdb] = structb80[0x5b];  // bdb
        IO[0xdc] = structb80[0x5c];  // bdc
        return;
    }
    IO[0xda] = structb80[0x5a];  // bda
    IO[0xdb] = structb80[0x5b];  // bdb
    IO[0xdc] = structb80[0x5c];  // bdc
    structb80[0x5c]++;  // bdd
}