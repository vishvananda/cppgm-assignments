struct Named {
    unsigned char lead;
    unsigned field : 3 __attribute__((aligned(8)));
    unsigned char tail;
};

struct AttributeScope {
    unsigned first : 3 __attribute__((aligned(8))), second : 3;
    unsigned char tail;
};

struct LeadingSeparator {
    unsigned char lead;
    unsigned __attribute__((aligned(8))) : 0;
    unsigned char tail;
};

struct TrailingSeparator {
    unsigned char lead;
    unsigned : 0 __attribute__((aligned(8)));
    unsigned char tail;
};

struct PackedField {
    unsigned char lead : 3;
    unsigned field : 3 __attribute__((packed, aligned(2)));
    unsigned char tail;
};

union PackedByte {
    unsigned field : 3 __attribute__((packed));
};

union PackedTriple {
    unsigned field : 24 __attribute__((packed));
};

static union PackedByte packed_byte = { .field = 7 };
static union PackedTriple packed_triple = { .field = 0x123456 };

#pragma pack(push, 1)
struct PackedRecord {
    unsigned char lead : 3;
    unsigned field : 3 __attribute__((aligned(2)));
    unsigned char tail;
};
#pragma pack(pop)

int main(void) {
    if (sizeof(struct Named) != 16 || _Alignof(struct Named) != 8 ||
        __builtin_offsetof(struct Named, tail) != 9)
        return 1;
    if (_Alignof(struct AttributeScope) != 8 || __builtin_offsetof(struct AttributeScope, tail) != 1)
        return 2;

#if defined(__linux__) && defined(__aarch64__)
    const unsigned separator_alignment = 8;
#else
    const unsigned separator_alignment = 1;
#endif
    if (_Alignof(struct LeadingSeparator) != separator_alignment ||
        _Alignof(struct TrailingSeparator) != separator_alignment ||
        __builtin_offsetof(struct LeadingSeparator, tail) != 8 ||
        __builtin_offsetof(struct TrailingSeparator, tail) != 8)
        return 3;

    if (_Alignof(struct PackedField) != 2 || __builtin_offsetof(struct PackedField, tail) != 3)
        return 4;
#if defined(__linux__)
    const unsigned packed_tail = 2;
#else
    const unsigned packed_tail = 1;
#endif
    if (_Alignof(struct PackedRecord) != 1 || __builtin_offsetof(struct PackedRecord, tail) != packed_tail)
        return 5;

    struct Named value = { 1, 5, 7 };
    value.field += 1;
    struct PackedField bits = { 4, 5, 8 };
    bits.field -= 2;
    if (sizeof(packed_byte) != 1 || sizeof(packed_triple) != 3 ||
        packed_byte.field != 7 || packed_triple.field != 0x123456)
        return 6;
    packed_byte.field -= 2;
    packed_triple.field += 3;
    return value.lead != 1 || value.field != 6 || value.tail != 7 ||
           bits.lead != 4 || bits.field != 3 || bits.tail != 8 ||
           packed_byte.field != 5 || packed_triple.field != 0x123459;
}
