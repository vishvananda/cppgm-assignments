int main(void)
{
    for (int width = 2; width <= 4; ++width) {
        int current = width;
        typedef int Row[current++];
        typedef Row Matrix[2];
        Matrix values;
        Row copied;
        values[1][width - 1] = 7;
        copied[width - 1] = 11;
        if (current != width + 1 || sizeof(Row) != width * sizeof(int) ||
            sizeof(Matrix) != 2 * sizeof(Row) || sizeof copied != sizeof(Row) ||
            values[1][width - 1] + copied[width - 1] != 18)
            return 1;
    }
    return 0;
}
