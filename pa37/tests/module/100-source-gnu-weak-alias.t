static int implementation(int value) { return value + 1; }
extern "C" int selected(int) __attribute__((weak, alias("_ZL14implementationi")));
extern "C" int stable(int) __attribute__((alias("_ZL14implementationi")));
int (*volatile selected_pointer)(int) = selected;
extern "C" int observe() {
  return stable(40) == 41 && selected(40) == 42 && selected_pointer(40) == 42 && selected_pointer != stable;
}
