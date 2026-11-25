typedef int Index;
typedef int Index;

struct Packet
{
    int size;
    struct { Index index; };
    union { struct Node *node; void *unused; };
};

struct Node { int value; };

int main(void)
{
    struct Node node = { 7 };
    struct Packet packet = { 2, { 42 }, { &node } };
    return packet.size != 2 || packet.index != 42 || packet.node->value != 7;
}
