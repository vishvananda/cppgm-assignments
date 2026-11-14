int before(void) { return __builtin_ctz(16u); }
static int __builtin_ctz(unsigned long value) { return value + 23; }
int main(void) { return !(before() == 4 && __builtin_ctz(7ul) == 30); }
