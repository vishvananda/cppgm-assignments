struct Bits { unsigned value:3; };
int main(void) { struct Bits bits = {1}; return &_Generic(0, int: bits.value) != 0; }
