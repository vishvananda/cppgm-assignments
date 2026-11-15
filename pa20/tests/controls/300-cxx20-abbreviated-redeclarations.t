int same(auto);
int same(auto x) {return x+1;}
template<class T> int equivalent(T);
int equivalent(auto x) {return x+2;}
template<class T> int mixed(T, auto);
template<class T> int mixed(T x, auto y) {return x+y;}
void first(auto), second(auto);
void first(auto) {}
void second(auto) {}
struct C { int v; C(auto); int f(auto); };
C::C(auto x): v(x) {}
int C::f(auto x){return v+x;}
int main(){first<int>(1);second(2);C c(3);return same(1)!=2 || equivalent(1)!=3 || mixed<int,long>(1,2)!=3 || c.f<int>(2)!=5;}
