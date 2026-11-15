// VALIDATION: compile-fail
struct Result { operator bool() const; };
struct C { friend Result operator==(C,int); };
int main() { return 0 == C{}; }
