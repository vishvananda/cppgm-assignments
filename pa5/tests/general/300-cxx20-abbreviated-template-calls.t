int first(auto), second(auto);
int unnamed_pack(auto...), varargs(auto, ...);
int first(auto x) { return x; }
template<class T> T mixed(T x, auto y) { return x+y; }
int main() { return first<int>(1)+mixed<int,long>(2,3); }
