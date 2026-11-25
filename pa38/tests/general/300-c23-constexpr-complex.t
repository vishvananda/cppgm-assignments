constexpr _Complex double first = __builtin_complex(1.0f, 3.0f / 2.0f);
constexpr _Complex double copy = first;
constexpr _Complex float real_only = 16U;

int main(void)
{
    return __real__ copy != 1.0 || __imag__ copy != 1.5 ||
        __real__ real_only != 16.0f || __imag__ real_only != 0.0f;
}
