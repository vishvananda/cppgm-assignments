// expect exit 0
template<class T> struct Box {
  T value;
  Box(T x): value(x) {}
};

template<template<class> class View, class T>
auto make(T value) -> decltype(View(value)) {
  View result{value};
  return result;
}

int check(Box<int> i, Box<char> c) {
  return i.value == 3 && c.value == 'x' ? 0 : 1;
}

int main() {
  return check(make<Box>(3), make<Box>('x'));
}
