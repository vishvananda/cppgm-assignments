static int sequence;
static void append(int digit) { sequence = sequence * 10 + digit; }
__attribute__((constructor(300))) static void late(void) { append(3); }
__attribute__((constructor(100))) static inline void early(void) { append(1); }
static void middle(void) __attribute__((constructor(200)));
static void middle(void) __attribute__((constructor(200)));
static void middle(void) { append(2); }
__attribute__((__constructor__)) static void last(void) { append(4); }
extern "C" int observe(void) { return sequence; }
