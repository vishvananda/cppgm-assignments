// expect exit 0
auto answer() { return 42; }
auto explicitResult() -> int { return answer(); }
int main() { return explicitResult() - 42; }
