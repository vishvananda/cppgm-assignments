// expect exit 0

struct word { unsigned long bits; };
struct byte { unsigned char bits; };

static struct word exchange_word(struct word* address, struct word value)
{
    asm volatile("xchgq %q0,%1" : "+r"(value), "+m"(*address));
    return value;
}

static struct byte exchange_byte(struct byte* address, struct byte value)
{
    asm volatile("xchgb %b0,%1" : "+q"(value), "+m"(*address));
    return value;
}

int main(void)
{
    struct word word = { 0x1122334455667788ul };
    struct byte byte = { 243 };
    struct word old_word = exchange_word(&word, (struct word){4});
    struct byte old_byte = exchange_byte(&byte, (struct byte){5});
    return word.bits != 4 || old_word.bits != 0x1122334455667788ul
        || byte.bits != 5 || old_byte.bits != 243;
}
