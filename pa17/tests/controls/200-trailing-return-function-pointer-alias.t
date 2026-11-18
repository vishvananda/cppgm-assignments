// expect exit 0
using Callback = auto (*)(int) -> int;
template<class T> using TypedCallback = auto (*)(T) -> T;

int plus_one(int n) { return n + 1; }
long twice(long n) { return 2 * n; }

int main() {
  Callback callback = plus_one;
  TypedCallback<long> typed_callback = twice;
  return callback(6) != 7 || typed_callback(10) != 20;
}
