int main(void)
{
    int typeof = 3;
    int matrix[2][3] = {{0}, {2, 3, 5}};
    int value = ((int (*)[typeof++])matrix)[1][2];
    if (typeof != 4 || value != 5)
        return 1;

    typeof = 3;
    (void)(int (*)[typeof++])matrix;
    if (typeof != 4)
        return 2;

    typeof = 3;
    value = ((int (*)[typeof++]){matrix})[1][1];
    return !(typeof == 4 && value == 3);
}
