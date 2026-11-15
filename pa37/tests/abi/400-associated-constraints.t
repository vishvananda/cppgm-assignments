template<class T> concept Big = sizeof(T) > 1;
template<class T> concept Huge = sizeof(T) > 2;
template<Big T> int pick(T) { return 1; }
template<Big T> requires Huge<T> int pick(T) { return 2; }
template<class T> struct Count { int count() { return 0; } };
template<class T> requires Big<T> struct Count<T> { int count() { return 1; } };
template<class T> requires Big<T> && Huge<T> struct Count<T> { int count() { return 2; } };
extern "C" int constraints(int value) {
  Count<int> a; Count<short> b;
  return value + pick(1) + pick(short(1)) + a.count() + b.count();
}
