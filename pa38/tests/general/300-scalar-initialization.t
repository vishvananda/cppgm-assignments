struct Values { unsigned char small; float fraction; unsigned value; };
struct Values values = { 257, 1.23456789012345, -1 };
enum Index { first, second, third };
int main(void) {
  unsigned char small = { 258 };
  enum Index index = first;
  index++;
  ++index;
  return !(values.small == 1 && small == 2 && values.value == (unsigned)-1 && index == third);
}
