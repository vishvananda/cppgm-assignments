// expect exit 0
template<class T> constexpr auto value(T x) noexcept;
template<> constexpr auto value(int x) noexcept;
template<> constexpr auto value<int>(int x) noexcept { return x + 2; }

static_assert(value(40) == 42, "");
int main() { return value(40) != 42; }
