extern "C" int setjmp(void *);
extern "C" void longjmp(void *, int) __attribute__((noreturn));
unsigned environment[64];
static unsigned inner_environment[64];

void jump_from_nested_call(int depth, int value);

extern "C" int observe(int input) {
  volatile int kept = 17;
  int unchanged[3] = { 2, 3, 5 };
  int result = setjmp(environment);
  if (result == 0) {
    kept = 23;
    if (setjmp(inner_environment) == 0) {
      void (*volatile callback)(void *, int) = longjmp;
      callback(inner_environment, 7);
    }
    jump_from_nested_call(3, input);
  }
  return result + kept + unchanged[0] + unchanged[1] + unchanged[2];
}
