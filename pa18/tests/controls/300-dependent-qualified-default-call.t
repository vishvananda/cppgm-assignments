// N3485 [temp.res] and [temp.inst]: a dependent qualified name without
// typename in a default argument can name a value after substitution. expect exit 0
template<class T> struct Traits { struct Value {}; };
template<class T> int read(int value = Traits<T>::Value()) { return value; }

template<> struct Traits<int> { static int Value() { return 42; } };

int main() {
  return read<int>() == 42 && read<long>(17) == 17 ? 0 : 1;
}
