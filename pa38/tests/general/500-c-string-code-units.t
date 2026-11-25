#define TEXT "\u00e9" "\000" "\u03\
bb"

static unsigned char stored[] = TEXT;
static __CHAR16_TYPE__ utf16[] = u"\U0001f642" "\0" u"Q";
static __CHAR32_TYPE__ utf32[] = U"\U0001f642" "\0" U"Q";

static int correct_narrow(const unsigned char *bytes)
{
    return bytes[0] == 0xc3 && bytes[1] == 0xa9 && bytes[2] == 0 &&
           bytes[3] == 0xce && bytes[4] == 0xbb && bytes[5] == 0;
}

int main(void)
{
    const unsigned char *literal = (const unsigned char *)TEXT;
    struct { unsigned char bytes[9]; } local = { TEXT };
    volatile unsigned char automatic[8] = TEXT;

    return sizeof stored != 6 || !correct_narrow(stored) || !correct_narrow(literal) ||
           !correct_narrow(local.bytes) || local.bytes[8] != 0 ||
           automatic[3] != 0xce || automatic[7] != 0 ||
           sizeof utf16 != 5 * sizeof utf16[0] || utf16[0] != 0xd83d ||
           utf16[1] != 0xde42 || utf16[2] != 0 || utf16[3] != 'Q' || utf16[4] != 0 ||
           sizeof utf32 != 4 * sizeof utf32[0] || utf32[0] != 0x1f642 ||
           utf32[1] != 0 || utf32[2] != 'Q' || utf32[3] != 0;
}
