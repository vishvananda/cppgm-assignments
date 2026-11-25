#define QUOTE(text) #text
#define UNUSED "\u0041"

#if 0
const char *skipped = "\u0042";
#endif

int main(void)
{
    const unsigned char text[] = "\u0024\u0040\u0060\u00a0";
    const char *quoted = QUOTE("\u0041");
    return text[0] != '$' || text[1] != '@' || text[2] != '`' ||
        text[3] != 0xc2 || text[4] != 0xa0 || text[5] != 0 ||
        quoted[0] != '"' || quoted[1] != '\\' || quoted[2] != 'u';
}
