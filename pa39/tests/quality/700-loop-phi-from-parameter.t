// An iterative regular expression matcher. The pattern pointer is a loop
// phi that starts as a parameter; its one back-edge input is made before a
// call. The copy runs before the loop's conditional branch, so the phi
// keeps the parameter's register instead of taking a copy at the header.
enum { UNUSED, DOT, BEGIN, END, QUESTIONMARK, STAR, PLUS, CHAR };

struct regex_t {
    unsigned char type;
    union {
        unsigned char ch;
        unsigned char* ccl;
    } u;
};

extern "C" int matchone(regex_t p, char c);
extern "C" int matchstar(regex_t p, regex_t* pattern, const char* text, int* length);
extern "C" int matchplus(regex_t p, regex_t* pattern, const char* text, int* length);
extern "C" int matchpattern(regex_t* pattern, const char* text, int* length);

static int matchquestion(regex_t p, regex_t* pattern, const char* text, int* length) {
    if (p.type == UNUSED)
        return 1;
    if (matchpattern(pattern, text, length))
        return 1;
    if (*text && matchone(p, *text++)) {
        if (matchpattern(pattern, text, length)) {
            (*length)++;
            return 1;
        }
    }
    return 0;
}

extern "C" __attribute__((noinline)) int matchpattern(regex_t* pattern, const char* text, int* length) {
    int pre = *length;
    do {
        if (pattern[0].type == UNUSED || pattern[1].type == QUESTIONMARK)
            return matchquestion(pattern[0], &pattern[2], text, length);
        else if (pattern[1].type == STAR)
            return matchstar(pattern[0], &pattern[2], text, length);
        else if (pattern[1].type == PLUS)
            return matchplus(pattern[0], &pattern[2], text, length);
        else if (pattern[0].type == END && pattern[1].type == UNUSED)
            return text[0] == '\0';
        (*length)++;
    } while (text[0] != '\0' && matchone(*pattern++, *text++));
    *length = pre;
    return 0;
}
