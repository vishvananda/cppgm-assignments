// expect exit 0
using Handler = int (*)(int) noexcept;
constexpr Handler handler = [](int value) noexcept { return value + 1; };
static_assert(handler(4) == 5, "");
int main() { return handler(6) == 7 ? 0 : 1; }
