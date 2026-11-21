// A heap sift. The loop's last test repeats the loop or leaves it, and both
// edges copy the new parent index into the parent's register: the copy runs
// once before the branch, neither edge needs a block of its own, and the
// loop's first test, which repeats that compare, takes its flags.
extern "C" __attribute__((noinline)) void sift(long* heap, unsigned parent, unsigned last) {
    const long moving = heap[parent];
    unsigned at = parent, child = parent * 2;
    while (child <= last) {
        if (child < last && heap[child] < heap[child + 1])
            ++child;
        if (moving < heap[child]) {
            heap[at] = heap[child];
            child += (at = child);
        } else
            child = last + 1;
    }
    heap[at] = moving;
}
