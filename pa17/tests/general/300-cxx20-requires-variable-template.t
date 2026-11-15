struct Present { using type = void; int value; };
struct Missing {};
template<class T> constexpr bool has_value = requires(T value) { value.value; };
template<class T> constexpr bool has_type = requires { typename T::type; };
template<class T> constexpr bool adjusted = requires(T value[3]) { *value; };
template<class T> constexpr bool unnamed = requires(T) { 1; };
static_assert(!unnamed<void> && unnamed<int>, "dependent void is not an empty list");
static_assert(has_value<Present> && !has_value<Missing> && !has_value<int>, "member");
static_assert(has_type<Present> && !has_type<Missing>, "type");
static_assert(adjusted<int>, "array parameter adjusted");
int main() { return !has_value<Present>; }
