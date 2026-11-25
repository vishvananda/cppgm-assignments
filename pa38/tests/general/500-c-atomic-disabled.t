#if defined(__wasm__) && !defined(__wasm_atomics__) && !defined(__STDC_NO_ATOMICS__)
#error expected the C11 atomic capability to be disabled
#endif

#if defined(__STDC_NO_ATOMICS__)
_Static_assert(!__atomic_always_lock_free(4, 0), "disabled inline atomics");

int main(void)
{
    volatile unsigned int size = 4;
    return __atomic_is_lock_free(size, 0) || __c11_atomic_is_lock_free(size);
}
#else
_Static_assert(__atomic_always_lock_free(4, 0), "enabled inline atomics");
int main(void) { return 0; }
#endif
