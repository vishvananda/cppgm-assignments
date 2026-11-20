// N3485 5.16p2, 14.8.2p8: a discarded-value cast still checks its operand.
// An invalid conditional discards the partial specialization. expect exit 0
template<class T> T value() noexcept;

template<class T, class U, class = void> struct Common {
  static constexpr bool valid = false;
};

template<class T, class U>
struct Common<T, U, decltype((void)(true ? value<T>() : value<U>()))> {
  static constexpr bool valid = true;
};

static_assert(Common<int, int>::valid, "two value operands are valid");
static_assert(Common<void, void>::valid, "two void operands are valid");
static_assert(!Common<int, void>::valid, "one void operand discards the specialization");
int main() { return 0; }
