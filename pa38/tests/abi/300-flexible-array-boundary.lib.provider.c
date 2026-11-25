#include "300-flexible-array-boundary.h"

struct Packet host_advance(struct Packet value, unsigned increment) {
    value.count += increment;
    return value;
}

unsigned host_call(union Envelope (*update)(union Envelope, unsigned), unsigned initial) {
    union Envelope input = { .slot.packet.count = initial };
    union Envelope result = update(input, 16);
    return result.slot.packet.count;
}
