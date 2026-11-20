// N4659 [over.match.class.deduct], [over.match.list]
// A non-template guide can select a specialization for a braced initializer.

template<class T>
struct Box
{
  T value;
  explicit Box(T input) : value(input) {}
};
Box(long) -> Box<short>;

struct Element
{
  int value;
};

template<class T>
struct Bundle
{
  T value;
  Bundle(Element input) : value(input.value) {}
};
Bundle(Element) -> Bundle<long>;

int main()
{
  Box direct{7L};
  Bundle nested{{9}};
  return sizeof(direct.value) == sizeof(short) && direct.value == 7
      && sizeof(nested.value) == sizeof(long) && nested.value == 9 ? 0 : 1;
}
