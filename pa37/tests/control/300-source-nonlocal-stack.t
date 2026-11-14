extern "C" int setjmp(void *);
extern "C" void longjmp(void *, int) __attribute__((noreturn));
__attribute__((noinline)) static void jump_deep(void *environment, int depth) {
  volatile unsigned *padding = static_cast<volatile unsigned *>(__builtin_alloca(1024 + depth * 16));
  padding[0] = 17;
  padding[255] = 29;
  if (depth) jump_deep(environment, depth - 1);
  if (padding[0] != 17 || padding[255] != 29) __builtin_trap();
  longjmp(environment, 7);
}
__attribute__((noinline)) static int nested_frames(int depth) {
  unsigned environment[64];
  volatile int child = 0;
  int result = setjmp(environment);
  if (result == 0) {
    if (depth) child = nested_frames(depth - 1);
    longjmp(environment, depth + 1);
  }
  return child + result;
}
extern "C" int observe(int input) {
  unsigned environment[64];
  volatile unsigned *before = static_cast<volatile unsigned *>(__builtin_alloca(80 + input * 4));
  before[0] = 31;
  volatile int count = 0;
  int result = setjmp(environment);
  if (result == 0 || ++count < 300) jump_deep(environment, 4);
  volatile unsigned *after = static_cast<volatile unsigned *>(__builtin_alloca(64));
  after[0] = 41;
  return result + count + before[0] + after[0] + nested_frames(input);
}
