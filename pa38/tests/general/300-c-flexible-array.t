#if __STDC_HOSTED__
#include <stdlib.h>
#endif

struct Packet { unsigned int count; int data[]; };
union Slot { struct Packet packet; int alternative; };
union Envelope { union Slot slot; double alternative; };

static union Envelope initial = { .slot.packet.count = 3 };
static struct Packet *pointers[2];

#if __STDC_VERSION__ >= 201112L
struct Flattened {
    union { unsigned int count; };
    int data[];
};
static struct Flattened flattened = { .count = 7 };
#endif

int main(void)
{
    int ok = initial.slot.packet.count == 3;
#if __STDC_HOSTED__
    struct Packet *packet = malloc(sizeof(*packet) + 3 * sizeof(packet->data[0]));
    if (!packet)
        return 1;
    packet->count = initial.slot.packet.count;
    packet->data[0] = 11;
    packet->data[1] = 22;
    packet->data[2] = 33;
    pointers[1] = packet;

    struct Packet header = *pointers[1];
    ok = ok && header.count == 3 && packet->data[0] == 11 &&
        packet->data[1] == 22 && packet->data[2] == 33;
    free(packet);
#else
    pointers[1] = &initial.slot.packet;
    ok = ok && pointers[1]->count == 3;
#endif
#if __STDC_VERSION__ >= 201112L
    ok = ok && flattened.count == 7;
#endif
    return !ok;
}
