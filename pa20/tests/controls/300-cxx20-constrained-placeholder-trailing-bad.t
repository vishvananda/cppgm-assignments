// A trailing return type holds the constrained placeholder; expect reject
template <class T> concept Integral = requires(T v) { v % v; };
auto bad() -> Integral auto { return 1.5; }
int main() { return bad(); }
