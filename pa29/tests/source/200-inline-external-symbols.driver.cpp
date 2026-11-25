extern "C" int asm_transform(int i)
{
    return 7 * i;
}

extern "C" {
    int asm_adjustment = 5;
    int external_sequence(int);
}

int main()
{
    return external_sequence(9) != 68;
}
