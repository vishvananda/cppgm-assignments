// expect exit 0
int twice(int n) noexcept { return n * 2; }

using Function = int (*)(int);
template<Function P> struct Call {
  static constexpr Function value = P;
};
template<auto P> using Converted = Call<P>;

constexpr Function direct = Call<twice>::value;
constexpr Function converted = Converted<&twice>::value;

int main() {
  return direct == converted && converted(6) == 12 ? 0 : 1;
}
