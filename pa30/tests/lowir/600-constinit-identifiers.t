// C++11--17 names stay ordinary identifiers in hosted code.
namespace variables {
int constinit = 2;
int read() { int constinit(3); return constinit; }
}
namespace functions {
int constinit(int value) { return value + 5; }
int read() { return constinit(3); }
}
namespace classes {
struct constinit { int value; };
constinit object = {4};
}
namespace aliases {
typedef int constinit;
constinit object = 7;
}
namespace constinit { int value = 11; }
template<class constinit> constinit identity(constinit value) { return value; }
int main() {
  return variables::constinit != 2 || variables::read() != 3 || functions::read() != 8 ||
         classes::object.value != 4 || aliases::object != 7 || constinit::value != 11 || identity(13) != 13;
}
