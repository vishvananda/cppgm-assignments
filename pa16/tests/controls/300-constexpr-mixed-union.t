// expect exit 0
struct Nonliteral { Nonliteral() {} int x; };
union Storage { int integer; Nonliteral other; constexpr Storage(int n) : integer(n) {} };
struct Wrapper { Storage storage; constexpr Wrapper(int n) : storage(n) {} };
constexpr Wrapper value(42);
static_assert(value.storage.integer == 42, "");

int main() { return 0; }
