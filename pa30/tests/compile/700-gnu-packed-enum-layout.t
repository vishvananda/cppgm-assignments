enum Positive { largest = 255 } __attribute__((packed));
enum __attribute__((packed)) Signed { low = -129, high = 127 };
enum Fixed : long { explicit_base = 7 } __attribute__((packed));

static_assert(sizeof(Positive) == sizeof(unsigned char), "byte-sized");
static_assert(sizeof(Signed) == sizeof(short), "signed short-sized");
static_assert(sizeof(Fixed) == sizeof(long), "fixed base");

int main() { return 0; }
