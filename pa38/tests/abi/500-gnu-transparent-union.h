struct Record { int value; };

typedef union {
    int *integer;
    const struct Record *record;
    unsigned long bits;
} Argument __attribute__((__transparent_union__));

unsigned long host_read(Argument, int);
unsigned long host_call(unsigned long (*)(Argument, int));
