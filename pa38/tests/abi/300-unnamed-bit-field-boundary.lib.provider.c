#include "300-unnamed-bit-field-boundary.h"

void host_bit_field_layout(unsigned result[10]) {
    bit_field_layout(result);
}

union FloatAndBits host_change_bits(union FloatAndBits input) {
    input.value += 2.5f;
    return input;
}

struct FloatAndZero host_change_zero(struct FloatAndZero input) {
    input.value += 3.5f;
    return input;
}

float host_call_bit_field_peer(union FloatAndBits (*peer)(union FloatAndBits), float input) {
    union FloatAndBits result = peer((union FloatAndBits){ .value = input });
    return result.value;
}
