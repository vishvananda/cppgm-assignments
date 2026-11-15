// C++20 type-only contexts name a dependent type without typename; expect exit 0
template <class T> struct B {
  using value_type = T;
  static T make();
  struct In { T v; };
  In in();
};
template <class T> B<T>::value_type B<T>::make() { return T(); }
template <class T> B<T>::In B<T>::in() { return In{T()}; }
template <class T> struct K {
  using base = B<T>;
  using alias = base::value_type;
  T::value_type get() { return 3; }
  static T::value_type s;
};
template <class T> T::value_type K<T>::s = 3;
template <class T> T::value_type g(T) { return 0; }
template <class T> struct L {
  void h(T::value_type v, int = 0);
  int r;
};
template <class T> void L<T>::h(T::value_type v, int) {
  r = static_cast<T::value_type>(v) + sizeof(new T::value_type());
}
int main() {
  L<B<int>> l;
  l.h(4);
  return B<int>::make() + B<char>().in().v + K<B<int>>().get() - 3 + K<B<int>>::s - 3 + g(B<int>()) + l.r - 4 -
    sizeof(void*);
}
