// VALIDATION: compile-fail
struct C { bool operator<(const C&) const = default; };
int main() { return C{} < C{}; }
