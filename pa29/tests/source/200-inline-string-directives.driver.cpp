extern "C" const char* instruction_data();

int main()
{
    const char expected[] = { 'A', '7', 'B', 'C', 0, 'D', 0, 'E', 0 };
    const char* actual = instruction_data();
    for (unsigned i = 0; i != sizeof(expected); ++i)
        if (actual[i] != expected[i])
            return 1;
    return 0;
}
