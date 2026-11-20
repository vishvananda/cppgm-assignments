// N4861 [dcl.constexpr] and [expr.const]
// expect exit 0

struct Object {
  int value;
  int* pointer;
  constexpr Object(int v) : value(v), pointer(&value) {}
  constexpr ~Object() { *pointer = 90; }
};

constexpr Object object{4};
constexpr Object array[]{Object{5}, Object{6}};
static_assert(object.value == 4 && object.pointer == &object.value);
static_assert(array[0].value == 5 && array[1].value == 6);
int main() {}
