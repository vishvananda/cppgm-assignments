struct __attribute__((aligned(16))) Header;
struct Header { char prefix; int word; };
enum { header_alignment = alignof(struct Header) };
struct Header { char prefix; signed int word; };

struct __attribute__((packed, aligned(8))) Packet { char prefix; int word; };
struct __attribute__((aligned(8), packed)) Packet { char prefix; signed int word; };

static_assert(alignof(struct Header) == header_alignment);
static_assert(alignof(struct Packet) == 8);
static_assert(__builtin_offsetof(struct Packet, word) == 1);

static volatile struct Header header = { 2, 7 };
static volatile struct Packet packet = { 5, 11 };

int main(void)
{
    return header.prefix + header.word + packet.prefix + packet.word != 25;
}
