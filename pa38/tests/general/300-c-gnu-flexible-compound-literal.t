struct Entry { unsigned key; char text[]; };
union Slot { struct Entry entry; unsigned char reserve[32]; };
static const struct Entry *direct = &(struct Entry){ 5, "zero" };
static const union Slot *reference = &(union Slot){{ 7, "one" }};
static union Slot copied = (union Slot){{ 11, "two" }};

int main(void) {
    return direct->key != 5 || direct->text[3] != 'o' ||
        reference->entry.key != 7 || reference->entry.text[1] != 'n' ||
        copied.entry.key != 11 || copied.entry.text[1] != 'w';
}
