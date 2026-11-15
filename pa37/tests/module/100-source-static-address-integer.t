static int values[3] = { 3, 5, 7 };
static int add(int value) { return value + 1; }
// The observing constructor is intentionally defined before these integer
// address initializers. They must already be relocated before any constructor.
extern unsigned int object_address;
extern unsigned int function_address;
static int captured;
struct Capture {
  Capture() {
    captured = object_address == reinterpret_cast<unsigned int>(&values[1]) &&
      function_address == reinterpret_cast<unsigned int>(add);
  }
} capture;
unsigned int object_address = reinterpret_cast<unsigned int>(&values[1]);
unsigned int function_address = reinterpret_cast<unsigned int>(add);
extern "C" int observe() { return captured; }
