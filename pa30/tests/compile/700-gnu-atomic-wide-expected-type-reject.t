bool replace(__int128* object, long long* expected, __int128 desired)
{
    return __atomic_compare_exchange_n(object, expected, desired, false, __ATOMIC_SEQ_CST, __ATOMIC_RELAXED);
}
