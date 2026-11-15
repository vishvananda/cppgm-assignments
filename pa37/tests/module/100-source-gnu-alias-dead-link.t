extern "C" int absent_function(int);
static int unused_implementation(int value) { return absent_function(value); }
// Emit the public alias, but let the linker discard its unused code and imports.
extern "C" int unused_alias(int) __attribute__((alias("_ZL21unused_implementationi")));
extern "C" int observe() { return 42; }
