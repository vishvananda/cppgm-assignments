// expect reject
struct Number { int n; consteval operator int() const { return n + 1; } };
int result(int n) { int value = Number{n}; return value; }
