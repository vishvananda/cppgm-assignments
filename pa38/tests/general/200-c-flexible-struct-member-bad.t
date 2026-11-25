struct Packet { unsigned int count; int data[]; };
union Slot { struct Packet packet; int alternative; };
struct Envelope { int tag; union Slot slot; };
