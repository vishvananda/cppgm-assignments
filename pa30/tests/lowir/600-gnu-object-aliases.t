static int implementation(int value) { return value + 1; }
extern "C" int public_alias(int) __attribute__((alias("_ZL14implementationi")));
extern "C" int weak_alias(int) __attribute__((weak, alias("_ZL14implementationi")));
extern "C" int chain(int) __attribute__((alias("public_alias")));
static int storage = 5;
extern "C" int shared __attribute__((alias("_ZL7storage")));
extern "C" int observe() {
 int (*volatile pointer)(int) = public_alias;
 if (pointer != implementation || pointer != weak_alias || pointer != chain) return 1;
 int* volatile address = &shared;
 if (address != &storage) return 2;
 shared = 9;
 if (storage != 9) return 3;
 return public_alias(41) + (chain == implementation) + (weak_alias == public_alias);
}
int main() { return observe() != 44; }
