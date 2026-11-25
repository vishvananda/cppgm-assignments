union Choice { int a, b; };
constexpr union Choice choice = {.b = 2};
static_assert(choice.a == 2);
