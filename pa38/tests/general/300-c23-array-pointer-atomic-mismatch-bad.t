int read_row(int length, _Atomic int (*row)[length])
{
    const int (*view)[length] = row;
    return (*view)[0];
}
