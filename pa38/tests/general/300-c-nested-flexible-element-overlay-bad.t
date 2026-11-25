struct Entry { unsigned key; char text[]; };
union Slot { struct Entry entry; char reserve[32]; };
static union Slot data = {.entry.text = "abcd", .entry.text[1] = 'x'};
