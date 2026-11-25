extern "C" int call_file_asm(int value);

int main()
{
    return call_file_asm(16) != 21;
}
