// expect exit 0
enum Bits { first = 1, last = 4 };

Bits operator|(Bits left, Bits right) {
    return Bits(int(left) | int(right));
}

unsigned long flags[] = { first | last };

int main() { return flags[0] != 5; }
