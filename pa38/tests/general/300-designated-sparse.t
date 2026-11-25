static const unsigned char shared[] = { [2048] = 7, [2] = 4 };
_Static_assert(sizeof shared == 2049, "largest index completes the array");

int main(void)
{
    unsigned char local[] = { [1024] = 9, [3] = 5, 6 };
    volatile unsigned short observable[25] = { [20] = 8 };
    return !(sizeof local == 1025 && local[0] == 0 && local[3] == 5 && local[4] == 6 &&
        local[512] == 0 && local[1024] == 9 && shared[0] == 0 && shared[2] == 4 &&
        shared[2047] == 0 && shared[2048] == 7 && observable[0] == 0 &&
        observable[20] == 8 && observable[24] == 0);
}
