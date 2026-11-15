static int number = 17;
static const int* readonly_number = &number;
static int* global_number = (const int*)&number;
struct Pair { int* first; void* second; };
static int* recover(const int* value) { return value; }
static int* recover_void(const void* value) { return value; }
static void* erase(const int* value) { return value; }
_Static_assert(!__builtin_types_compatible_p(const int*, int*), "types stay distinct");
int main(void) {
  int* assigned = readonly_number;
  int* initialized = readonly_number;
  struct Pair pair = {readonly_number, readonly_number};
  volatile int* volatile_view = &number;
  int* plain = volatile_view;
  const void* handle = &number;
  void* unqualified_void = handle;
  if (recover(readonly_number) != &number || recover_void(handle) != &number) return 1;
  if (erase(readonly_number) != &number || global_number != &number) return 2;
  assigned = readonly_number;
  *assigned = 42;
  if (*initialized != 42 || *plain != 42 || pair.first != &number || pair.second != &number) return 3;
  if (_Generic(readonly_number, const int*: 1, int*: 0) != 1) return 4;
  return unqualified_void != &number;
}
