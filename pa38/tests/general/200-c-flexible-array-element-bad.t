struct Packet { unsigned int count; int data[]; };
union Slot { struct Packet packet; int alternative; };
union Envelope { union Slot slot; double alternative; };
typedef union Envelope Rows[2];
