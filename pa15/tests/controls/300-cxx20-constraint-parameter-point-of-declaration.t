// expect exit 0
using Later = int;

template<class T, class U> concept SameSize = sizeof(T) == sizeof(U);

template<SameSize<Later> SameSize, class Later>
struct Checked {};

template<class Earlier, SameSize<Earlier> SameSize>
struct UsesEarlier {};

Checked<int, char> first;
UsesEarlier<char, char> second;

int main() { return sizeof(first) != sizeof(second); }
