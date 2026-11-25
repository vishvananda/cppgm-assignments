extern __thread int tls;
static int value;

int main(void) { return __alignof__(value) != __alignof(int); }
