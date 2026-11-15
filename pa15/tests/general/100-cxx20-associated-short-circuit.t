template<class T> struct Trap { static_assert(sizeof(T) == 0); };
template<class T> requires (false && sizeof(Trap<T>) > 0) int select(T) { return 1; }
int select(...) { return 2; }
int main() { int x = 3; return select(x) - 2; }
