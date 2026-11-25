extern "C" int branch_with_metadata(int value)
{
    asm goto(
        "testl %0, %0\n"
        "jne %l[chosen]\n"
        "798: nop\n"
        ".pushsection branch_metadata,\"a\"\n"
        ".globl branch_metadata_record\n"
        "branch_metadata_record:\n"
        ".long 798b - ., %l[chosen] - .\n"
        ".popsection\n"
        :
        : "r"(value)
        : "cc"
        : chosen);
    return 13;

chosen:
    return 72;
}
