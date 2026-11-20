// expect exit 0
struct First
{
    char value;
    constexpr First(const char* text) : value(*text) {}
};
template<First Text> constexpr char operator""_first() { return Text.value; }

template<unsigned long N> struct TextArray
{
    char value[N];
    constexpr TextArray(const char (&text)[N]) : value{}
    {
        for (unsigned long i = 0; i < N; ++i)
            value[i] = text[i];
    }
};
template<TextArray Text> constexpr char operator""_last()
{
    return Text.value[sizeof(Text.value) - 2];
}
unsigned operator""_last(const char*, unsigned long) { return 0; }

static_assert("first"_first == 'f');
int main() { return "ab" "cd"_last != 'd'; }
