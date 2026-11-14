struct Bits { unsigned value : 3; unsigned other : 4; };
int main(void) {
  struct Bits bits = { 0, 0 };
  bits.value = 7;
  bits.value += 2;
  ++bits.other;
  bits.other++;
  return !(bits.value == 1 && bits.other == 2);
}
