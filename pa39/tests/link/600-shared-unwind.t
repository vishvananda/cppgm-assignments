extern "C" int exported_add(int x) { return x + 7; }
extern "C" int exported_scale(int x) { return x * 3; }

extern "C" int (*const exported_callback)(int) = exported_add;

int main() { return exported_callback(8) + exported_scale(5); }
