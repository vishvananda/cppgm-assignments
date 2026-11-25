static int first(void) { return 3; }
static int second(void) { return 5; }
static int (*const callbacks[])(void) = { [1 ... 4] = first, [3] = second };
static const unsigned char bytes[32] = { [0 ... 31] = 0, [3 ... 8] = 9, [5 ... 6] = 2 };
static unsigned calls[3];

static int visit(unsigned index, int value)
{
    ++calls[index];
    return value;
}

int main(void)
{
    int values[] = {
        [1] = 4, [2 ... 9000] = visit(0, 7), [3 ... 4] = visit(1, 9), 11,
        [100 ... 101] = visit(2, 17), [100] = 31, [101] = 32
    };
    volatile int grid[3][4] = { [1][2 ... 3] = { 8 }, 5 };
    _Static_assert(sizeof values / sizeof values[0] == 9001, "highest range endpoint completes the array");

    return !(values[0] == 0 && values[1] == 4 && values[2] == 7 && values[3] == 9 &&
        values[4] == 9 && values[5] == 11 && values[6] == 7 && values[100] == 31 &&
        values[101] == 32 && values[8999] == 7 && values[9000] == 7 &&
        calls[0] == 1 && calls[1] == 1 && calls[2] <= 1 &&
        grid[0][0] == 0 && grid[1][1] == 0 && grid[1][2] == 8 && grid[1][3] == 8 &&
        grid[2][0] == 5 && grid[2][1] == 0 &&
        callbacks[0] == 0 && callbacks[1]() == 3 && callbacks[2]() == 3 &&
        callbacks[3]() == 5 && callbacks[4]() == 3 && bytes[0] == 0 && bytes[3] == 9 &&
        bytes[5] == 2 && bytes[8] == 9 && bytes[9] == 0 && bytes[31] == 0);
}
