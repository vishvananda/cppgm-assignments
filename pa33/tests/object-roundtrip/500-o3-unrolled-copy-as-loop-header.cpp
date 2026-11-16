// The inner loop unrolls fully. Its first copy becomes the outer loop's
// header, which the runtime unroller then unrolls. The copy's kind came from
// a lowering kind in memory and from a plain block in the text.
extern "C" int nested_loops(int n)
{
  int total = 0;
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < 3; ++j) {
      if (j == i % 3)
        continue;
      total += i + j;
    }
  }
  return total;
}
