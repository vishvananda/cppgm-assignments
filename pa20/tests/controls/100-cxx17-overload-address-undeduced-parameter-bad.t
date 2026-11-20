// expect reject
// A placeholder result cannot supply a missing template argument.
template<class T> auto value() { return T{}; }
int (*read)() = &value;
