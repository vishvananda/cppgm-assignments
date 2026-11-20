// expect reject
template<template<class> class A>
struct Accept { A<int> value; };
template<class... T> struct Variadic {};
Accept<Variadic> bad;
