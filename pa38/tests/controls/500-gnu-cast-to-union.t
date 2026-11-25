// expect exit 0

union value {
    int first;
    unsigned long second;
};

static union value saved = (union value)61UL;

static union value make_value(unsigned long input)
{
    union value selected = (union value)input;
    return (union value)selected;
}

int main(void)
{
    union value result = make_value(73);
    return saved.second != 61 || result.second != 73 || ((union value)42).first != 42;
}
