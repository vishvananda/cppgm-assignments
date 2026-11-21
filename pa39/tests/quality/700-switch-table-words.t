// A dense switch dispatches through a table of halfwords, each its case's
// distance in instructions from the table: the indirect branch goes to the
// case itself, with no jump in between, and the table takes half the bytes
// of one of jumps.
extern "C" __attribute__((noinline)) int pick(unsigned k, int a) {
    switch (k) {
    case 0:
        return a + 1;
    case 1:
        return a * 3;
    case 2:
        return a - 7;
    case 3:
        return a ^ 5;
    case 4:
        return a << 2;
    case 5:
        return a >> 1;
    case 6:
        return -a;
    case 8:
        return a | 64;
    default:
        return 0;
    }
}

extern "C" __attribute__((noinline)) long wide_pick(unsigned long k, long a) {
    switch (k) {
    case 10:
        return a + 11;
    case 11:
        return a * 5;
    case 12:
        return a - 13;
    case 13:
        return a ^ 0x55;
    case 14:
        return a << 3;
    case 15:
        return ~a;
    case 17:
        return a & 0xf0;
    default:
        return -1;
    }
}

// A dispatch loop: the default, which the table's hole at 3 reaches, sits
// before the table.
extern "C" __attribute__((noinline)) int run(const unsigned char* code, int acc) {
    for (;;) {
        switch (*code++) {
        case 0:
            return acc;
        case 1:
            acc += 3;
            break;
        case 2:
            acc *= 2;
            break;
        case 4:
            acc ^= 0x40;
            break;
        case 5:
            acc = -acc;
            break;
        case 6:
            acc >>= 1;
            break;
        case 7:
            acc -= 1;
            break;
        default:
            acc += 100;
            break;
        }
    }
}
