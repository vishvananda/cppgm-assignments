struct Entry { unsigned key; char text[]; };
union Slot { struct Entry entry; char reserve[32]; };
int f(void) { union Slot data = {{1, "auto"}}; return data.entry.key; }
