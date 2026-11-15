template<class T> struct Box { T value; };
constexpr auto identity = []<class T>(T value) { return value; };
constexpr auto mixed = []<class T, int N = 3>(T value, auto extra) { return value + extra + N; };
constexpr auto count = []<template<class> class C, class... T>(C<T>... values) { return sizeof...(values); };
static_assert(identity(4) == 4);
static_assert(identity.operator()<long>(7) == 7);
static_assert(mixed.operator()<int, 2>(3, 4L) == 9);
static_assert(count(Box<int>{1}, Box<long>{2}) == 2);
static_assert(sizeof(decltype([]<class T>(T) {})) == 1);
template<class T> concept CanCall = requires(T value) { []<class U>(U x) { return x + 1; }(value); };
static_assert(CanCall<int>);
int main() {
  int initial = 2;
  auto update = [initial]<class T>(T value, auto scale) mutable { return initial += value * scale; };
  if (update(3, 4) != 14 || update(2, 2) != 18) return 1;
  return mixed(1, 2) != 6;
}
