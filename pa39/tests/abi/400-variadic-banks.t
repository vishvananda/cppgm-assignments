struct Pair { float a, b; };
extern "C" int fold(int tag, ...) {
    __builtin_va_list ap, copy;
    __builtin_va_start(ap, tag);
    __builtin_va_copy(copy, ap);
    Pair p = __builtin_va_arg(ap, Pair);
    Pair q = __builtin_va_arg(copy, Pair);
    __builtin_va_end(copy);
    int result = tag + int(p.a + p.b + q.a);
    for (int i = 0; i != 9; ++i) {
        result += __builtin_va_arg(ap, int);
        result += int(__builtin_va_arg(ap, double));
    }
    __builtin_va_end(ap);
    return result;
}
