#include "300-c-pointer-order-extension.inc/system.h"

static void callback(void)
{
}

int main(void)
{
    int values[2] = {1, 2};
    int *first = values;
    void *second = values + 1;
    void (*call)(void) = callback;
    void (*same)(void) = callback;
    return !__extension__ (call >= same) || !system_order(first, second);
}
