// Loop-carried values that trade places on the backedge, and a sift-down
// whose index takes the value of the child it compared.
extern "C" __attribute__((noinline)) unsigned rotate_mix(const unsigned* input, unsigned count) {
    unsigned a = 1, b = 2, c = 3;
    for (unsigned i = 0; i != count; ++i) {
        unsigned next = a ^ (input[i] + c);
        a = b;
        b = c;
        c = next;
    }
    return a * 3 + b * 5 + c * 7;
}

extern "C" __attribute__((noinline)) void sift_down(double* heap, int top, int size) {
    double value = heap[top];
    int i = top, j = top * 2;
    while (j <= size) {
        if (j < size && heap[j] < heap[j + 1]) ++j;
        if (value < heap[j]) {
            heap[i] = heap[j];
            i = j;
            j += j;
        } else
            j = size + 1;
    }
    heap[i] = value;
}
