// N3485 5.2.9p4, 14.8.2p8: a cast to an incomplete class type fails
// substitution in a trailing return type. expect exit 0
struct Incomplete;

template<class T> auto cast_result(int) -> decltype(static_cast<T>(0), char());
template<class T> long cast_result(...);

static_assert(sizeof(cast_result<int>(0)) == sizeof(char), "valid cast keeps the overload");
static_assert(sizeof(cast_result<Incomplete>(0)) == sizeof(long), "incomplete target discards the overload");
int main() { return 0; }
