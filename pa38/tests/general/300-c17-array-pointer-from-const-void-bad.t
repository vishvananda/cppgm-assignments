int read_row(int length, const void *address)
{
    const int (*row)[length] = address;
    return (*row)[0];
}
