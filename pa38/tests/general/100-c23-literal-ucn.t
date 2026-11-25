#if '\u0041' != 'A' || '\u0000' != 0
#error universal character names in preprocessing character constants
#endif

static const char text[] = "\u0041\u0000\u000A\u007F";
int main(void)
{
    return sizeof text != 5 || text[0] != 'A' || text[1] != 0 ||
           text[2] != '\n' || text[3] != 127 || text[4] != 0 ||
           L'\u0000' != 0 || U'\u0041' != 'A';
}
