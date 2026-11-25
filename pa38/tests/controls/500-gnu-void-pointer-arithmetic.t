// expect exit 0

static unsigned char bytes[12];
static void *const initial = (void *)bytes + 4;

static void *walk(void *pointer, int count)
{
    pointer += count;
    ++pointer;
    return pointer - 2;
}

int main(void)
{
    volatile int count = 3;
    void *result = walk(initial, count);
    return result != bytes + 6 || result - (void *)bytes != 6
        || (void *)bytes - result != -6;
}
