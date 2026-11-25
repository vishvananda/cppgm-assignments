int main(void)
{
    int n = 4;
    typedef int Row[n++];
    if (n != 5)
        return 1;
    n = 1;

    for (int i = 0; i < 3; ++i) {
        Row rows[2] = {};
        if (sizeof rows != 8 * sizeof(int) || n != 1)
            return 2;
        for (int row = 0; row < 2; ++row)
            for (int column = 0; column < 4; ++column)
                if (rows[row][column] != 0)
                    return 3;
        rows[1][3] = 7;
    }
    return 0;
}
