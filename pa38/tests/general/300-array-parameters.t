int sum(const int values[static 3]);
int sum(const int values[const static 3]) {
  _Static_assert(sizeof(values) == sizeof(const int*), "array parameter adjusts to pointer");
  return values[0] + values[1] + values[2];
}
int update(int values[volatile 2]) { values[1] += values[0]; return values[1]; }
int main(void) {
  int values[3] = { 2, 3, 7 };
  return !(sum(values) == 12 && update(values) == 5);
}
