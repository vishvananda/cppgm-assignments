unsigned long value = 4;
int main() {
    __atomic_store_n(&value, 6UL, __ATOMIC_RELEASE);
    if (__atomic_load_n(&value, __ATOMIC_ACQUIRE) != 6) return 1;
    if (__atomic_add_fetch(&value, 5UL, __ATOMIC_ACQ_REL) != 11) return 2;
    if (__atomic_exchange_n(&value, 3UL, __ATOMIC_SEQ_CST) != 11) return 3;
    unsigned long expected = 12;
    if (__atomic_compare_exchange_n(&value, &expected, 99UL, false, __ATOMIC_SEQ_CST, __ATOMIC_ACQUIRE)) return 4;
    if (expected != 3) return 5;
    if (!__atomic_compare_exchange_n(&value, &expected, 17UL, false, __ATOMIC_RELEASE, __ATOMIC_RELAXED)) return 6;
    __atomic_thread_fence(__ATOMIC_ACQUIRE);
    return value;
}
