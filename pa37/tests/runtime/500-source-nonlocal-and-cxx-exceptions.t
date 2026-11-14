extern "C" int setjmp(void *);
extern "C" void longjmp(void *, int) __attribute__((noreturn));
static unsigned environment[64];
static int destroyed;
struct Guard { ~Guard() { ++destroyed; } };
extern "C" int observe(int input) {
  destroyed = 0;
  volatile int caught = 0;
  int value = setjmp(environment);
  if (value == 0) {
    {
      Guard guard;
      try { throw input; }
      catch (int number) { caught = number; }
    }
    longjmp(environment, input);
  }
  try { throw value + 3; }
  catch (int number) { return destroyed * 10000 + caught * 100 + number; }
}
