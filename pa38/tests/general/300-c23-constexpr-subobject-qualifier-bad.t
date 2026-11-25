struct Inner { volatile int excluded; };
struct Outer { struct Inner children[2]; };
constexpr struct Outer object = {};
