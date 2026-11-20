// expect exit 0
// N4659 [temp.deduct.type]: the type of a deduced non-type argument
// supplies template arguments needed for the partial specialization.
template<const auto& Value>
struct Extent { static constexpr int size = 0; };

template<int N, const char (&Value)[N]>
struct Extent<Value> { static constexpr int size = N; };

inline constexpr char word[] = "four";
inline constexpr int numbers[] = {1, 2, 3};

static_assert(Extent<word>::size == 5);
static_assert(Extent<numbers>::size == 0);

template<long Value> struct LongArgument {};
template<class> struct ArgumentType;
template<class T, T Value>
struct ArgumentType<LongArgument<Value>> { using type = T; };

template<class, class> struct Same { static constexpr bool value = false; };
template<class T> struct Same<T, T> { static constexpr bool value = true; };
static_assert(Same<ArgumentType<LongArgument<42>>::type, long>::value);

int main() {}
