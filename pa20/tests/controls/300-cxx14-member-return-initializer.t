// expect exit 0
// N4140 [dcl.spec.auto] and [temp.inst]

template<int Size> struct Buffer {
  static constexpr auto capacity() { return Size; }
  static constexpr auto extent = capacity();
  char bytes[extent];
};

template<class T> struct Factory {
  static auto make() { return T{}; }
  using Type = decltype(make());
};

struct Payload { int value; };

static_assert(sizeof(Buffer<3>) == 3, "first specialization");
static_assert(sizeof(Buffer<7>) == 7, "second specialization");

int main() {
  Factory<Payload>::Type object{42};
  return object.value != 42;
}
