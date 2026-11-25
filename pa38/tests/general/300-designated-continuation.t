struct Point { int x, y; };
struct Object {
    union { int scalar; struct Point point; } value;
    struct Point pair[2];
    int tail;
};

static struct Object global = { .value.point.x = 2, 3, 5, 7, 11, 13, 17 };

int main(void)
{
    int grid[3][3] = { [1][1] = 4, 5, 6 };
    struct Object local = { .pair[0].y = 20, 21, 22, 23 };
    struct Outer { int first; struct Point point; } nested = { 8, { .y = 9 } };
    return !(global.value.point.x == 2 && global.value.point.y == 3 &&
        global.pair[0].x == 5 && global.pair[0].y == 7 &&
        global.pair[1].x == 11 && global.pair[1].y == 13 && global.tail == 17 &&
        grid[1][0] == 0 && grid[1][1] == 4 && grid[1][2] == 5 && grid[2][0] == 6 &&
        local.pair[0].x == 0 && local.pair[0].y == 20 &&
        local.pair[1].x == 21 && local.pair[1].y == 22 && local.tail == 23 &&
        nested.first == 8 && nested.point.x == 0 && nested.point.y == 9);
}
