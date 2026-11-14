static void (*callbacks[8])(void *);
static void *contexts[8];
static int registered, destroyed;
extern "C" int capture_thread_callback(void (*callback)(void *), void *context) {
  callbacks[registered] = callback;
  contexts[registered++] = context;
  return 0;
}
struct Value {
  int number;
  Value(int n) : number(n) {}
  ~Value() { destroyed += number; }
};
thread_local Value object(7);
static int local_value() {
  typedef Value Values[1];
  static thread_local const Values& reference = {Value(11)};
  return reference[0].number;
}
extern "C" int observe() {
  if (object.number != 7) return 1;
  if (local_value() != 11) return 2;
  if (registered != 2) return 10 + registered;
  while (registered) {
    --registered;
    callbacks[registered](contexts[registered]);
  }
  return destroyed != 18;
}
int main() { return observe(); }
