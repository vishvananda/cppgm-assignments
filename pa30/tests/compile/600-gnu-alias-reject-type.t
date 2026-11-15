extern "C" int implementation = 7;
extern "C" int invalid(int) __attribute__((alias("implementation")));
