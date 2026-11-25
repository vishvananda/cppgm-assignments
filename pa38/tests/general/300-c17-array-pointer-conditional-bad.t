int read_row(int select, int length, const int (*row)[length], volatile int (*other)[3])
{
    return (*(select ? row : other))[0];
}
