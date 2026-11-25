#include "500-gnu-transparent-union.h"

unsigned long host_read(Argument value, int member)
{
    if (member == 0)
        return value.integer ? *value.integer : 17;
    if (member == 1)
        return value.record->value;
    return value.bits;
}

unsigned long host_call(unsigned long (*read)(Argument, int))
{
    const struct Record record = {31};
    return read(&record, 1) + read(7UL, 2);
}
