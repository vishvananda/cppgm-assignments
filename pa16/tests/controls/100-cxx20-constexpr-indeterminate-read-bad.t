// N4861 [dcl.constexpr] and [expr.const]
// expect reject

struct Buffer {
  unsigned scratch;
  unsigned used;
  constexpr Buffer(unsigned n) : used(n) {}
};

constexpr unsigned record(bool set) {
  Buffer buffer(1);
  if (set)
    buffer.scratch = 2;
  return buffer.used + buffer.scratch;
}

static_assert(record(true) == 3);
static_assert(record(false) == 1);
int main() {}
