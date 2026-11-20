constexpr int wrong_delete() {
  int* allocation = new int[1]{7};
  int result = *allocation;
  delete allocation;
  return result;
}
static_assert(wrong_delete() == 7);
