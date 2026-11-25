static int sizes(int rows, int columns)
{
    unsigned long bytes = sizeof(int[rows++][columns++]);
    sizeof(int[rows++]);
    int incidental = 2;
    unsigned long pointer = sizeof(int (*)[incidental++]);
    int alignment_bound = 2;
    unsigned long alignment = _Alignof(int[alignment_bound++]);
    return bytes == 12 * sizeof(int) && rows == 5 && columns == 5 &&
        pointer == sizeof(int (*)[2]) && (incidental == 2 || incidental == 3) &&
        alignment == _Alignof(int) && alignment_bound == 2;
}

int main(void)
{
    return !sizes(3, 4);
}
