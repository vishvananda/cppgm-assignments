struct Entry { unsigned key; char text[]; };
union Slot { struct Entry entry; unsigned char reserve[32]; };
struct Group {
    unsigned lead;
    union Slot slot;
    unsigned tail;
};

static volatile struct Group group = {23, {{29, "black"}}, 31};

int main(void) {
    return group.lead != 23 || group.slot.entry.key != 29 ||
        group.slot.entry.text[0] != 'b' || group.slot.entry.text[4] != 'k' ||
        group.slot.entry.text[5] != 0 || group.tail != 31;
}
