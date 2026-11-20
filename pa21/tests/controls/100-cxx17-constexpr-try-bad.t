// The try-block in the constexpr definition requires C++20. must be rejected
constexpr int checked() {
  try {
    return 1;
  } catch (...) {
    return 0;
  }
}

int main() { return 0; }
