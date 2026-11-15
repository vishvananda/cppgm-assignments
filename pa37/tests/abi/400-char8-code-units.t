int select(char8_t value) { return value + 1; }
int select(unsigned char value) { return value + 2; }
extern "C" int utf8() {
  char8_t text[] = u8"Aé";
  return select(u8'A') + text[1] + text[2];
}
