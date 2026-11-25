extern "C" long inspect_immediates(unsigned*);
extern "C" int* indexed_address(unsigned);
extern "C" int load_address32(unsigned);
extern "C" {
    int external_words[] = {11, 22, 33, 44};
}

asm(".globl short_value,bit_index,mask_value,signed_value,word_value\n"
    ".set short_value,0x4321\n"
    ".set bit_index,16\n"
    ".set mask_value,0x20000\n"
    ".set signed_value,-29\n"
    ".set word_value,0x89abcdef");

int main()
{
    unsigned word = 0;
    return inspect_immediates(&word) != 0x34321 - 29 || word != 0x89abcdefu
        || indexed_address(1) != external_words + 2 || load_address32(12) != 44;
}
