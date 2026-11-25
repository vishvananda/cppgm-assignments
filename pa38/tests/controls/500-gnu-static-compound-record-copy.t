// expect exit 0

struct point {
    unsigned flags : 3;
    const char *name;
    int coords[2];
};

union holder {
    struct point position;
    unsigned char bytes[sizeof(struct point)];
};

static const char label[] = "test";

static const union holder *find(void)
{
    static const union holder value = (union holder) {
        .position = { .flags = 6, .name = label, .coords = { [1] = 17 } },
    };
    return &value;
}

int main(void)
{
    const struct point *position = &find()->position;
    if (position->flags != 6 || position->name != label || position->coords[0] != 0 || position->coords[1] != 17)
        return 1;
    return position != &find()->position;
}
