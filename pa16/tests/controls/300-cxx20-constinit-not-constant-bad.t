// expect reject
constinit int count = 3;
static_assert(count == 3, "mutable object is not usable in a constant expression");
