// expect exit 0
// N4659 [temp.deduct.funcaddr]: deduce from the target's parameter types,
// then instantiate the result and compare the complete function type.
template<class Owner> struct Methods {
  template<class T>
  auto twice(T value) noexcept(sizeof(Owner) == sizeof(int)) { return value + value; }
};

int (Methods<int>::*twice)(int) noexcept = &Methods<int>::twice;

int main() {
  Methods<int> instance;
  return (instance.*twice)(21) == 42 ? 0 : 1;
}
