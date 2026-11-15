// Separate constrained packs introduce distinct C++20 atoms; expect reject
template<class T> concept C = sizeof(T) > 0;
template<C... T> int pick(T...) { return 1; }
template<C... U> requires (sizeof...(U) > 0) int pick(U...) { return 2; }
int main() { return pick(1, 2); }
