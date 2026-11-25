struct Entry { unsigned key; char text[]; };
union Slot { struct Entry entry; unsigned char reserve[32]; };
union Outer { union Slot slot; unsigned fallback; };
union Small { struct Entry entry; unsigned fallback; };
struct End { unsigned marker; struct Entry entry; };

static union Outer positional = {{{7, "red"}}};
static union Outer designated = {.slot.entry.key = 11, .slot.entry.text = {"blue"}};
static union Small grown = {{17, "yellow"}};
static struct End extended = {13, {19, "green"}};
static union Slot partial = {.entry = (struct Entry){37}, .entry.text = "white"};
static union Slot replaced = {.entry = {1, "discarded"}, .reserve = {13, 14}};

static int equal(volatile const char *text, const char *expected) {
    while (*expected != 0)
        if (*text++ != *expected++)
            return 0;
    return *text == 0;
}

int main(void) {
    if (sizeof(positional) != 32 || sizeof(designated) != 32 ||
        positional.slot.entry.key != 7 || designated.slot.entry.key != 11 ||
        !equal(positional.slot.entry.text, "red") || !equal(designated.slot.entry.text, "blue"))
        return 1;
    if (sizeof(grown) != sizeof(unsigned) || grown.entry.key != 17 || !equal(grown.entry.text, "yellow"))
        return 2;
    if (extended.marker != 13 || extended.entry.key != 19 || !equal(extended.entry.text, "green"))
        return 3;
    if (partial.entry.key != 37 || !equal(partial.entry.text, "white"))
        return 4;
    return replaced.reserve[0] != 13 || replaced.reserve[1] != 14 || replaced.reserve[2] != 0;
}
