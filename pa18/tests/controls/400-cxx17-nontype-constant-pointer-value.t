// expect exit 0
constexpr char first[] = "a";
constexpr char second[] = "b";
constexpr const char* words[] = {first, second};

template<const char* Text> struct Word {
  static constexpr char head() { return Text[0]; }
  static const char* pointer() { return Text; }
};

int increment(int value) { return value + 1; }
constexpr int (*operations[])(int) = {increment};

template<int (*Operation)(int)>
int call(int value) { return Operation(value); }

int main() {
  return Word<words[0]>::head() == 'a' &&
    Word<words[1]>::pointer() == second &&
    call<operations[0]>(3) == 4 ? 0 : 1;
}
