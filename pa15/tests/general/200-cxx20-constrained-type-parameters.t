template<class T> concept Big = sizeof(T) > 1;
template<class T> concept Huge = sizeof(T) > 2;
template<Big T> struct Box { T value; };
template<class T> concept HasBox = requires { typename Box<T>; };
static_assert(HasBox<int> && !HasBox<char>);
template<Big T> int pick(T) { return 1; }
template<Big T> requires Huge<T> int pick(T) { return 2; }
template<Big U> int pick(U);
template<Big... T> struct Pack {};
template<class... T> concept HasPack = requires { typename Pack<T...>; };
static_assert(HasPack<> && HasPack<int, short> && !HasPack<int, char>);
int main() { Box<int> x = {1}; return pick(x.value) + pick(short(1)) - 3; }
