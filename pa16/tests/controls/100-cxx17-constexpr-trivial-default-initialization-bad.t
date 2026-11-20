// N4659 [dcl.constexpr]
// expect reject

struct Buffer {
  char scratch[4];
  unsigned used;
  constexpr Buffer(unsigned n) : used(n) {}
};

constexpr unsigned record() {
  Buffer buffer(1);
  buffer.scratch[0] = 2;
  return buffer.used + buffer.scratch[0];
}

static_assert(record() == 3);
int main() {}
