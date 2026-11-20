// expect exit 0
template<class...> using Void = void;
template<class, class = void> struct Transparent { static constexpr bool value = false; };
template<class T> struct Transparent<T, Void<typename T::transparent>> { static constexpr bool value = true; };
template<bool B> struct Select { template<class K, class T> using type = K; };
template<> struct Select<false> { template<class K, class T> using type = T; };
template<class P> struct Map {
  using Key = typename P::key_type;
  using Hash = typename P::hash;
  template<class K>
  using Arg = typename Select<Transparent<Hash>::value>::template type<K, typename P::key_type>;
  template<class K = Key, class... A>
  static unsigned insert(Arg<K>&&, A&&...) { return sizeof...(A); }
};
struct Key { int value; Key(int v) : value(v) {} };
struct Hash {};
struct Policy { using key_type = Key; using hash = Hash; };
int main() { return Map<Policy>::insert(1, 0) != 1; }
