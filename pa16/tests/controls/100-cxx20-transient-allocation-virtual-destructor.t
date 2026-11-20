// expect exit 0
struct Value {
  int* result;
  constexpr Value(int& target) : result(&target) {}
  constexpr virtual ~Value() { *result = 22; }
};
constexpr int release() {
  int result = 0;
  Value* object = new Value(result);
  delete object;
  return result;
}
static_assert(release() == 22);
int main() { return release() == 22 ? 0 : 1; }
