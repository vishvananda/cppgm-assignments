// Skipped operands never expand unequal packs, including nested instantiations; expect exit 0
template<class... A> struct Outer {
  template<class... B> struct Inner {
    template<class T> requires (true || (((sizeof(A) + sizeof(B)) > 0) && ...))
    static int nested(T) { return 1; }
    static int nested(...) { return 2; }
  };
  template<class... B> requires (true || (((sizeof(A) + sizeof(B)) > 0) && ...))
  static int direct(B...) { return 3; }
  static int direct(...) { return 4; }
  template<class... B> requires (false && (((sizeof(A) + sizeof(B)) > 0) && ...))
  static int skipped(B...) { return 5; }
  static int skipped(...) { return 6; }
  template<class... B> requires requires(B... b) {
    requires true || (((sizeof(A) + sizeof(B)) > 0) && ...);
    (b + ...);
  }
  static int local(B...) { return 7; }
  static int local(...) { return 8; }
};
int main() {
  return Outer<int>::Inner<int, int>::nested(0) + Outer<int>::direct(1, 2)
    + Outer<int>::skipped(1, 2) + Outer<int>::local(1, 2) - 17;
}
