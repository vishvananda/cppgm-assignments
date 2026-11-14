typedef int Array[];
typedef int Fixed[4];
typedef int Other[3];
typedef const int ConstArray[4];
typedef _Atomic(int) AtomicArray[4];
typedef int Function();
typedef int Prototype(int, double);
typedef int Promoted(char);
struct First { int value; };
struct Second { int value; };
enum FirstEnum { a };
enum SecondEnum { b };
_Static_assert(__builtin_types_compatible_p(int, const volatile int), "top qualifiers");
_Static_assert(!__builtin_types_compatible_p(int*, const int*), "pointee qualifiers");
_Static_assert(!__builtin_types_compatible_p(int, _Atomic(int)), "atomic identity");
_Static_assert(sizeof(__builtin_types_compatible_p(int, int)) == sizeof(int), "int result");
_Static_assert(__builtin_types_compatible_p(Fixed, ConstArray), "array qualification");
_Static_assert(!__builtin_types_compatible_p(Fixed, AtomicArray), "array atomic identity");
_Static_assert(__builtin_types_compatible_p(Array, Fixed), "incomplete array");
_Static_assert(!__builtin_types_compatible_p(Fixed, Other), "array bounds");
_Static_assert(!__builtin_types_compatible_p(Fixed, int*), "array is not pointer");
_Static_assert(__builtin_types_compatible_p(Function, Prototype), "default promotions");
_Static_assert(!__builtin_types_compatible_p(Function, Promoted), "changed promotion");
_Static_assert(!__builtin_types_compatible_p(struct First, struct Second), "record identity");
_Static_assert(!__builtin_types_compatible_p(enum FirstEnum, enum SecondEnum), "enum identity");
#define IS_ARRAY(arg) (!__builtin_types_compatible_p(__typeof__(arg), __typeof__(&(arg)[0])))
#define ARRAY_LENGTH(arg) (sizeof(arg) / sizeof((arg)[0]) + 0 * sizeof(struct { unsigned check : 1 - 2 * !IS_ARRAY(arg); }))
int main(void) {
  int values[7];
  int *pointer = values;
  return !(ARRAY_LENGTH(values) == 7 && !IS_ARRAY(pointer));
}
