struct Value { int number; constexpr Value(int n) : number(n) {} };
struct Box { static int number; static Value object; };
constinit int Box::number = 17;
__constinit Value Box::object(23);
namespace Nested {
struct Holder { static int number; };
constinit int Holder::number = 2;
}
int main() { return Box::number + Box::object.number + Nested::Holder::number != 42; }
