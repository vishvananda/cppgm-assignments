template<class... T> struct Outer {
  template<class... U> static int run(T... args) {
    bool good = requires(U... args) { (args + ...); requires (sizeof...(args) == 1); };
    bool local = requires(int args) { args + 1; };
    return good && local ? sizeof...(args) : 0;
  }
};
int main() { return Outer<int, int>::run<char>(1,2) - 2; }
