int run(int value) {
  int result = 0;
  if (value) goto later;
  int skipped = 17;
  result = skipped;
later:
  switch (value) {
    int other = 42;
    case 1: result = 23; break;
    default: result += 1; break;
  }
  return result;
}
int main(void) { return !(run(1) == 23 && run(0) == 18); }
