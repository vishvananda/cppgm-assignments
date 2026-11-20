// expect exit 0
template<class T> struct Box {
  constexpr Box(T item) : value(item) {}
  T value;
};

template<template<class> class Family>
  requires (Family{17}.value == 17)
constexpr int read();

template<template<class> class Renamed>
  requires (Renamed{17}.value == 17)
constexpr int read() { return Renamed{21}.value; }

static_assert(read<Box>() == 21);
int main() {}
