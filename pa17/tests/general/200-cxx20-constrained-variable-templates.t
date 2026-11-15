template<class T> concept Big = sizeof(T) > 1;
template<class T> concept Huge = sizeof(T) > 2;
template<Big T> constexpr int constrained = 3;
template<class T> concept HasValue = requires { constrained<T>; };
static_assert(HasValue<int> && !HasValue<char>);
template<class T> constexpr int kind = 0;
template<class T> requires Big<T> constexpr int kind<T> = 1;
template<class T> requires Big<T> && Huge<T> constexpr int kind<T> = 2;
static_assert(kind<char> == 0 && kind<short> == 1 && kind<int> == 2);
int main() { return constrained<int> + kind<int> - 5; }
