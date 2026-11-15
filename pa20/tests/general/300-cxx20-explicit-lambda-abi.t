inline auto explicit_identity() { return []<class T>(T value) { return value+1; }; }
inline auto explicit_value() { return []<int N>() { return N; }; }
inline auto explicit_pack() { return []<class... T>(T... value) { return sizeof...(value); }; }
template<class T> struct Box { T value; };
inline auto explicit_template() { return []<template<class> class C, class T>(C<T> value) { return value.value; }; }
inline auto mixed_head() { return []<class T>(T value, auto extra) { return value+extra; }; }
template<class T> auto inferred(T value) { return value; }
template<class T> auto& inferred_ref(T& value) { return value; }
template<class T> decltype(auto) inferred_decltype(T& value) { return (value); }
inline int numbered() {
  auto a=[]<class T>(T x) { return x; };
  auto b=[]<int N>(int x) { return x+N; };
  auto c=[]<class T>(T x) { return x+1; };
  auto d=[]<int N>(int x) { return x+N+1; };
  return a(1)+b.operator()<2>(1)+c(1)+d.operator()<2>(1);
}
int main() {
  int value=2;
  inferred_ref(value)=3;
  inferred_decltype(value)=4;
  return explicit_identity()(1)!=2 || explicit_value().operator()<3>()!=3 ||
    explicit_pack()(1,2)!=2 || explicit_template()(Box<int>{7})!=7 ||
    mixed_head()(1,2L)!=3 || inferred(value)!=4 || numbered()!=10;
}
