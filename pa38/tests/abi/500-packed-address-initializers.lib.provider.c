#include "500-packed-address-initializers.header.h"

int check_addresses(void)
{
    return descriptors[0].size != 123 || descriptors[0].address != (unsigned long)&payload[1] ||
        descriptors[1].size != 456 || descriptors[1].address != (unsigned long)&payload[2] ||
        slots[0].tag != 8 || slots[0].pointer != &payload[3] || slots[0].tail != 7 ||
        slots[1].tag != 6 || slots[1].pointer != payload || slots[1].tail != 5;
}
