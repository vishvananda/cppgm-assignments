template<class T> requires requires(T x) { x + 1; } int add(T x) { return x + 1; }
template<class U> requires requires(U y) { y + 1; } int add(U);
int main() { return add(2) - 3; }
