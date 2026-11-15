// VALIDATION: compile-fail
struct C { int x; bool operator==(const C&) = default; };
