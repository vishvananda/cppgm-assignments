struct Entry { int tag; float weight; };
struct Box { struct Entry entry; int count; };

enum { number = (constexpr int){ (constexpr int){ 5 } } };
enum { tag = (constexpr struct Box){ .entry.tag = 7 }.entry.tag };
constexpr struct Box saved = {
    (constexpr struct Entry){ .weight = 1.5, .tag = 9 },
    number
};

static const int *global = &(constexpr int){ tag };
static_assert(number == 5 && tag == 7);
static_assert(saved.entry.tag == 9 && saved.count == number);
static_assert(_Generic(&(constexpr int){}, const int *: 1, default: 0));

int main(void)
{
    const struct Entry *local = &(constexpr struct Entry){ 11, 0.75f };
    const float *persistent = &(static constexpr float){ 2.5 };
    if (local->tag != 11 || local->weight != 0.75f || *persistent != 2.5f)
        return 1;
    if (*global != 7 || (register constexpr int){ number } != 5)
        return 2;
    if ((constexpr unsigned char[]){ u8"ab" }[1] != 'b')
        return 3;
    const _Complex double *complex_value =
        &(constexpr _Complex double){ __builtin_complex(1.0f, 1.5f) };
    if (__real__ *complex_value != 1.0 || __imag__ *complex_value != 1.5)
        return 4;
    return 0;
}
