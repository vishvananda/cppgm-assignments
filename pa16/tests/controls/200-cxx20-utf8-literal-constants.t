// expect exit 0
typedef unsigned long size_t;
constexpr unsigned operator ""_byte(char8_t value) { return value; }
constexpr bool operator ""_utf8(const char8_t* text, size_t length) {
  return length == 2 && text[0] == 195 && text[1] == 169;
}
static_assert(u8'\xFF'_byte == 255, "unsigned code unit");
static_assert(u8"é"_utf8, "constant array retains its unsigned element type");
int main() { return !u8"é"_utf8 || u8'\xFF'_byte != 255; }
