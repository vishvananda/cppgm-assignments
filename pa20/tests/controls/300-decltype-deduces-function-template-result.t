// expect exit 0
template<int N, class... Args>
auto value(Args...) { return N; }

template<class T, class U> struct Same { static const bool value = false; };
template<class T> struct Same<T, T> { static const bool value = true; };

template<int N, class... Args>
using Signature = decltype(value<N, Args...>);

static_assert(Same<decltype(value<3, char>), int(char)>::value, "");
static_assert(Same<Signature<5, int, char>, int(int, char)>::value, "");

int main() { return 0; }
