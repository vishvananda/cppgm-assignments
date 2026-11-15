extern "C" int implementation(int value) { return value; }
extern "C" int invalid(int value) __attribute__((alias("implementation"))) { return value; }
