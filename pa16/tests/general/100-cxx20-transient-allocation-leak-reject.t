constexpr int leak() {
  int* allocation = new int(7);
  return *allocation;
}
static_assert(leak() == 7);
