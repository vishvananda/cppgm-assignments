struct ZeroSeparator {
    unsigned char first : 3;
    unsigned : 0;
    unsigned char last : 5;
};

struct NonzeroSeparator {
    unsigned char first : 3;
    unsigned : 3;
    unsigned char last : 5;
};

union AlignedBits {
    unsigned char value : 3;
    unsigned : 0;
};

struct __attribute__((packed)) PackedSeparator {
    unsigned char first : 3;
    unsigned : 0;
    unsigned char last : 5;
};

#pragma pack(push, 1)
struct PragmaSeparator {
    unsigned char first : 3;
    unsigned : 0;
    unsigned char last : 5;
};
#pragma pack(pop)

union FloatAndBits {
    float value;
    unsigned : 1;
};

struct FloatAndZero {
    float value;
    unsigned : 0;
};

static inline void bit_field_layout(unsigned result[10]) {
    result[0] = sizeof(struct ZeroSeparator);
    result[1] = _Alignof(struct ZeroSeparator);
    result[2] = sizeof(struct NonzeroSeparator);
    result[3] = _Alignof(struct NonzeroSeparator);
    result[4] = sizeof(union AlignedBits);
    result[5] = _Alignof(union AlignedBits);
    result[6] = sizeof(struct PackedSeparator);
    result[7] = _Alignof(struct PackedSeparator);
    result[8] = sizeof(struct PragmaSeparator);
    result[9] = _Alignof(struct PragmaSeparator);
}

void host_bit_field_layout(unsigned result[10]);
union FloatAndBits host_change_bits(union FloatAndBits input);
struct FloatAndZero host_change_zero(struct FloatAndZero input);
float host_call_bit_field_peer(union FloatAndBits (*peer)(union FloatAndBits), float input);
