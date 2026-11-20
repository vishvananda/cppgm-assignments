// expect reject
struct Header {
  unsigned count;
  int values[];
};

int main() {
  Header header{};
  return sizeof(header.values);
}
