static int check(int length, int (*data)[length])
{
    typedef int Row[length];
    const Row *view = data;
    const int (*other)[length] = view;
    return sizeof *view != (unsigned)length * sizeof(int) ||
           view[1][length - 1] != other[0][0] + 4;
}

int main(void)
{
    int values[2][3] = {{3, 0, 0}, {0, 0, 7}};
    volatile int length = 3;
    return check(length, values);
}
