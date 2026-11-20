// expect reject
struct Base { constexpr virtual ~Base() {} };
struct Derived : virtual Base { constexpr ~Derived() override {} };
