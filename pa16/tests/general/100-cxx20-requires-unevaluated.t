constexpr int check() {
  int value = 0;
  bool valid = requires { ++value; };
  return value + valid;
}
static_assert(check() == 1, "requirements do not execute");
int main() { return check() - 1; }
