// A tag-producing immediate function shares ordinary template instantiation
// and the typed constant interpreter, without emitting a runtime helper.
// expect exit 0
struct Small { int value; };
struct Large { int value; };
template<class T> consteval auto tag()
{
  if constexpr (sizeof(T) == 1) return Small{3};
  else return Large{7};
}
struct Input {};
struct Random : Input {};
template<class T> consteval auto empty_tag()
{
  if constexpr (sizeof(T) == 1) return Input{};
  else return Random{};
}
int main()
{
  Small a = tag<char>(); Large b = tag<int>();
  auto input = empty_tag<char>(); auto random = empty_tag<int>();
  (void)input; (void)random;
  return a.value + b.value == 10 ? 0 : 1;
}
