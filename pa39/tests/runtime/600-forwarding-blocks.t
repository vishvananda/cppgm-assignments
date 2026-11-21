// Blocks that only merge values and jump on: the descents of a search, the
// cases of a state machine and the paths of a tree insertion around a
// throwing call. A predecessor may branch past such a block to its successor.
struct item {
    item* next[2];
    int key;
};

extern "C" void check_key(int key);
extern "C" item* make_item(int key);
extern "C" item* root;

extern "C" __attribute__((noinline)) const item* find(const item* at, int key) {
    while (at && at->key != key) {
        const item* next;
        if (key < at->key)
            next = at->next[0];
        else
            next = at->next[1];
        at = next;
    }
    return at;
}

extern "C" __attribute__((noinline)) int machine(const unsigned char* text, int count) {
    int state = 0, total = 0;
    for (int i = 0; i < count; ++i) {
        switch (state) {
        case 0:
            state = text[i] & 3;
            break;
        case 1:
            total += text[i];
            state = text[i] > 100 ? 2 : 0;
            break;
        case 2:
            total -= text[i] >> 2;
            state = 3;
            break;
        default:
            state = text[i] & 1;
            break;
        }
    }
    return total + state;
}

extern "C" __attribute__((noinline)) int guarded(const int* keys, int count) {
    int good = 0, bad = 0;
    for (int i = 0; i < count; ++i) {
        try {
            check_key(keys[i]);
            ++good;
        } catch (int value) {
            bad += value;
        }
    }
    return good * 1000 + bad;
}

extern "C" __attribute__((noinline)) int insert_guarded(const int* keys, int count) {
    int failed = 0;
    for (int i = 0; i < count; ++i) {
        const int key = keys[i];
        item* at = root;
        for (;;) {
            const int side = key > at->key;
            if (key == at->key) break;
            item* next = at->next[side];
            if (!next) {
                try {
                    at->next[side] = make_item(key);
                } catch (int value) {
                    failed += value;
                }
                break;
            }
            at = next;
        }
    }
    return failed;
}
