enum Shape { item = 1 };
enum Shape { item = 1 + 0 * sizeof(enum Shape { item = 1 }) };
