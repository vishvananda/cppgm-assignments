// expect reject
int main() { auto pointer = +[]() consteval { return 42; }; return pointer(); }
