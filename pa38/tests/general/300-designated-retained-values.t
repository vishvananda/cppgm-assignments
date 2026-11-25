struct Point { int x, y; };
struct Object { struct Point point; char text[4]; };

static struct Object global = { .text = "abc", .text[1] = 'X', .point.y = 7 };

static struct Point make_point(int* calls)
{
    ++*calls;
    return (struct Point){ 2, 3 };
}

int main(void)
{
    int calls = 0;
    struct Object copy = { .point = make_point(&calls), .point.y = 5,
        .text = "abc", .text[1] = 'Y' };
    struct Object reset = { .point.x = 7, .point = { .y = 9 } };
    struct Anonymous { union { struct { int x, y; }; long other; }; int tail; };
    struct Anonymous named = { .x = 21, .y = 24, .tail = 27 };
    return !(calls == 1 && copy.point.x == 2 && copy.point.y == 5 &&
        copy.text[0] == 'a' && copy.text[1] == 'Y' && copy.text[2] == 'c' && copy.text[3] == 0 &&
        global.text[0] == 'a' && global.text[1] == 'X' && global.text[2] == 'c' &&
        global.point.x == 0 && global.point.y == 7 && reset.point.x == 0 && reset.point.y == 9 &&
        named.x == 21 && named.y == 24 && named.tail == 27);
}
