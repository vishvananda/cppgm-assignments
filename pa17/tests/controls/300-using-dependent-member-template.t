// Equivalent dependent parameter types participate in using-declaration hiding. expect exit 0
template<bool, class T = void> struct Enable {};
template<class T> struct Enable<true, T> { using type = T; };
template<bool condition> using EnableIf = typename Enable<condition>::type;

template<class T> struct Select { static constexpr bool value = false; };
template<> struct Select<long> { static constexpr bool value = true; };

namespace foundation {
template<class Tag> struct Base {
  template<class T>
  auto choose(const T&, EnableIf<!Select<T>::value>* = nullptr) const { return 1; }

  template<class T>
  auto choose(const T&, EnableIf<Select<T>::value>* = nullptr) const { return 3; }
};
}

template<class Tag> struct ImportFirst : foundation::Base<Tag> {
  using foundation::Base<Tag>::choose;

  template<class T>
  auto choose(const T&, EnableIf<!Select<T>::value>* = nullptr) const { return 2L; }
};

template<class Tag> struct ImportLast : foundation::Base<Tag> {
  template<class T>
  auto choose(const T&, EnableIf<!Select<T>::value>* = nullptr) const { return 2L; }

  using foundation::Base<Tag>::choose;
};

int main() {
  ImportFirst<int> first;
  ImportLast<int> last;
  static_assert(sizeof(first.choose(0)) == sizeof(long), "derived declaration wins after using");
  static_assert(sizeof(last.choose(0)) == sizeof(long), "derived declaration wins before using");
  return first.choose(0) != 2 || first.choose(0L) != 3 ||
         last.choose(0) != 2 || last.choose(0L) != 3;
}
