// An insertion sort between calls, with more values across the calls than
// preserved registers. The sort's start crosses a call in a preserved
// register that the inner loop's cursor then takes; the outer cursor's
// increment keeps the outer cursor's register.
struct rank_pair {
    int first, second;
};

extern "C" unsigned long* first_unsorted(unsigned long* begin, unsigned long* end);
extern "C" void prepare(unsigned long* begin, unsigned long* end, rank_pair* ranks);
extern "C" void report(const unsigned long* begin, const unsigned long* end, int a, int b, int c, int d, int e, int f, int g, int h);

extern "C" __attribute__((noinline)) void sort_ranks(unsigned long* begin, unsigned long* end, rank_pair* ranks) {
    const int a = ranks[0].first, b = ranks[1].first, c = ranks[2].first, d = ranks[3].first, e = ranks[4].first,
              f = ranks[5].first, g = ranks[6].first, h = ranks[7].first;
    unsigned long* const start = first_unsorted(begin, end);
    prepare(begin, end, ranks);
    if (start != begin)
        for (unsigned long* i = start; i != end; ++i) {
            const unsigned long value = *i;
            const rank_pair key = ranks[value];
            unsigned long* hole = i;
            unsigned long* next = i - 1;
            while (key.first < ranks[*next].first ||
                (key.first == ranks[*next].first && key.second < ranks[*next].second)) {
                *hole = *next;
                hole = next;
                --next;
            }
            *hole = value;
        }
    report(begin, end, a, b, c, d, e, f, g, h);
}
