static int matrices(int rows, int columns)
{
    int outer[rows][3];
    int inner[2][columns];
    int both[rows++][columns++];
    outer[2][2] = 17;
    inner[1][3] = 19;
    both[2][3] = 23;
    return rows == 4 && columns == 5 &&
        sizeof outer == 9 * sizeof(int) && sizeof inner == 8 * sizeof(int) &&
        sizeof both == 12 * sizeof(int) && sizeof both[0] == 4 * sizeof(int) &&
        outer[2][2] + inner[1][3] + both[2][3] == 59;
}

int main(void)
{
    return !matrices(3, 4);
}
