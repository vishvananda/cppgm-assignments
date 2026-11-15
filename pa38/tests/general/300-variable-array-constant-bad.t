int main(void) { const int n = 3; int values[n]; _Static_assert(sizeof values == 3 * sizeof(int), "runtime"); return 0; }
