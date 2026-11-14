__attribute__((noinline)) static int check(const char *text) {
  int index = -1, dots = 0;
  do {
    ++index;
    if (text[index] != "1.2.3"[index]) return -1;
    if (text[index] == '.') ++dots;
  } while (dots < 2 && text[index] && "1.2.3"[index]);
  return dots;
}
extern "C" int observe(int input) {
  return check(input == 0 ? "1.2.3" : input == 1 ? "1.2.7" : "1.9.3");
}
