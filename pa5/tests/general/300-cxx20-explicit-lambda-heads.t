void declarations() {
  auto mixed = []<class T, int N = 3>(T value, auto extra) { return value + extra + N; };
  auto nested = []<template<class> class C, class... T>(C<T>... value) { return sizeof...(value); };
  auto constrained = []<class T> requires (sizeof(T) > 1) (T x, auto y) -> T requires requires { x + y; } { return x+y; };
}
