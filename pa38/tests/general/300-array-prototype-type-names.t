static int last(int (*row)[_Alignof(int[*])]);
static int first(int values[sizeof(int[*])]);
static int pointer_last(int (*row)[sizeof(int (*)[*])]);

static int last(int (*row)[_Alignof(int)])
{
    return (*row)[_Alignof(int) - 1];
}

static int first(int *values)
{
    return values[0];
}

static int pointer_last(int (*row)[sizeof(int *)])
{
    return (*row)[sizeof(int *) - 1];
}

static int invoke(int (*pick)(int (*)[_Alignof(int[*])]), int (*row)[_Alignof(int)])
{
    return pick(row);
}

int main(void)
{
    int aligned[_Alignof(int)] = {0};
    int width[sizeof(int *)] = {0};
    aligned[_Alignof(int) - 1] = 4;
    width[sizeof(int *) - 1] = 9;
    return invoke(last, &aligned) != 4 || first(aligned) != aligned[0] ||
        pointer_last(&width) != 9;
}
