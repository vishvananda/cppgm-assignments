// Switches of five runs or more with gaps between them search by halves:
// each step compares the selector with the middle run's lowest value, and
// the runs that remain test against what the earlier compares proved.
// Signed and unsigned selectors of each width order their cases as their
// compares do, including values at the type's limits.
extern "C" {
__attribute__((noinline)) int s32(int v) {
    switch (v) {
    case -2147483647 - 1: return 1;
    case -100000: return 2;
    case -7: return 3;
    case -1: return 4;
    case 0: return 5;
    case 3: case 4: case 5: return 6;
    case 9: return 7;
    case 100: return 8;
    case 4096: return 9;
    case 70000: return 10;
    case 2147483647: return 11;
    }
    return 0;
}

__attribute__((noinline)) int u32(unsigned v) {
    switch (v) {
    case 0: return 1;
    case 2: return 2;
    case 10: case 11: case 12: case 13: return 3;
    case 50: return 4;
    case 0x7fffffffu: return 5;
    case 0x80000000u: return 6;
    case 0xfffffff0u: return 7;
    case 0xffffffffu: return 8;
    }
    return 0;
}

__attribute__((noinline)) int u8(unsigned char v) {
    switch (v) {
    case 1: return 1;
    case 8: return 2;
    case 10: return 3;
    case 21: return 4;
    case 200: return 5;
    case 255: return 6;
    }
    return 0;
}

__attribute__((noinline)) int s64(long v) {
    switch (v) {
    case -9223372036854775807L - 1: return 1;
    case -5000000000L: return 2;
    case -3: return 3;
    case 0: return 4;
    case 7: return 5;
    case 1000: case 1001: case 1002: return 6;
    case 5000000000L: return 7;
    case 9223372036854775807L: return 8;
    }
    return 0;
}

__attribute__((noinline)) int u64(unsigned long v) {
    switch (v) {
    case 0: return 1;
    case 5: return 2;
    case 77: return 3;
    case 0x8000000000000000ul: return 4;
    case 0xfffffffffffffff0ul: return 5;
    case 0xfffffffffffffffful: return 6;
    }
    return 0;
}

// Targets that take values on their edges.
__attribute__((noinline)) long moves(int v, long a, long b) {
    long x = a, y = b;
    switch (v) {
    case 2: x = b; y = a; break;
    case 9: x = a + b; break;
    case 30: y = a - b; break;
    case 31: x = 0; y = 0; break;
    case 64: x = a * 3; y = b * 5; break;
    case 1000: return a ^ b;
    default: x = a + 1; break;
    }
    return x * 7 + y;
}
}
