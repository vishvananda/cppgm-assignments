struct Location { int *address; };

int main(void)
{
    int local = 42;
    struct Location value = { &local };
    return *value.address != 42;
}
