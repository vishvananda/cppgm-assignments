static int row[3] = { 4, 7, 9 };

static int local_value(int (*value)[]) { return (*value)[1]; }

static int inherited_linkage(void)
{
    int local_value(int (*)[3]);
    return local_value(&row);
}

static int from_first_block(void)
{
    extern int next_value(int (*)[3]);
    return next_value(&row);
}

extern int next_value();

static int from_file_declaration(void)
{
    return next_value(&row);
}

int next_value(int (*value)[3]) { return (*value)[2]; }

static int hidden_prototype(void)
{
    int value = 3;
    int next_value = 1;
    {
        extern int next_value();
        _Static_assert(sizeof next_value(&row, 1) == sizeof(int), "the prototype is hidden");
        value = next_value(&row);
    }
    return value + next_value;
}

static int nested_composite(void)
{
    extern int (*get_row(void))[3];
    {
        extern int (*get_row(void))[];
        _Static_assert(sizeof *get_row() == sizeof row, "inherit the visible bound");
        return (*get_row())[0];
    }
}

int (*get_row(void))[3] { return &row; }

static int from_unprototyped_block(void)
{
    extern int remote_value();
    return remote_value(&row);
}

static int from_prototyped_block(void)
{
    extern int remote_value(int (*)[3]);
    return remote_value(&row);
}

int main(void)
{
    return !(inherited_linkage() == 7 && from_first_block() == 9 &&
        from_file_declaration() == 9 && hidden_prototype() == 10 && nested_composite() == 4 &&
        from_unprototyped_block() == 7 && from_prototyped_block() == 7);
}
