// expect reject
int result(int n) { auto next = [](int x) consteval { return x + 1; }; return next(n); }
