using Int4 = int __attribute__((vector_size(16)));
using Float4 = float __attribute__((vector_size(16)));
extern "C" Int4 mix(Int4 a, Int4 b) { return (a + b) * b; }
extern "C" Float4 scale(Float4 a, Float4 b) { return a * b + b; }
extern "C" void transform(int* __restrict output, const int* input, int count) {
    for (int i = 0; i < count; ++i) output[i] = 3 * input[i] + 1;
}
