int read_row(int (*row)[2])
{
    const int (*view)[3] = row;
    return (*view)[0];
}
