static int row[3];

static int use_block_declaration(void)
{
    extern int (*get_row(void))[3];
    return (*get_row())[0];
}

extern int (*get_row(void))[];
_Static_assert(sizeof *get_row() == sizeof row, "the file declaration cannot see the block bound");
