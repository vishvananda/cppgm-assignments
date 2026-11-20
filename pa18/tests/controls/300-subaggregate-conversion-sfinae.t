// expect exit 0
struct Payload {
  unsigned char bytes[1024];
};

struct Record {
  Payload first;
  Payload second;
};

struct Any {
  template<class T> operator T&() const;
};

template<class T, int... I>
auto accepts(int) -> decltype(void(T{(void(I), Any{})...}), bool()) { return true; }

template<class T, int... I>
bool accepts(...) { return false; }

int main() {
  return !accepts<Record, 0, 1>(0) || accepts<Record, 0, 1, 2>(0);
}
