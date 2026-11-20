// expect exit 0
struct Member {
  int value;
  constexpr explicit Member(int n) : value(n) {}
  constexpr ~Member() {}
};

struct Explicit {
  Member member;
  constexpr explicit Explicit(int n) : member(n) {}
  constexpr ~Explicit() = default;
};

struct Implicit {
  Member member;
  constexpr explicit Implicit(int n) : member(n) {}
};

constexpr Explicit explicit_result(int n) { return Explicit(n); }
constexpr Implicit implicit_result(int n) { return Implicit(n); }

int main() {
  volatile int n = 7;
  return explicit_result(n).member.value != 7 || implicit_result(n).member.value != 7;
}
