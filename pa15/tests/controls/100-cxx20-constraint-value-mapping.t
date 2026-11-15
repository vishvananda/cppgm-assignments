// Arithmetic NTTP mappings stay symbolic during normalization; expect exit 0
template<int N> concept Positive = N > 0;
template<class T> concept Wide = sizeof(T) > 1;
template<class T, int N> requires Positive<N + 1> int pick(T) { return 1; }
template<class U, int M> requires Positive<M + 1> && Wide<U> int pick(U) { return 2; }
int main() { return pick<int, 1>(1) + pick<char, 0>('x') - 3; }
