#include <cstring>

extern "C" void asm_copy_fill(char*, const char*);
extern "C" void asm_copy_qwords(char*, const char*);

int main()
{
    char result[17] = {};
    asm_copy_fill(result, "abcd");
    if (std::strcmp(result, "abcd!!!") != 0)
        return 1;
    const char source[] = "abcdefghijklmnop";
    asm_copy_qwords(result, source);
    return std::memcmp(result, source, sizeof result) != 0;
}
