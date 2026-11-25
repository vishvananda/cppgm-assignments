// expect exit 0

struct row {
    char tag;
    int values[4];
};

static int *slot = &((struct row *)0)->values[2];

int main(void)
{
    return (unsigned long)slot != __builtin_offsetof(struct row, values[2]);
}
