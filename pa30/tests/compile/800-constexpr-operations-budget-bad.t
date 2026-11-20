constexpr unsigned triangle(unsigned n) {
  unsigned result = 0;
  for (unsigned i = 1; i <= n; ++i)
    result += i;
  return result;
}
static_assert(triangle(32) == 528, "sufficient operations");
