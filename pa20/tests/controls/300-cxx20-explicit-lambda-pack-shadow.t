template<int N> struct Tag {};
template<class... U> int shadow(U... value) {
  auto f=[]<class... value>(value... args) { return sizeof...(args); };
  return f(1,2)!=2;
}
template<class... U> int nonpack(U... value) {
  return ([]<class value>(value item) { return sizeof(value)+item; }(value)+...);
}
constexpr auto mixed_pack=[]<class... T>(T... a,auto b) { return (a+...)+b; };
static_assert(mixed_pack.operator()<int,int>(1,2,3)==6);
template<int... N> constexpr int defaults() {
  return ([]<int M=N>(Tag<M> value={}) { return M; }()+...);
}
static_assert(defaults<1,2,3>()==6);
template<class... T> int point_of_declaration(T... value) {
  return ([]<int M=sizeof(value), class value=int>() { return M+sizeof(value); }()+...);
}
template<class... T> int non_type_name(T... value) {
  return (([]<int value=3>() { return value; }()+sizeof(value))+...);
}
int main() { return non_type_name(1,2)!=6+2*sizeof(int) || point_of_declaration(1,2)!=4*sizeof(int) || shadow(1,2) || nonpack(1,2)!=(2*sizeof(int)+3); }
