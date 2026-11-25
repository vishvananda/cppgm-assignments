static int storage[] = { 37, 42 };
static void *first = (void *)(__UINTPTR_TYPE__)&storage;
static void *second = (void *)(__UINTPTR_TYPE__)&storage[1];

int main(void)
{
    return *(int *)first != 37 || *(int *)second != 42;
}
