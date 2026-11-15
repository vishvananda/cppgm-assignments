template<class T> concept Big = sizeof(T) > 1;
template<Big T> using Value = T;
template<class T> concept HasValue = requires { typename Value<T>; };
static_assert(HasValue<int> && !HasValue<char>);
template<Big U> using Value = U;
int main() { Value<int> x = 3; return x - 3; }
