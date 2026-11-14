// A scalar reset must preserve the histogram filled through variable indices.
extern "C" int observe(int seed) {
  int counts[16] = {0};
  for (int i = 0; i < 40; ++i) ++counts[(i * seed) % 15];
  counts[0] = 0;
  int sum = 0;
  for (int i = 1; i < 16; ++i) sum += counts[i];
  return sum;
}
int main() { return observe(1) != 37 || observe(3) != 32; }
