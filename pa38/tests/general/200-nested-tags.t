struct Outer {
  struct Nested { int value; } nested;
  enum Flag { disabled, enabled } flag;
};
typedef struct Nested Nested;
int main(void) {
  struct Outer outer = { { 17 }, enabled };
  Nested *pointer = &outer.nested;
  enum Flag flag = enabled;
  return !(pointer->value == 17 && outer.flag == flag);
}
