// VALIDATION: compile-fail
struct C { int& r; bool operator==(const C&) const = default; };
int main() { int x = 1; C a{x}; return a == a; }
