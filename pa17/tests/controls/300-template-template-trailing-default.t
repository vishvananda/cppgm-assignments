template<class T, unsigned N = sizeof(T)> struct Buffer {
  static constexpr int size = N;
};
template<template<class> class T> struct CharBuffer {
  static constexpr int size = T<char>::size;
};
int main() { return CharBuffer<Buffer>::size == 1 ? 0 : 1; }
