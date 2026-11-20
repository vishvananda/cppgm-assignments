// expect reject
template<class T> auto value(T x) { return x; }
template<> int value<int>(int x) { return x + 2; }
