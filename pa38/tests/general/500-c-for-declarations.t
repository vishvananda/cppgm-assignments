struct Limit { int value; };

int main(void)
{
    int index = 17;
    int result = 0;
    struct Limit limit = { 3 };
    for (auto int index = 0; index < limit.value; ++index)
        result += index;
    for (register int index = 1; index <= limit.value; ++index)
        result += index;
    for (const struct Limit *cursor = &limit; cursor; cursor = 0)
        result += cursor->value;
    for (struct { int index; } item = { 0 }; item.index != limit.value; ++item.index)
        result += item.index;
    for (int (*callback)(struct PrototypeTag *) = 0; callback; )
        return 2;
    return result != 15 || index != 17;
}
