int global;
int calls;
int next() { ++calls; return 17; }
extern "C" int observe(int value) {
  global = value;
  asm volatile("" : : "rm"(next()) : "memory");
  int first = global;
  global = value + 1;
  asm volatile("" : : "m"(global) : "memory");
  volatile int input = 23;
  asm volatile("" : : "r"(input) : "memory");
  return first + global + calls;
}
