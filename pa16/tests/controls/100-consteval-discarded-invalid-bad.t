// expect reject
void runtime();
consteval void require_zero(int n) { if (n != 0) runtime(); }
int main() { require_zero(1); }
