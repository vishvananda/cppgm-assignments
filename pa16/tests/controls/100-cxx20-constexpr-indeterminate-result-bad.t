// N4861 [dcl.constexpr] and [expr.const]
// expect reject

struct Buffer {
  unsigned scratch;
  unsigned used;
  constexpr Buffer(unsigned n) : used(n) {}
};

constexpr Buffer buffer(1);
int main() {}
