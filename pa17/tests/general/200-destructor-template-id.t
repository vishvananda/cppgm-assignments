int destroyed;
template<class T> using Same = T;
template<class T> struct Value {
  T number;
  ~Value<Same<T> >() { destroyed += sizeof(T); }
};
template<class T, int N = 3> struct WithDefault {
  ~WithDefault<T,N>() { destroyed += N; }
};
int main() {
  { Value<int> first; first.number = 5; Value<char> second; second.number = 7; WithDefault<int> third; }
  return destroyed != sizeof(int) + sizeof(char) + 3;
}
