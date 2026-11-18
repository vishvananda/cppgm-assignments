inline int bias = 7;
static int adjust(int value) { return value * 3; }
extern "C" int other(int);
extern "C" int sum_fixed(const int* p) {
    int sum = 0;
    for (int i = 0; i != 16; ++i) sum += p[i];
    return sum;
}
int main() {
    static const int values[16] = {1, 2, 3, 4};
    return other(adjust(bias)) + sum_fixed(values);
}
