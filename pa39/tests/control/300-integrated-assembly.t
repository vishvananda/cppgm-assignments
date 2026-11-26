extern "C" int from_assembly(int);
extern "C" int from_neon();

extern "C" int from_cpp(int n)
{
    return n + 2;
}

int main()
{
    if (from_neon() != 12)
        return 1;
    return from_assembly(0) + from_assembly(10);
}
