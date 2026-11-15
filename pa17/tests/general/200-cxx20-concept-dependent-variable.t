template<class T> concept C = (sizeof(T)>1); template<class T> constexpr bool v=C<T>; static_assert(v<int> && !v<char>);
int main() { return !v<int> || v<char>; }
