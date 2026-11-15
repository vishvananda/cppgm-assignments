template<class T> concept C = true;
template<C T> int f(T) { return 1; }
template<C U> int f(U) { return 2; }
int main() { return f(1); }
