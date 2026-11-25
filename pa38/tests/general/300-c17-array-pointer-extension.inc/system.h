#pragma GCC system_header

static int system_last(int length, int (*row)[length])
{
    const int (*view)[length] = row;
    return (*view)[length - 1];
}
