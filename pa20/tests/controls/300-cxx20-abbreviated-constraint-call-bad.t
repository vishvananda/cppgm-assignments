template<class T> concept Integral = requires(T x) { x % 1; };
void f(Integral auto) {}
int main() { f(1.0); }
