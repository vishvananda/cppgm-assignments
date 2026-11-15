// Friends defined in a class template differ by trailing requires-clauses on its parameter; expect exit 0
template <class T> concept Big = sizeof(T) > 1;
template <class T> struct W {
  T v;
  friend constexpr int weigh(const W&) requires Big<T> { return 2; }
  friend constexpr int weigh(const W&) requires(!Big<T>) { return 1; }
};
int main() {
  W<int> big = { 1 };
  W<char> small = { 1 };
  return weigh(big) + weigh(small) - 3;
}
