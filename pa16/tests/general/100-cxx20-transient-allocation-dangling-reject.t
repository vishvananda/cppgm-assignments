constexpr int after_delete() {
  int* allocation = new int(7);
  delete allocation;
  return *allocation;
}
static_assert(after_delete() == 7);
