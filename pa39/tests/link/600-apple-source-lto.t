inline int bias = 7;
static int adjust(int value) { return value * 3; }
extern "C" int other(int);
extern const char* volatile word;
int main() { return other(adjust(bias)) + __builtin_strlen(word); }
