extern "C" int supplied() __attribute__((weak));
extern "C" int missing() __attribute__((weak));
extern int supplied_value __attribute__((weak));
extern int missing_value __attribute__((weak));

int main() {
    if (missing || &missing_value) return 1;
    if (!supplied || !&supplied_value) return 2;
    return supplied() + supplied_value;
}
