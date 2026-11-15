template<class T> constexpr bool test(){return sizeof(T) == sizeof(int);} template<class T> concept C=test<T>();static_assert(C<int> && !C<char>);
int main() { return !C<int> || C<char>; }
