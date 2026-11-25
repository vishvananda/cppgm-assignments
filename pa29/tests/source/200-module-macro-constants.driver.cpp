extern "C" unsigned macro_constants[];
int main() { return macro_constants[0] != 102 || macro_constants[1] != 80; }
