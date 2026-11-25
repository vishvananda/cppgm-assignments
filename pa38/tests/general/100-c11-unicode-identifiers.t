#define PASTE(a, b) a ## b

enum {
    \u01F6 = 1,
    \u0E50 = 2,
    PASTE(a, Ƕ) = 3
};

int main(void)
{
    return Ƕ != 1 || ๐ != 2 || a\u01F6 != 3;
}
