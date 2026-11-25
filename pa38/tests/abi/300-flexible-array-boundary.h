struct Packet {
    unsigned count;
    int data[];
};

union PacketSlot {
    struct Packet packet;
    double align;
};

union Envelope {
    union PacketSlot slot;
    unsigned long long align;
};

struct Packet host_advance(struct Packet value, unsigned increment);
unsigned host_call(union Envelope (*update)(union Envelope, unsigned), unsigned initial);
