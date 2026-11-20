// expect exit 0
// N3485 [temp.deduct.decl]: invalid substitution removes a candidate
// while resolving the explicit instantiation.
template<class T> struct Traits {};

template<class T>
T convert(T value) { return value; }

template<class T>
typename Traits<T>::result convert(T value);

template int convert<int>(int);

int main() { return convert(42) == 42 ? 0 : 1; }
