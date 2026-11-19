using Int4 = int __attribute__((vector_size(16)));
using Float4 = float __attribute__((vector_size(16)));
extern "C" Int4 mix(Int4 a, Int4 b) { return (a + b) * b; }
extern "C" Float4 scale(Float4 a, Float4 b) { return a * b + b; }
extern "C" void transform(int* __restrict output, const int* input, int count) {
    for (int i = 0; i < count; ++i) output[i] = 3 * input[i] + 1;
}
extern "C" void floating_bounds(double* __restrict low, double* __restrict high,
                                 const double* a, const double* b, int count) {
    for (int i = 0; i < count; ++i) {
        low[i] = a[i] < b[i] ? a[i] : b[i];
        high[i] = a[i] > b[i] ? a[i] : b[i];
    }
}
extern "C" int dot_pairs(const short* a, const short* b, int count) {
    int result = 0;
    for (int i = 0; i < count; i += 2)
        result += (a[i] * b[i] + a[i + 1] * b[i + 1]) >> 8;
    return result;
}
extern "C" double ordered_dot(const double* a, const double* b, int count) {
    double result = 0;
    for (int i = 0; i < count; ++i) result += a[i] * b[i];
    return result;
}
extern "C" unsigned sum_words(const unsigned* values, int count) {
    unsigned result = 0;
    for (int i = 0; i < count; ++i) result += values[i];
    return result;
}
extern "C" unsigned long long adjust_count(unsigned long long count, float left, float right, bool reverse) {
    if (reverse) return left >= right ? count : count + 1;
    return left >= right ? count + 1 : count;
}
extern "C" void update_arrays(double* a, double* b) {
    for (int round = 0; round < 3; ++round) {
        for (int i = 0; i < 8; ++i) {
            double x = a[i], y = b[i];
            a[i] = x - y;
            b[i] = (x + y) * 0.25;
        }
    }
}
extern "C" double bounded_recurrence(double a, double b, double c, double cap, int count) {
    while (count > 0 && a + c < cap) {
        double next = a + (b - c) * 0.5;
        a = b;
        b = c;
        c = next;
        --count;
    }
    return a - b + c;
}
extern "C" Int4 vector_recurrence(Int4 a, Int4 b, int count) {
    for (int i = 0; i < count; ++i) {
        Int4 next = a + b;
        a = b;
        b = next;
    }
    return b - a;
}
extern "C" void vector_aggregate(Int4* output, const Int4* input, int rounds, bool use_pointer) {
    struct State { Int4 values[8]; Int4* first; };
    State seed;
    seed.first = seed.values;
    State state;
    state.first = state.values;
    for (int i = 0; i < 8; ++i) {
        seed.values[i] = input[i];
        state.values[i] = seed.values[i];
    }
    for (int round = 0; round < rounds; ++round)
        for (int i = 0; i < 8; ++i) state.values[i] += seed.values[7 - i];
    const Int4* result = use_pointer ? state.first : state.values;
    for (int i = 0; i < 8; ++i) output[i] = result[i];
}
extern "C" void record_accumulation();
extern "C" Int4 vector_recurrence_with_call(Int4 a, Int4 b, Int4 c, int count) {
    for (int i = 0; i < count; ++i) {
        record_accumulation();
        Int4 next = a + c;
        a = b;
        b = c;
        c = next;
    }
    return a + (b + b) - c;
}
extern "C" float conditional_accumulation(const float* values, int count, int record_at) {
    float a = 0, b = 1, c = 2, d = 3, e = 4, f = 5, g = 6, h = 7, j = 8;
    for (int i = 0; i < count; ++i) {
        float x = values[i];
        if (x == 0) continue;
        if (i == record_at) record_accumulation();
        a += x;
        b -= 2 * x;
        c += 3 * x;
        d -= 4 * x;
        e += 5 * x;
        f -= 6 * x;
        g += 7 * x;
        h -= 8 * x;
        j += 9 * x;
    }
    return a + 2 * b + 3 * c + 4 * d + 5 * e + 6 * f + 7 * g + 8 * h + 9 * j;
}
