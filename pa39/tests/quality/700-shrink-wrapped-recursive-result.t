// The result of the recursion crosses the calls of the levels inlined into
// it, but the early return's 1 takes a caller register: the entry test and
// that return run before the prologue, and no jump reaches a shared
// epilogue from the entry. Both edges of an inlined level's test start that
// level's sum at 0, which the test sets once before its branch.
extern "C" __attribute__((noinline)) unsigned long fib(unsigned long n) {
    if (n < 2)
        return 1;
    return fib(n - 2) + fib(n - 1);
}
