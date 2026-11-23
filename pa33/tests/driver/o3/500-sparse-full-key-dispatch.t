// Bound dispatch size and reject misses that share low bits with a case.
extern "C" int dispatch(unsigned key, int* data) {
    switch (key) {
    case 2147500032u: return data[0] + 3;
    case 2147504129u: return data[1] + 23;
    case 2147508226u: return data[2] + 7;
    case 2147512323u: return data[3] + 81;
    case 2147516420u: return data[4] + 93;
    case 2147520517u: return data[5] + 11;
    case 2147524614u: return data[6] + 17;
    case 2147528711u: return data[7] + 35;
    case 2147532808u: return data[8] + 57;
    case 2147536905u: return data[9] + 28;
    case 2147541002u: return data[10] + 63;
    case 2147545099u: return data[11] + 19;
    default: return -1;
    }
}

int main() {
    int data[12] = {3, 23, 7, 81, 93, 11, 17, 35, 57, 28, 63, 19};
    volatile unsigned base = 0x80004000u;
    for (unsigned i = 0; i < 12; ++i) {
        const unsigned key = base + i * 4097u;
        if (dispatch(key, data) != data[i] * 2)
            return 1;
        if (dispatch(key + 0x10000000u, data) != -1 || dispatch(key - 0x10000000u, data) != -1)
            return 2;
    }
    return dispatch(base + 12u, data) != -1;
}
