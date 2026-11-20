// expect exit 0
// N3485 [temp.param], [temp.res], [temp.deduct.type]
template<template<class, int...> class Candidate, class T>
int inspect(const Candidate<T>&) { return 1; }
int inspect(...) { return 2; }

template<class T>
int choose(T input) { return inspect(input); }

namespace later {
template<class T, int N> struct Redeclared;
template<class T> struct Setting { static constexpr int value = 7; };
template<class T, int N = Setting<T>::value> struct Number {};
template<class T, int N = Setting<T>::value> struct Redeclared {};
}

int main()
{
    return choose(later::Number<int>{}) != 1 || choose(later::Number<int, 9>{}) != 2 ||
        choose(later::Redeclared<int>{}) != 1 || choose(later::Redeclared<int, 9>{}) != 2;
}
