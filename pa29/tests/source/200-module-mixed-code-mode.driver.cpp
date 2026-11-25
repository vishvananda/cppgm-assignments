extern "C" unsigned char legacy_code[], legacy_code_end[];
extern "C" int after_legacy_mode();

int main()
{
    const unsigned char expected[] = {
        0x8b, 0x44, 0x24, 0x04, 0x50, 0x58, 0x0f, 0x20, 0xd8, 0xff, 0xd0, 0xcb,
        0xea, 0x78, 0x56, 0x34, 0x12, 0x10, 0x00, 0xff, 0x6c, 0x24, 0x02, 0x48, 0xcb
    };
    if (legacy_code_end != legacy_code + sizeof(expected) || after_legacy_mode() != 17)
        return 1;
    for (unsigned i = 0; i < sizeof(expected); ++i)
        if (legacy_code[i] != expected[i])
            return 2;
}
