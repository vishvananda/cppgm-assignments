// expect exit 0
struct list { const int *data; unsigned count; };

#define LIST(array) { .data = array, .count = sizeof(array) / sizeof((array)[0]) }

static const struct list empty = (struct list)LIST(((const int[]){}));
static const struct list populated = (struct list)LIST(((const int[]){3, 5}));

int main(void)
{
    if (empty.count != 0 || empty.data == 0 || sizeof((int[]){}) != 0)
        return 1;
    return populated.count != 2 || populated.data[1] != 5;
}
