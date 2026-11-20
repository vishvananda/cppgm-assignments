// expect exit 0
int operator""_byte(char c) { return c; }
int operator""_byte(char32_t) { return 0; }

int main() { return u8'A'_byte == 65 ? 0 : 1; }
