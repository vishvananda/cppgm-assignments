// expect exit 0

struct fields {
    int number;
    union {
        unsigned packed;
        struct { unsigned part : 4; };
    };
};
typedef struct fields Fields;

struct wrapped {
    long header;
    Fields;
};

struct packet {
    long prefix;
    struct wrapped;
    unsigned char suffix;
};

struct explicit_packet {
    long prefix;
    struct { long header; struct fields values; } nested;
    unsigned char suffix;
};

struct sibling {
    char first;
    struct fields;
};

_Static_assert(sizeof(struct packet) == sizeof(struct explicit_packet), "nested anonymous storage size");
_Static_assert(__builtin_offsetof(struct packet, number) ==
               __builtin_offsetof(struct explicit_packet, nested.values.number), "nested anonymous field offset");

static struct packet packet = { .number = 22, .part = 7, .header = 3, .suffix = 4 };
static int *number = &packet.number;

int main(void)
{
    struct sibling sibling = { .number = 9, .part = 5, .first = 8 };
    struct fields named = { .number = 1, .part = 2 };
    struct packet *target = &packet;
    target->part += 2;
    return *number != 22 || target->part != 9 || target->header != 3 || target->suffix != 4
        || sibling.number != 9 || sibling.part != 5 || sibling.first != 8 || named.number != 1 || named.part != 2;
}
