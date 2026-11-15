template<class T> concept Any = true;
void f(Any decltype(auto) value) {}
