// A switch with a jump table whose cases start with a compare and a
// branch. A case the table reaches has whatever flags the code before the
// table jump left, so its compare stays.
extern "C" __attribute__((noinline)) int dispatch(const unsigned char* ops, int count, int value, int* out) {
    int acc = 0;
    for (int i = 0; i < count; ++i) {
        switch (ops[i]) {
        case 0:
            acc += 1;
            break;
        case 1:
            if (value == 7)
                out[i] = acc;
            break;
        case 2:
            acc ^= value;
            break;
        case 3:
            if (acc == 7)
                out[i] = value;
            break;
        case 4:
            acc -= value;
            break;
        case 5:
            if (value < 5)
                out[i] = acc + 1;
            break;
        case 6:
            acc *= 3;
            break;
        case 7:
            if (value == 7)
                out[i] = 3;
            break;
        }
    }
    return acc;
}
