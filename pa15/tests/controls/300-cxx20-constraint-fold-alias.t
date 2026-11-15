// A concept alias retains the original fold atom and its mapped pack; expect exit 0
template<class T> concept C = sizeof(T) > 0;
template<class... T> concept All = (C<T> && ...);
template<class... U> concept Alias = All<U...>;
template<class... T> requires All<T...> int pick(T...) { return 1; }
template<class... U> requires Alias<U...> && (sizeof...(U) > 0) int pick(U...) { return 2; }
int main() { return pick() + pick(1, 2) - 3; }
