extern "C" {
int data_value = 42;
extern int alias_value __attribute__((alias("data_value")));
__attribute__((noinline)) int *data_address() { return &data_value; }
__attribute__((noinline)) int *alias_address() { return &alias_value; }
int observe() { return data_address() == alias_address() && alias_value == 42; }
}
