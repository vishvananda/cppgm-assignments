// expect exit 0
template<unsigned N> struct Fixed {
  char text[N]{};
  constexpr Fixed(const char (&p)[N]) { for (unsigned i = 0; i < N; ++i) text[i] = p[i]; }
};
template<Fixed... Keys> struct Unit {
  template<Fixed Key> static constexpr int value_of() { return sizeof(Key.text); }
};
template<class T> struct Parser {
  using Names = Unit<"first", "second">;
  static int parse(int v) {
    switch (v) {
    case Names::value_of<"first">(): return 1;
    case Names::value_of<"second">(): return 2;
    }
    return 0;
  }
};
int main() { return Parser<int>::parse(7) != 2; }
