// A constrained hidden friend and namespace declaration are one function; expect exit 0
namespace N {
template<class T> concept C = sizeof(T) > 0;
struct A {
  template<class T> requires C<T> friend int pick(A, T) { return 2; }
};
template<class U> requires N::C<U> int pick(A, U);
}
int main() { return pick(N::A{}, 1) - 2; }
