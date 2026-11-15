template<class T> struct Trap { static_assert(sizeof(T) == 0); };
template<class T> requires (true || sizeof(Trap<T>) > 0) using Kept = T;
int main() { Kept<int> x = 3; return x - 3; }
