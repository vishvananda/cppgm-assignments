// expect exit 0
constexpr int* allocate_one(int value) {
  return new int(value);
}
constexpr int use_one(int value) {
  int* allocation = allocate_one(value);
  int result = *allocation;
  delete allocation;
  return result;
}
constexpr int use_array(int count) {
  int* allocation = new int[count]{};
  for (int i = 0; i != count; ++i)
    allocation[i] = 2 * i;
  int result = allocation[count - 1] + int((allocation + count) - allocation);
  delete[] allocation;
  return result;
}
static_assert(use_one(7) == 7);
static_assert(use_array(4) == 10);
int main() { return 0; }
