// A switch with a jump table whose case starts with a test that keeps the
// flags, before a compare that the case's other path skips. The case is
// entered by the table's indirect branch, so no compare before it sets the
// flags that its compare would leave, and the compare stays.
extern "C" __attribute__((noinline)) int intrinsic(unsigned op, unsigned variant, unsigned count, int* out) {
    switch (op) {
    case 0:
        return count + 1;
    case 1:
        return count * 3;
    case 2:
        out[0] = variant;
        return 5;
    case 3:
        return variant - count;
    case 4:
        out[1] = count;
        return 7;
    case 5:
        return variant ^ 9;
    case 6:
        return count << 2;
    case 7: {
        const int kind = variant == 0 ? 29 : variant == 1 ? 30 : 31;
        if (count != (kind == 30 ? 1u : 2u))
            return -1;
        out[2] = kind;
        return kind;
    }
    case 8:
        return variant + 11;
    case 9:
        out[3] = 4;
        return 13;
    case 10:
        return count - 3;
    case 11:
        return variant * 5;
    }
    return 0;
}
