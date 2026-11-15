typedef int Number;
static int prototype(Number);
static int prototype(Number value) { return value; }
static int twice(int n) { return n * 2; }
static int legacy();
static int legacy(a, b)
  float b;
  signed char a;
{ return sizeof(a) == 1 && sizeof(b) == 4 ? a + (int)b : -1; }
int narrowed(int, double);
int narrowed(a, b)
  float b;
  unsigned char a;
{ return a + (int)b; }
static int indirect(a, b, operation)
  int a[2], *b;
  int operation(int);
{ return operation(a[0] + a[1] + *b); }
static int implicit(a, b)
  int b;
{ return a + b; }
static int qualified(value)
  register const int value;
{ return value; }
static int truth(flag) _Bool flag; { return sizeof(flag) * 10 + flag; }
static int olddecl();
static int olddecl(a)
  int a;
{ return a; }
static int olddecl(int);
int external_old(int, double);
int main(void) {
  if (legacy(42, 4.75f) != 46 || narrowed(258, 4.75) != 6) return 1;
  int (*callback)(int, double) = legacy;
  if (callback(42, 4.75) != 46) return 2;
  int array[2] = {3,5}, value = 13;
  if (indirect(array, &value, twice) != 42 || implicit(20,22) != 42) return 3;
  if (qualified(42) != 42 || olddecl(42) != 42 || prototype(42) != 42 || truth(256) != 11) return 4;
  return external_old(258, 4.75) != 6;
}
