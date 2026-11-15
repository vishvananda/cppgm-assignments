extern "C" {
extern char __start_entries[], __stop_entries[];
extern const char first_entry[] __attribute__((section("entries"), aligned(1))) = "ab";
extern const char other_entry[] __attribute__((section("different"), aligned(1), used)) = "gap";
int first_address() { return (int)first_entry; }
int observe() {
    int sum = 0;
    for (char *p = __start_entries; p != __stop_entries; ++p) sum += *p;
    return __stop_entries - __start_entries == 6 && sum == 394 && __start_entries[0] == 'a';
}
}
