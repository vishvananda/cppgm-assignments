// expect exit 0
// N4861 [dcl.fct] and [dcl.spec.auto]

constexpr int pack(auto...) { return 4; }
constexpr int pointer_pack(auto*...) { return 5; }
constexpr int varargs(auto first, ...) { return first; }

struct Callable {
  struct Result { constexpr ~Result() noexcept(false) {} };
  constexpr Result operator()(auto...) { return {}; }
};

static_assert(pack() == 4);
static_assert(pack(1, 2L) == 4);
static_assert(pointer_pack(static_cast<int*>(nullptr)) == 5);
static_assert(varargs(6, 7) == 6);

int main() { []() consteval { Callable{}(); }(); }
