extern "C" int first(int) __attribute__((alias("second")));
extern "C" int second(int) __attribute__((alias("first")));
