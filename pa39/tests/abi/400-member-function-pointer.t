struct A {
    int value;
    int add(int n) const { return value + n; }
};
using Member = int (A::*)(int) const;

extern "C" int named(int bias, Member m, long tail) {
    A object{10};
    return bias + (object.*m)(2) + int(tail);
}

extern "C" int stacked(long, long, long, long, long, long, long, long,
                       long bias, Member m, long tail) {
    return named(int(bias), m, tail);
}

extern "C" int varied(int bias, ...) {
    __builtin_va_list ap;
    __builtin_va_start(ap, bias);
    Member m = __builtin_va_arg(ap, Member);
    long next = __builtin_va_arg(ap, long);
    Member empty = __builtin_va_arg(ap, Member);
    long tail = __builtin_va_arg(ap, long);
    __builtin_va_end(ap);
    if (empty != nullptr) return -1;
    return named(bias, m, next + tail);
}
