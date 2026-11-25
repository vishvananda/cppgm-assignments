#include "300-c17-array-pointer-extension.inc/system.h"

static int last(int length, const int (*row)[length])
{
    return (*row)[length - 1];
}

static int check(int length, int (*row)[length])
{
    __extension__ const int (*view)[length] = row;
    int compared = __extension__ (row == view);
    long distance = __extension__ (row - view);
    return !compared || distance != 0 ||
           __extension__ (last(length, row)) != 9 || system_last(length, row) != 9;
}

int main(void)
{
    int row[3] = {3, 5, 9};
    volatile int length = 3;
    return check(length, &row);
}
