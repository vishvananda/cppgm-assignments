// CWG 1395: an unused trailing pack loses to a template with no
// corresponding parameter during default initialization. expect exit 0
struct Choice {
  int value;

  template<class... T> explicit Choice(T&&...) : value(1) {}
  template<class... T> explicit Choice(T*...) : value(2) {}
  template<class = void> Choice() : value(3) {}
};

int main() {
  Choice choice;
  return choice.value != 3;
}
