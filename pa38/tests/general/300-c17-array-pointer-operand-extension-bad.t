int last(int length, int (*row)[length])
{
    const int (*view)[length] = __extension__ row;
    return (*view)[length - 1];
}
