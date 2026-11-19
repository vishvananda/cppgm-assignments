extern "C" void sweep(int* data, int last) {
    for (int i = 1; i < last; ++i) {
        int left = data[i], right = data[i + 1];
        if (left > right) {
            data[i] = right;
            data[i + 1] = left;
        }
    }
}

extern "C" void sweep_alias(int* data, int last, int* other) {
    for (int i = 1; i < last; ++i) {
        int left = data[i], right = data[i + 1];
        if (left > right) {
            data[i] = right;
            data[i + 1] = left;
            *other = right + 1;
        }
    }
}
