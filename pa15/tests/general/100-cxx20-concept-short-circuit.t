template<class T> struct Trap {static_assert(sizeof(T)==0);}; template<class T> concept C = false && (sizeof(Trap<T>)>0); static_assert(!C<int>);
int main() { return C<int>; }
