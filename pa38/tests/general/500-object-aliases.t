#if !__has_attribute(alias) || !__has_attribute(__alias__)
#error GNU alias probe must describe the implemented attribute
#endif
static int implementation(int value) { return value + 1; }
int public_alias(int) __attribute__((alias("implementation")));
int weak_alias(int) __attribute__((weak, alias("implementation")));
int chain(int) __attribute__((__alias__("public_alias")));
static int storage = 5;
extern int shared __attribute__((alias("storage")));
int main(void) {
  int (*volatile pointer)(int) = public_alias;
  if (pointer != implementation || pointer != weak_alias || pointer != chain) return 1;
  int* volatile address = &shared;
  if (address != &storage) return 2;
  shared = 9;
  if (storage != 9 || public_alias(41) != 42) return 3;
  return 0;
}
