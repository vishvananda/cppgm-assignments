typedef int (*Callback)(int);
static int add_one(int value) { return value + 1; }
static void* global_handle = add_one;
static Callback global_callback;
static void* erase(Callback function) { return function; }
static Callback restore(void* handle) { return handle; }
static int invoke(Callback function, int value) { return function(value); }
static void write_offset(unsigned long long* result) { *result = 123; }
static unsigned* change_sign(int* value) { return value; }
_Static_assert(!__builtin_types_compatible_p(int*, unsigned*), "conversion is not type compatibility");
_Static_assert(_Generic((int*)0, int*: 1, unsigned*: 0), "generic selection keeps signedness");
int main(void) {
  void* handle = erase(add_one);
  Callback function = restore(handle);
  if (invoke(handle, 40) != 41 || function(41) != 42) return 1;
  global_callback = global_handle;
  if (global_callback(6) != 7) return 2;
  const void* qualified_handle = add_one;
  Callback qualified_callback = qualified_handle;
  if (qualified_callback(7) != 8) return 3;
  if (handle != add_one || add_one != handle) return 4;
  Callback selected = 1 ? add_one : handle;
  if (selected(8) != 9 || (0 ? handle : add_one) != handle) return 5;
  long long offset = -1;
  write_offset(&offset);
  if (offset != 123) return 6;
  int value = 17;
  unsigned* different = change_sign(&value);
  *different = 19;
  unsigned* assigned = &value;
  struct Holder { unsigned* address; } holder = {&value};
  if (value != 19 || different != &value || holder.address != assigned) return 7;
  void* common = value ? &value : different;
  if (common != &value) return 8;
  const int original = 23;
  const unsigned* observed = &original;
  unsigned* sign_and_qualification = &original;
  if (*observed != 23 || *sign_and_qualification != 23) return 9;
  char bytes[2] = {3, 5};
  signed char* signed_bytes = bytes;
  unsigned char* unsigned_bytes = signed_bytes;
  char* recovered = unsigned_bytes;
  if (recovered != bytes || recovered[1] != 5) return 10;
  short narrow = 2;
  unsigned short* unsigned_narrow = &narrow;
  long wide = 3;
  unsigned long* unsigned_wide = &wide;
  __int128 extra = 5;
  unsigned __int128* unsigned_extra = &extra;
  return *unsigned_narrow != 2 || *unsigned_wide != 3 || *unsigned_extra != 5;
}
