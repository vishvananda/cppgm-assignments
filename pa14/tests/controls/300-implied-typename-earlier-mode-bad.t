// Before C++20 a dependent qualified name needs typename in an alias; expect reject
template <class T> struct B { using value_type = T; };
template <class T> struct A {
  using difference_type = B<T>::value_type;
  difference_type d;
};
int main() { A<int> a; a.d = 0; return a.d; }
