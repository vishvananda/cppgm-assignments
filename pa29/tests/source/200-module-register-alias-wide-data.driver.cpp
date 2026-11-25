#include <cstdint>

extern "C" std::uint32_t wide_words[];
extern "C" std::uint32_t read_word(const std::uint32_t*);

int main()
{
    return wide_words[0] != 0x89abcdef || wide_words[1] != 0x01234567 ||
        read_word(wide_words) != 0x76543210 || wide_words[3] != 0xfedcba98 ||
        wide_words[4] != 0xffffffff || wide_words[7] != 0xffffffff;
}
