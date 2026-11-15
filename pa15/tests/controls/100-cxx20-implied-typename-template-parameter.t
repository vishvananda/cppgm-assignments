// The type of a non-type template parameter is a type-only context; expect exit 0
template <class T> struct B { using value_type = T; };
template <class T, T::value_type N = 3> struct K {
  T::value_type get() { return N; }
  static T::value_type s;
};
template <class T, T::value_type N> T::value_type K<T, N>::s = N;
int main() { return K<B<int>>().get() - 3 + K<B<int>, 4>::s - 4; }
