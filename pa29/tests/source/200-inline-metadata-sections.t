extern "C" int external_data;

extern "C" const char* emit_metadata(int* value)
{
    const char* address;
    asm volatile(
        "901: addl $3, %1\n"
        "leaq 901b(%%rip), %0\n"
        ".pushsection compiler_metadata,\"a\"\n"
        ".balign 4\n"
        ".globl compiler_metadata_record\n"
        ".type compiler_metadata_record,@object\n"
        "compiler_metadata_record:\n"
        "902: .long 901b - .\n"
        ".long %c2 - .\n"
        ".org 902b + 12, 0x5a\n"
        ".size compiler_metadata_record, . - compiler_metadata_record\n"
        ".popsection\n"
        : "=r"(address), "+r"(*value)
        : "i"(&external_data)
        : "cc");
    return address;
}
