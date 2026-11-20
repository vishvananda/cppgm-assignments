// expect exit 0
enum class Code { accepted = 42 };
template<class> using Selection = Code;

template<int N> struct Choice {
    using enum Selection<int>;
    constexpr Choice(Code value) : value(value) {}
    Code value;
};

int main() {
    Choice<7> choice{Choice<7>::accepted};
    return static_cast<int>(choice.value) != 42;
}
