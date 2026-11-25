#if CONVERT_TRIGRAPHS
??=define DIRECTIVE_VALUE 21
#else
#define DIRECTIVE_VALUE 42
#endif

static const char spelling[] = "??=";
static int after_comment = 0
// The next physical line is part of the comment when trigraphs are enabled. ??/
    + 1
;

int main(void) {
#if CONVERT_TRIGRAPHS
    return DIRECTIVE_VALUE != 21 || sizeof spelling != 2 ||
           spelling[0] != '#' || after_comment != 0;
#else
    return DIRECTIVE_VALUE != 42 || sizeof spelling != 4 ||
           spelling[2] != '=' || after_comment != 1;
#endif
}
