// A field read through an inlined member function: the call's object
// pointer becomes a non-null copy of the field's address. The copy emits
// no instruction, and the next read in between (the subscript's zero
// extension) emits none either, so the load of the array's first element
// pointer takes the field's offset itself, with no separate addition.
struct Node {
    unsigned char op;
    unsigned id, next, extra;
};

template<typename T> struct Array {
    T* first;
    T* last;
    T& operator[](unsigned long i) const { return first[i]; }
};

struct Body {
    char head[104];
    Array<Node> nodes;
    Array<unsigned> order;
};

struct Pass {
    long count;
    Body* body;
};

extern "C" unsigned walk(Pass* p, unsigned first) {
    unsigned total = 0;
    for (unsigned i = first; i != ~0u; i = p->body->nodes[i].next)
        if (p->body->nodes[i].op == 21)
            total += p->body->order[p->body->nodes[i].id];
    return total;
}
