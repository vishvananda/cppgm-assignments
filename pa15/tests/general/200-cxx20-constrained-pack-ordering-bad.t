template<class T> concept C = true;
template<C... T> int f(T...) { return 1; }
template<C... T> requires (sizeof...(T) > 0) int f(T...) { return 2; }
int main() { return f(1); }
