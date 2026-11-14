char global[3] = "abc";
struct Buffer { char text[3]; unsigned char guard; } buffer = { "def", 42 };
int main(void) {
  char local[3] = { "ghi" };
  return !(global[2] == 'c' && buffer.text[2] == 'f' && buffer.guard == 42 && local[2] == 'i');
}
