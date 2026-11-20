// expect exit 0
template<class T> struct Box {
  explicit Box(T& value): address(&value) {}
  T* address;
};
template<class T> Box(T&) -> Box<T>;

template<class T>
  requires requires(T& value) { Box{value}; }
T* address_of(T& input);

template<class U>
  requires requires(U& renamed) { Box{renamed}; }
U* address_of(U& input) {
  return Box{input}.address;
}

int main() {
  int n = 42;
  return address_of(n) != &n;
}
