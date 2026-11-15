// A using declaration and explicit qualification name one concept; expect exit 0
namespace N { template<class T> concept C = sizeof(T) > 1; }
using N::C;
template<class T> requires C<T> int first(T);
template<class U> requires N::C<U> int first(U) { return 2; }
namespace N {
template<class T> requires C<T> int second(T);
template<class C> requires N::C<C> int second(C) { return 3; }
}
int main() { return first(1) + N::second(1) - 5; }
