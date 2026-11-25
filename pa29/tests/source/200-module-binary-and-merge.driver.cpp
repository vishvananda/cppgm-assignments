extern "C" const char module_slice[];

int main()
{
    const char expected[] = "slice";
    for (unsigned i = 0; i != sizeof(expected); ++i)
        if (module_slice[i] != expected[i])
            return 1;
    return 0;
}
