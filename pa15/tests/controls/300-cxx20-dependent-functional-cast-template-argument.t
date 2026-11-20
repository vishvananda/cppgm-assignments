// expect exit 0
template<bool B> struct Choice {
  int selected() const { return B ? 1 : 0; }
};

struct Enabled { static constexpr bool value = true; };
struct Disabled { static constexpr bool value = false; };

template<class T>
auto choose(T) -> Choice<bool(T::value)> {
  return Choice<bool(T::value)>();
}

int main() {
  return choose(Enabled()).selected() != 1 || choose(Disabled()).selected() != 0;
}
