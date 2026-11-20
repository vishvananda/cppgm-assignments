// expect exit 0
struct Packet {
  unsigned length : 3 = 5;
  enum : unsigned { empty, ready } state : 1 { ready };
};

int main() {
  Packet first;
  if (first.length != 5 || first.state != Packet::ready) return 1;
  Packet second{2, Packet::empty};
  if (second.length != 2 || second.state != Packet::empty) return 2;
  return 0;
}
