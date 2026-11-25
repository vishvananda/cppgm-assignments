struct Entry { unsigned key; char text[]; };
union Slot { struct Entry entry; char reserve[32]; };
struct Record { struct Entry entry; unsigned next; }; static struct Record data = {{1, "overlap"}, 3};
