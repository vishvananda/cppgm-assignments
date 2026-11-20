// expect exit 0
// N4140 [temp.arg.template] and [temp.deduct]

template<template<class> class C> struct Tag {};
template<template<class> class C> constexpr Tag<C> token{};

struct HasTemplate { template<class> struct Member {}; };
struct NoTemplate {};
struct DifferentParameter { template<int> struct Member {}; };

template<class T> auto accepts(int) -> decltype((void)token<T::template Member>, char(0));
template<class T> long accepts(...);

static_assert(sizeof(accepts<HasTemplate>(0)) == sizeof(char), "matching template");
static_assert(sizeof(accepts<NoTemplate>(0)) == sizeof(long), "missing member template");
static_assert(sizeof(accepts<DifferentParameter>(0)) == sizeof(long), "wrong parameter kind");
int main() {}
