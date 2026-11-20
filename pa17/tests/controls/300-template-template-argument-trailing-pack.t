// expect exit 0
template<template<class> class A, class T>
using Apply = A<T>;

template<template<class, class> class A>
using Pair = A<int, char>;

template<template<class...> class A>
struct Quote
{
    template<class T> using Invoke = Apply<A, T>;
};

template<class... T> struct Count { static const int value = sizeof...(T); };

int main()
{
    return Quote<Count>::Invoke<int>::value != 1 || Pair<Count>::value != 2;
}
