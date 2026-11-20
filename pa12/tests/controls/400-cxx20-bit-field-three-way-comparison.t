// expect exit 0
// CWG 2627 permits conversion of the values represented by a narrow bit-field.
namespace std {
struct strong_ordering {
  int value;
  static const strong_ordering less;
  static const strong_ordering equal;
  static const strong_ordering greater;
};
const strong_ordering strong_ordering::less{-1};
const strong_ordering strong_ordering::equal{0};
const strong_ordering strong_ordering::greater{1};
}

struct UnsignedField { unsigned value : 5; };
struct SignedField { long long value : 7; };

int compare(UnsignedField a, UnsignedField b) {
  return (a.value <=> b.value).value;
}
int compare(SignedField a, SignedField b) {
  return (a.value <=> b.value).value;
}

volatile unsigned runtimeValue = 17;
int main() {
  if (compare(UnsignedField{runtimeValue & 31u}, UnsignedField{17})) return 1;
  if (compare(UnsignedField{30}, UnsignedField{31}) >= 0) return 2;
  if (compare(SignedField{-3}, SignedField{-6}) <= 0) return 3;
  return compare(SignedField{-62}, SignedField{-62});
}
