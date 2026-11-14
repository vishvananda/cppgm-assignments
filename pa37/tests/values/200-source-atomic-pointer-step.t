extern "C" int observe(int input) {
  int values[3] = { input, 17, 23 };
  _Atomic(int*) pointer = values;
  int *first = pointer++;
  ++pointer;
  return *first + *pointer;
}
