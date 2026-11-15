// A friend redeclaration of the enclosing class template repeats its constraints one level deeper; expect exit 0
template <class T> concept Big = sizeof(T) > 1;
template <class T, class U> concept Same = sizeof(T) == sizeof(U);
template <Big I, Same<I> S>
  requires(!Same<I, char> && Big<S>)
class common {
  template <Big OI, Same<OI> OS>
    requires(!Same<OI, char> && Big<OS>)
  friend class common;
  int v = 1;

public:
  template <class I2, class S2> int get(const common<I2, S2>& o) { return o.v; }
};
template <class I>
  requires Big<I>
class single {
  template <class OI>
    requires Big<OI>
  friend class single;
  int v = 2;

public:
  template <class I2> int get(const single<I2>& o) { return o.v; }
};
int main() {
  common<int, int> a;
  common<long long, long long> b;
  single<int> c;
  single<short> d;
  return a.get(b) + c.get(d) - 3;
}
