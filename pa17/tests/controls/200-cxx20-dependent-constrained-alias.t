// expect exit 0
template<class T> concept Big = sizeof(T) > 1;
template<Big T> using Checked = T;
template<class T> using Forward = Checked<T>;
template<class T> concept HasForward = requires { typename Forward<T>; };
static_assert(HasForward<int>);
static_assert(!HasForward<char>);
int main() { Forward<int> value = 3; return value - 3; }
