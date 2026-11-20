// expect exit 0
typedef int ZeroLength[0];
struct Leaf {
  ZeroLength values;
};
struct Nested {
  Leaf member;
};
struct OrdinaryEmpty {};
struct WithTail {
  char prefix;
  Leaf member;
};

int main() {
  Nested local{};
  Leaf sequence[3]{};
  return sizeof(ZeroLength) != 0 || sizeof(local.member.values) != 0 ||
         sizeof(Leaf) != 0 || sizeof(Nested) != 0 || sizeof(sequence) != 0 ||
         alignof(Nested) != alignof(int) || sizeof(OrdinaryEmpty) != 1 ||
         sizeof(WithTail) != alignof(int);
}
