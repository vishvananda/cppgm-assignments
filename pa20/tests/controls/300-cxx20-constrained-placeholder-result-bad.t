// The deduced return type does not satisfy the type-constraint; expect reject
template <class T> concept Integral = requires(T v) { v % v; };
Integral auto bad() { return 1.5; }
int main() { return bad(); }
