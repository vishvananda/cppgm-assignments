#include <cstdint>

extern "C" int forward_layout();
extern "C" unsigned char before_space[], after_space[], after_alignment[];
extern "C" unsigned measured_space, measured_function;
extern "C" unsigned char forward_end[];
extern "C" unsigned char* saved_position;

int main()
{
    if (measured_function != reinterpret_cast<std::uintptr_t>(forward_end) -
            reinterpret_cast<std::uintptr_t>(&forward_layout))
        return 4;
    if (forward_layout() != 73 || measured_space != 6 || after_space != before_space + 6 || before_space[0] != 0xcc)
        return 1;
    for (int i = 1; i < 6; ++i)
        if (before_space[i] != 0x90)
            return 2;
    if (reinterpret_cast<std::uintptr_t>(after_alignment) % 16 || after_alignment[0] != 0x12
        || saved_position != after_alignment + 3 || *saved_position != 0x34 || saved_position[1] != 0x56)
        return 3;
}
