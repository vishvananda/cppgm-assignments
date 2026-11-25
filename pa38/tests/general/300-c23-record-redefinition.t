struct Node {
    int value;
    struct Node *next;
    struct { union { int number; unsigned code; }; };
    unsigned kind : 3;
    unsigned : 0;
    alignas(16) int high;
};
typedef struct Node Node;
static Node leaf = { .value = 4, .number = 6, .kind = 3, .high = 5 };

struct Node {
    static_assert(sizeof(Node) == sizeof(leaf));
    typeof(leaf.value) value;
    Node *next;
    struct { union { int number; unsigned code; }; };
    unsigned kind : 1 + 2;
    unsigned : 0;
    alignas(8 * 2) int high;
};

union Side { int left; unsigned right; };
static int inspect(union Side);
union Side { signed int left; unsigned int right; };

static int inspect(union Side side) { return side.left; }

int main(void)
{
    struct Node first = { .next = &leaf };
    union Side side = { .left = first.next->value };
    return inspect(side) + first.next->number + first.next->kind + first.next->high != 18;
}
