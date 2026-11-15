template<class T> concept Integral = requires(T x){ x % 1; };
constexpr int plain(auto x) {return x+1;}
constexpr int checked(Integral auto x) {return x+2;}
template<class T> constexpr T mixed(T x, auto y) {return x+y;}
constexpr int packed(Integral auto... x) {return (x+...);}
void declared(auto), other(auto);
void declared(auto) {}
void other(auto) {}
constexpr auto lambda = []<class T>(T x, Integral auto y) {return x+y;};
struct Value { int x; constexpr Value(Integral auto n) : x(n) {} };
static_assert(plain<int>(2)==3);
static_assert(checked(3)==5);
static_assert(mixed<int,long>(2,3)==5);
static_assert(packed(1,2,3)==6);
static_assert(lambda(2,3)==5);
static_assert(Value(7).x==7);
int main(){declared<int>(1);other(2);return plain(1)!=2;}
