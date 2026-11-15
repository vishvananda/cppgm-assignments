int select(char8_t);
int select(unsigned char);
int use(char8_t byte) {
  int promoted = +byte;
  const char8_t* text = u8"text";
  return promoted + select(u8'A') + text[0];
}
