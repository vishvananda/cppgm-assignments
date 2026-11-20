template<unsigned long N>
int first_bad_byte() {
  char bytes[N + 1];
  for (unsigned long i = 0; i != N; ++i) bytes[i] = '0';
  bytes[N] = 0;
  for (unsigned long i = 0; i != N; ++i)
    if (bytes[N - i - 1] != '0') return int(i) + 1;
  return 0;
}

int main() { return first_bad_byte<16>(); }
