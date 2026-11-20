// expect exit 0
// N4140 [temp.dep.constexpr] and [temp.deduct]

template<bool> struct Enable {};
template<> struct Enable<true> { using type = void; };

template<class T, class U> constexpr bool accepts = sizeof(T) == sizeof(U);
template<class T> constexpr bool enabled = false;
template<> constexpr bool enabled<int> = true;

struct Disabled {};

template<class T> struct Box {
  int value = 0;
  Box() = default;
  template<class U, class = typename Enable<enabled<T> && accepts<T, U>>::type>
  Box(U*) : value(42) {}
};

template<class T, class U>
auto can_construct(U* input, int) -> decltype(Box<T>(input), bool()) { return true; }
template<class T>
bool can_construct(...) { return false; }

int main() {
  int n = 0;
  Box<Disabled> absent;
  Box<int> present(&n);
  return absent.value == 0 && present.value == 42 &&
      !can_construct<Disabled>(&n, 0) && can_construct<int>(&n, 0) ? 0 : 1;
}
