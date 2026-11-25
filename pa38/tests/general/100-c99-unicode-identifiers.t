#define PASTE(a, b) a ## b
#define ª_value 5

enum {
    \u00AA = 1,
    \u0E4F = 2,
    a\u0E\
50 = 3,
    a\u00AA = 4
};

int main(void)
{
    const unsigned char text[] = "\u01F6";
    return ª != 1 || ๏ != 2 || a๐ != 3 || PASTE(a, ª) != 4 ||
        \u00AA_value != 5 || text[0] != 0xC7 || text[1] != 0xB6;
}
