struct Bits { unsigned value : 5; };
extern "C" int observe(int input) {
  int value = input + 3;
  asm volatile("" : "+r"(value));
  Bits bits = { 17 };
  asm volatile("" : "+r"(bits.value) : : "memory");
  return value + bits.value;
}
