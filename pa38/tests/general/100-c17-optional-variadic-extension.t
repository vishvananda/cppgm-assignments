#define NUMBER(...) (1 __VA_OPT__(+ (__VA_ARGS__)))

int main(void) { return NUMBER() != 1 || NUMBER(4) != 5; }
