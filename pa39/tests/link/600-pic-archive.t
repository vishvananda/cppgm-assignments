extern "C" long external_value;
extern "C" long read_external() { return external_value + 2; }
int main() { return int(read_external()); }
