consteval int value(int n);
struct Immediate { consteval Immediate(int); consteval int value() const; };
constinit int count = 3;
auto lambda = [](int n) consteval { return n + 1; };
