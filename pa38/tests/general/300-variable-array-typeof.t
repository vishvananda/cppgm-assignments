static int indexes, widths;

static inline int next_index(void) { return indexes++; }
static inline int width(int n) { ++widths; return n; }

static int parameter_type(int *counter, int n, __typeof__(int[n + ++*counter]) row)
{
    return row[1] == 3;
}

static inline int unused(void)
{
    extern int unresolved(void);
    return unresolved();
}

static int shared_type_names(void)
{
    int matrix[2][3] = {{0}, {0}};
    int effects = 0;
    for (int iteration = 1; iteration <= 2; ++iteration) {
        int n = 3;
        __typeof__(*(int (*)[n++])(++effects, matrix)) first, second;
        if (effects != 2 * iteration || n != 4 ||
            sizeof first != sizeof matrix[0] || sizeof second != sizeof first)
            return 0;
    }
    return 1;
}

static int first_declarator_captures_bounds(void)
{
    int n = 3, index = 0, width = 3;
    int matrix[1][width];
    __typeof__((index++ ? sizeof(int[n++]) : 0, &matrix[0])) first, second;
    return n == 3 && index == 2;
}

int main(void)
{
    int n = 3;
    typeof(int[width(n++)]) first, second;
    __typeof__(int[2][n]) values;
    typedef __typeof__(values[next_index()]) Row, Alias;
    typedef typeof(typeof(int[width(n++)])[2]) Matrix;
    __typeof__(((void)next_index(), &values[0])) pointer = values;
    Row row;
    typeof((unused(), 1)) ordinary = 1;
    int nested = 0, outer = 2;
    __typeof__(__typeof__(values[nested++])[outer++]) planes, copies;
    int counter = 0, argument[3] = {2, 3, 5};
    if (!parameter_type(&counter, 2, argument) || counter != 1)
        return 1;
    row[3] = 7;
    return !(n == 5 && indexes == 3 && widths == 2 &&
        sizeof first == 3 * sizeof(int) && sizeof second == sizeof first &&
        sizeof(Row) == 4 * sizeof(int) && sizeof(Alias) == sizeof(Row) &&
        sizeof(Matrix) == 8 * sizeof(int) && sizeof *pointer == sizeof row &&
        nested == 2 && outer == 3 && sizeof planes == 2 * sizeof(Row) &&
        sizeof copies == sizeof planes && row[3] == 7 && ordinary == 1 &&
        shared_type_names() && first_declarator_captures_bounds());
}
