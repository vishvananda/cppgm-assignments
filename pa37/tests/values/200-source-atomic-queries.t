using Size = __SIZE_TYPE__;

static bool query(Size size, void *address)
{
    return __atomic_is_lock_free(size, address);
}

extern "C" int observe()
{
    alignas(8) unsigned char bytes[16] = {};
    volatile Size size = 4;
    if (!query(size, bytes) || query(size, bytes + 1) || !query(size, nullptr))
        return 1;
    size = 3;
    if (query(size, bytes))
        return 2;
    size = 8;
    if (!__c11_atomic_is_lock_free(size))
        return 3;
    size = 16;
    return query(size, bytes) || __c11_atomic_is_lock_free(size);
}
