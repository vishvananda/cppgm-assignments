// Adjacent loads and stores from one base register. The bounds allow one
// memory instruction per two adjacent words. The other functions put a pair
// at the limits of its offset fields, just past them, at an unaligned offset,
// across an aliasing store, across a load that may read the first store, and
// after a load that replaces the base register.
struct Quad {
    int a, b, c, d;
};

struct __attribute__((packed)) Unaligned {
    int pad;
    long a, b;
};

struct Node {
    Node* next;
    long value;
};

extern "C" int quad_sum(const Quad* q) {
    return (q->a ^ 3) + (q->b ^ 5) + (q->c ^ 7) + (q->d ^ 9);
}

extern "C" long mixed(const long* p) {
    return (p[0] ^ 5) + p[1] * 3 + (p[2] | 1) * p[3];
}

extern "C" double cross(const double* v, const double* w) {
    return v[0] * w[1] - v[1] * w[0];
}

extern "C" long far_words(const long* p) { return p[63] - p[64]; }
extern "C" long past_far(const long* p) { return p[64] - p[65]; }
extern "C" long near_words(const long* p) { return p[-32] - p[-31]; }
extern "C" int far_ints(const int* p) { return p[63] - p[64]; }
extern "C" int past_ints(const int* p) { return p[64] - p[65]; }
extern "C" long unaligned(const Unaligned* u) { return u->a - u->b; }

extern "C" long load_across(long* p, long* q) {
    long a = p[0];
    *q = 5;
    return a - p[1];
}

extern "C" void store_across(long* p, const long* q, long a) {
    p[0] = a;
    long t = *q;
    p[1] = t + 1;
}

extern "C" long next_value(Node* n) {
    n = n->next;
    return n->value;
}

extern "C" void store_far(long* p, long a, long b) {
    p[63] = a;
    p[64] = b;
    p[-32] = b;
    p[-31] = a;
}
