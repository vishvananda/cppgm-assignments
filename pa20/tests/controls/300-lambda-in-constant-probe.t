// expect exit 0
int main()
{
    int count = 0;
    const int known = __builtin_constant_p([&] {
        ++count;
        return count;
    }());
    return known != 0 || count != 0;
}
