// Copy assignment carries the active array into a union with an active scalar. expect exit 0
union Words {
  unsigned parts[2];
  unsigned long long number;
  constexpr Words(unsigned a, unsigned b) : parts{a, b} {}
  constexpr Words(unsigned long long n) : number(n) {
    Words pieces(static_cast<unsigned>(n), static_cast<unsigned>(n >> 32));
    *this = pieces;
  }
};

constexpr Words pieces((11ull << 32) | 17ull);
static_assert(pieces.parts[0] == 17 && pieces.parts[1] == 11, "copy the active array");
int main() { return pieces.parts[1] != 11; }
