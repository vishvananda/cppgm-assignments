// A loop over a node's three operands also counts their positions in a
// second counter, which the loop over the extra operands continues. The
// first loop's exit test compares a narrowed index, and the other counter's
// step runs between that comparison and the branch: the branch reads the
// comparison's flags, with no truth value in a register.
struct Operand {
    unsigned char kind;
    unsigned index;
};

struct Node {
    unsigned char op;
    Operand ops[3];
    unsigned extra_count;
    const Operand* extra;
};

void note(unsigned* marks, unsigned index);

template<typename F>
static void each_operand(const Node& node, F f) {
    for (const Operand& v : node.ops)
        f(v);
    for (unsigned k = 0; k < node.extra_count; ++k)
        f(node.extra[k]);
}

extern "C" unsigned weigh(const Node* node, unsigned* marks) {
    unsigned position = 0, total = 0;
    each_operand(*node, [&](const Operand& v) {
        const unsigned at = position++;
        if ((node->op == 4 && at == 0) || (node->op == 25 && at == 1) || node->op == 32)
            return;
        if (v.kind == 1)
            total += v.index;
        else if (v.kind == 2)
            note(marks, v.index);
        else if (v.kind == 3)
            note(marks + 1, v.index ^ 5);
        else if (v.kind == 4)
            note(marks + v.index, total);
        else if (v.kind == 5)
            note(marks, marks[v.index] + total);
        else if (v.kind == 6)
            note(marks + 2, marks[v.index] ^ 9);
        else if (v.kind == 7)
            total = total * 5 + marks[v.index];
        else if (v.kind == 8)
            note(marks + total, marks[v.index] * 3);
        else if (v.kind == 9)
            note(marks, marks[v.index + 1] + total);
        else if (v.kind == 10)
            note(marks + 4, v.index + total);
        else if (v.kind == 11)
            note(marks + v.index, marks[total & 7]);
        else if (v.kind == 12)
            note(marks + 3, marks[v.index] | total);
    });
    return total;
}
