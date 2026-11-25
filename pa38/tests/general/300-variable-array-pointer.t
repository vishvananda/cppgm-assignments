static int pointers(int bound)
{
    int matrix[2][4] = {{0}, {7, 11, 13, 17}};
    int (*row)[bound++] = matrix;
    int (*holders[2])[--bound];
    static int (*saved)[bound++];
    holders[1] = row + 1;
    saved = matrix;
    return bound == 5 && sizeof *row == 4 * sizeof(int) &&
        sizeof *saved == sizeof *holders[1] && holders[1] - row == 1 &&
        (*holders[1])[2] == 13 && saved[1][3] == 17;
}

int main(void)
{
    return !pointers(4);
}
