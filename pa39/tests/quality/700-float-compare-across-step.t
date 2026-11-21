// A floating comparison keeps its flags across the counter update that
// follows it: the loop below selects its count from the flags of the NaN
// test instead of materializing the comparison first.
extern "C" int count_unordered(const double* values, int n) {
    int count = 0;
    for (int i = 0; i < n; ++i)
        if (values[i] != values[i])
            ++count;
    return count;
}
