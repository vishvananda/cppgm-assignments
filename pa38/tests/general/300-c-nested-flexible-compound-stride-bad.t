struct Entry { unsigned key; char text[]; };
static struct Entry data[2] = {
    (struct Entry){ 7, "longer than the element" },
    { 11 },
};
