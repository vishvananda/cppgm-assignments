_Atomic int counter;
typedef _Atomic long AtomicLong;
AtomicLong mask;
int * _Atomic pointer;
int main(void) {
  counter = 3;
  ++counter;
  __c11_atomic_store((_Atomic long*)&mask, 8, __ATOMIC_SEQ_CST);
  __c11_atomic_fetch_or(&mask, 3, __ATOMIC_SEQ_CST);
  int values[2] = { 17, 23 };
  pointer = values;
  ++pointer;
  return !(counter == 4 && __c11_atomic_load(&mask, __ATOMIC_SEQ_CST) == 11 && *pointer == 23);
}
