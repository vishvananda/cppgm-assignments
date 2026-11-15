// The friend redeclaration states other constraints than the class template; expect reject
template <class T> concept Big = sizeof(T) > 1;
template <class T> concept Small = sizeof(T) == 1;
template <Big I> class common {
  template <Small OI> friend class common;
};
int main() {
  common<int> a;
  (void) a;
  return 0;
}
