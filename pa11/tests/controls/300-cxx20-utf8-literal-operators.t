// expect exit 0
typedef unsigned long size_t;
int operator ""_byte(char8_t value) { return value; }
int operator ""_count(const char8_t* text, size_t length) {
  return length == 3 && text[0] == 65 && text[1] == 195 && text[2] == 169;
}
int main() { return u8'A'_byte != 65 || !u8"Aé"_count; }
