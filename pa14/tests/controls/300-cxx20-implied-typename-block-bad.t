// A block-scope declaration is no type-only context: the dependent name needs typename; expect reject
template <class T> struct B { using value_type = T; };
template <class T> int f() {
  B<T>::value_type d = 0;
  return d;
}
int main() { return f<int>(); }
