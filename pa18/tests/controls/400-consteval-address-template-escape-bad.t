// An immediate context does not make an immediate function address a
// permitted persistent template argument.
// expect reject
consteval int answer() { return 42; }
template<int (*Function)()> struct Holder {};
consteval int bad() { Holder<answer> escaped; return 1; }
int main() { return bad(); }
