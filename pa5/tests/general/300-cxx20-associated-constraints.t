template<class T> concept C = sizeof(T) > 1;
template<C T> requires C<T> struct Box {};
template<C... T> struct Pack {};
template<class U> requires (C<U> && true) int take(U);
