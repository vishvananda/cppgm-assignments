extern "C" unsigned long long sse_low_lanes(unsigned long long);
int main() { return sse_low_lanes(0x300000007ULL) != 0x3800000018ULL; }
