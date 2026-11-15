// Function templates that differ only in their return type stay distinct in C++20 mode; expect exit 0
template<bool B, class T = void> struct enable_if {};
template<class T> struct enable_if<true, T> { typedef T type; };
template<class T> typename enable_if<sizeof(T) == 1, int>::type pick(T) { return 1; }
template<class T> typename enable_if<sizeof(T) != 1, int>::type pick(T) { return 2; }
int main() { return pick('a') + pick(1) - 3; }
