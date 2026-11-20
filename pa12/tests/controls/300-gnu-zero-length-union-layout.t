// expect exit 0
union Choice {
  double items[0];
};

int main() {
  return sizeof(Choice) != 0 || alignof(Choice) != alignof(double);
}
