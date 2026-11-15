template<class T> requires (sizeof(T) > 1) int pick(T) { return 1; }
template<class T> requires (sizeof(T) > 1) && (sizeof(T) > 2) int pick(T) { return 2; }
int main() { return pick(1); }
