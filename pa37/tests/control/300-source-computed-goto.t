extern "C" int observe(int input) {
  static void *const targets[] = { &&first, &&second, &&third };
  if (input < 0 || input > 2) return -1;
  goto *targets[input];
first:
  return 17;
second:
  input = 0;
  goto *targets[input];
third:
  return targets[0] != targets[2] ? 23 : -2;
}
