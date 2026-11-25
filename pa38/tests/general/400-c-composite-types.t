static int row[3] = { 4, 7, 9 };

extern int (*data)[];
int (*first(void))[3] { return data; }
int (*data)[3] = &row;

extern int (*scoped)[];
static int read_scoped(void)
{
    extern int (*scoped)[3];
    {
        extern int (*scoped)[];
        _Static_assert(sizeof *scoped == sizeof row, "visible block declaration");
    }
    return (*scoped)[1];
}
int (*scoped)[3] = &row;

static int read_first_block(void)
{
    extern int block_first[];
    return block_first[2];
}

static int read_second_block(void)
{
    extern int block_first[3];
    return block_first[0];
}

extern int block_first[];
int block_first[3] = { 11, 0, 13 };

int read(int (*)[]);
int read(int (*value)[3]) { return (*value)[2]; }
int read(int (*)[]);

int combine(int (*)(), int (*)[3]);
int combine(int (*callback)(int*), int (*value)[]) { return callback(&(*value)[1]); }

int (*get(void))[];
int (*get(void))[3] { return &row; }

static int load(int* value) { return *value; }

_Static_assert(sizeof *data == 3 * sizeof(int), "composite object type");
_Static_assert(sizeof *get() == 3 * sizeof(int), "composite result type");

int main(void)
{
    return !(first() == &row && read_scoped() == 7 && read_first_block() == 13 &&
        read_second_block() == 11 && read(&row) == 9 && combine(load, &row) == 7 && (*get())[0] == 4);
}
