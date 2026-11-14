// The plain hosted spelling has the same initialization facts as __constinit.
struct Value { int n; constexpr Value(int x) : n(x) {} };
constinit Value object(7);
constinit static int counter = 3;
static constinit const char* cause = "ready";
constinit thread_local int thread_value = 5;
constinit extern int declared;
int declared = 11;
int observe() {
  constinit static int local = 13;
  ++local;
  ++counter;
  return local + counter + thread_value + object.n + declared + (cause[0] == 'r');
}
int main() { return observe() != 42; }
