struct Sample { int x, y; };
struct Image { int marker; struct Sample samples[3]; int tail; };
struct Image image = {
  .samples[1].y = 7, .marker = 23, .samples[1].x = 17, .tail = 42
};
int values[6] = { [4] = 7, [1] = 2, 3, [4] = 11 };
const char *names[] = { [3] = "three", [0] = "zero" };
union Value { int number; struct Sample sample; };
int main(void) {
  struct Sample sample = { .y = 3, .x = 2 };
  enum Flags { none = 0, one = 1, two = 2 } flags = none;
  flags |= one;
  flags |= two;
  union Value value = { .sample.y = 19, .sample.x = 13 };
  return !(image.marker == 23 && image.tail == 42 && image.samples[1].x == 17 &&
           image.samples[1].y == 7 && image.samples[0].x == 0 &&
           values[0] == 0 && values[1] == 2 && values[2] == 3 && values[4] == 11 &&
           sizeof(names) / sizeof(names[0]) == 4 && names[1] == 0 && names[3][0] == 't' &&
           sample.x == 2 && sample.y == 3 && value.sample.x == 13 && value.sample.y == 19 && flags == 3);
}
