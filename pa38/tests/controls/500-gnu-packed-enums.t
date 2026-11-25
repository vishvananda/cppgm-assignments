// expect exit 0

enum small { zero = 0, maximum = 255 } __attribute__((packed));
enum __attribute__((packed)) negative { lower = -129, upper = 127 };

_Static_assert(sizeof(enum small) == sizeof(unsigned char), "unsigned byte enum");
_Static_assert(sizeof(enum negative) == sizeof(short), "signed short enum");
_Static_assert(sizeof(maximum) == sizeof(int), "enumerator keeps type int");

struct pair {
    enum small first;
    enum small second;
};

int main(void)
{
    struct pair value = { zero, maximum };
    enum negative low = lower;
    return sizeof(value) != 2 || value.second != 255 || low != -129;
}
