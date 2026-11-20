// expect exit 0
typedef double Real;
int check(double value) { return value == 0.0 ? 0 : 1; }
int main() { return check(Real()) + check(Real{}); }
