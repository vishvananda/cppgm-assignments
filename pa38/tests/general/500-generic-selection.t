#define KIND(x) _Generic((x), int: 1, unsigned int: 2, char: 3, short: 4, \
                        float: 5, double: 6, int*: 7, const int*: 8, \
                        int (*)(int): 9, char*: 11, default: 10)
_Static_assert(_Generic((short)0, short: 1, int: 0), "no integer promotion");
enum { selected_constant = _Generic(0, int: 17, default: 0) };
int unavailable(void);
static int initialized = _Generic(0, int: 19, default: unavailable());
static int effects;
static int control(void) { ++effects; return 0; }
static int plus_one(int value) { return value + 1; }
struct Bits { unsigned first: 3; unsigned second: 3; };
struct Record { int value; int tail; };
static struct Record make_record(void) { struct Record value = {13, 17}; return value; }
static struct Record select_record(void) { return _Generic(0, int: make_record()); }
int main(void) {
  int value = 0, other = 0;
  const int qualified = 7;
  _Atomic int atomic_value = 0;
  const int const_array[2] = {1, 2};
  int array[_Generic((float)0, float: 4, default: 2)] = {2, 3, 5, 7};
  if (_Generic(qualified, const int: 0, int: 1) != 1) return 15;
  if (_Generic(array, int* const: 0, int*: 1) != 1) return 16;
  if (_Generic(0, int[2]: 0, const int[2]: 0, default: 1) != 1) return 17;
  if (selected_constant != 17 || initialized != 19) return 1;
  if (KIND(const_array) != 8 || KIND((_Bool)0) != 10 || KIND('x') != 1) return 13;
  if (KIND(qualified) != 1 || KIND(atomic_value) != 1 || KIND((unsigned)0) != 2) return 2;
  if (KIND((char)0) != 3 || KIND((short)0) != 4 || KIND((float)0) != 5 || KIND(1.0) != 6) return 3;
  if (KIND(array) != 7 || KIND((const int*)0) != 8 || KIND(plus_one) != 9 || KIND("x") != 11) return 4;
  if (_Generic(control(), int: ++effects, default: (effects += 100)) != 1 || effects != 1) return 5;
  _Generic(0, int: value, default: other) = 22;
  ++_Generic(0, int: value, default: other);
  if (value != 23 || other != 0 || &_Generic(0, int: value) != &value) return 6;
  struct Bits bits = {1, 2};
  _Generic(0, int: bits.first, default: bits.second) = 5;
  if (bits.first != 5 || bits.second != 2) return 7;
  if (sizeof(_Generic(0, int: array)) != sizeof(array) || _Generic(0, int: array)[2] != 5) return 8;
  if (_Generic(0, int: plus_one)(8) != 9) return 9;
  if (_Generic(0, int: _Generic(0.0, double: 31, default: 0), default: 0) != 31) return 10;
  if (_Generic((void)++effects, default: 42) != 42 || effects != 1) return 14;
  _Generic(0, int: (void)++effects, default: (void)0);
  struct Record record = _Generic(0, int: make_record());
  if (record.value != 13 || _Generic(0, int: make_record()).tail != 17) return 11;
  if (select_record().tail != 17) return 12;
  return effects != 2;
}
