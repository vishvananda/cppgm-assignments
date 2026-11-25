struct Entry { unsigned key; char text[]; };
union Slot { struct Entry entry; char reserve[32]; };
static union Slot data = {{1, { 'x', 'y', 0 }}};
