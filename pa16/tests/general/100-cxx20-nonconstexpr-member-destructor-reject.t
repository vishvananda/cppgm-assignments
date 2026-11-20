struct Member {
  ~Member() {}
};
struct Object {
  Member member;
  constexpr ~Object() {}
};
