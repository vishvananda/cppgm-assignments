// Merge sort's merge loop. The loop's last block goes back to the loop
// header or on to the copy of the rest, both placed before it; the
// conditional branch takes the edge back to the header and the jump the
// exit, so an iteration runs one branch.
extern "C" __attribute__((noinline)) void merge(int* values, int* scratch, int left, int middle, int right) {
    for (int i = left; i <= right; i++)
        scratch[i] = values[i];
    int i = left, j = middle + 1, k = left;
    while (i <= middle && j <= right) {
        if (scratch[i] <= scratch[j])
            values[k] = scratch[i++];
        else
            values[k] = scratch[j++];
        k++;
    }
    while (i <= middle)
        values[k++] = scratch[i++];
}
