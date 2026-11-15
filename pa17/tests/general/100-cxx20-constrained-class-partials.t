template<class T> concept Big = sizeof(T) > 1;
template<class T> concept Huge = sizeof(T) > 2;
template<class T> struct Pick { int value() { return 0; } };
template<class T> requires Big<T> struct Pick<T> { int value() { return 1; } };
template<class T> requires Big<T> && Huge<T> struct Pick<T> { int value() { return 2; } };
template<class U> requires Big<U> struct Pick<U>;
int main() { Pick<char> a; Pick<short> b; Pick<int> c; return a.value() + b.value() + c.value() - 3; }
