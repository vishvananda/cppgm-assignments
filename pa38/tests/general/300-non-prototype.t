int add();
int external();
static int empty() { return 17; }
int call_before_prototype(void) { return add((short)3, 4.0f); }
int add(int first, double second) { return first + (int)second; }
int main(void) {
  int (*callback)() = add;
  return !(call_before_prototype() == 7 && callback((char)5, 6.0f) == 11 &&
           empty() == 17 && external((short)2, 3.0f) == 5);
}
