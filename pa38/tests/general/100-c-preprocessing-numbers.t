#define tail 7
#define SPELL_(x) #x
#define SPELL(x) SPELL_(x)
#define PASTE(a, b) a ## b

static int equal(const char *a, const char *b) {
    for (; *a == *b; ++a, ++b)
        if (*a == 0)
            return 1;
    return 0;
}

int main(void) {
    return !(equal(SPELL(0xe+tail), "0xe+tail") &&
             equal(SPELL(0xe + tail), "0xe + 7") &&
             equal(SPELL(.7p+tail), ".7p+tail") &&
             equal(SPELL(1e\
-tail), "1e-tail") &&
             equal(SPELL(PASTE(0x1p, +)), "0x1p+") &&
             equal(SPELL(1.5.2), "1.5.2") &&
             0x1p+2 == 4.0);
}
