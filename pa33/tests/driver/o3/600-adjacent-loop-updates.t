// An adjacent sweep can carry a value from its previous iteration.
// The aliasing control may overwrite that value through another pointer.
extern "C" __attribute__((noinline)) void adjacent_updates(int* data, int last) {
    for (int i = 1; i < last; ++i) {
        int left = data[i];
        int right = data[i + 1];
        if (left > right) {
            data[i] = right;
            data[i + 1] = left;
        }
    }
}

extern "C" __attribute__((noinline)) void adjacent_updates_alias(int* data, int last, int* other) {
    for (int i = 1; i < last; ++i) {
        int left = data[i];
        int right = data[i + 1];
        if (left > right) {
            data[i] = right;
            data[i + 1] = left;
            *other = right + 1;
        }
    }
}

int main() {
    adjacent_updates(nullptr, 1);
    int values[] = {99, -4, 8, 3, 8, -1, 6, 98};
    adjacent_updates(values, 6);
    const int expected[] = {99, -4, 3, 8, -1, 6, 8, 98};
    for (int i = 0; i != 8; ++i)
        if (values[i] != expected[i]) return 1;

    int aliased[] = {99, 10, 3, 7, 1, 98};
    adjacent_updates_alias(aliased, 4, aliased + 2);
    const int changed[] = {99, 3, 2, 1, 7, 98};
    for (int i = 0; i != 6; ++i)
        if (aliased[i] != changed[i]) return 2;
    return 0;
}
