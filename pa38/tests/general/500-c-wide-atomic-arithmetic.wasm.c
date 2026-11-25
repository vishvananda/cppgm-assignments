/* The provider simulates an intervening write to check retry behavior. */
typedef __SIZE_TYPE__ size_t;
extern _Atomic long double number;
extern long double post(void);
extern long double add_once(void);
extern int run_updates(void);

static int retry_pending;
static int invalid_order;

static void transfer(size_t size, const void *source, void *result)
{
    const unsigned char *input = source;
    unsigned char *output = result;
    for (size_t i = 0; i < size; ++i)
        output[i] = input[i];
}

void load_value(size_t, const void *, void *, int) __asm__("__atomic_load");
void store_value(size_t, void *, const void *, int) __asm__("__atomic_store");
_Bool replace_value(size_t, void *, void *, const void *, int, int) __asm__("__atomic_compare_exchange");

void load_value(size_t size, const void *source, void *result, int order)
{
    if (order != __ATOMIC_RELAXED && order != __ATOMIC_SEQ_CST)
        invalid_order = 1;
    transfer(size, source, result);
}

void store_value(size_t size, void *result, const void *source, int order)
{
    if (order != __ATOMIC_SEQ_CST)
        invalid_order = 1;
    transfer(size, source, result);
}

_Bool replace_value(size_t size, void *object, void *expected, const void *desired, int success, int failure)
{
    if (success != __ATOMIC_SEQ_CST || failure < __ATOMIC_RELAXED || failure > __ATOMIC_SEQ_CST ||
        failure == __ATOMIC_RELEASE || failure == __ATOMIC_ACQ_REL)
        invalid_order = 1;
    if (retry_pending && object == (void *)&number && size == sizeof(long double)) {
        long double replacement = 8.0L;
        transfer(size, &replacement, object);
        retry_pending = 0;
    }
    const unsigned char *current = object;
    const unsigned char *before = expected;
    for (size_t i = 0; i < size; ++i)
        if (current[i] != before[i]) {
            transfer(size, object, expected);
            return 0;
        }
    transfer(size, desired, object);
    return 1;
}

int probe(void)
{
    if (run_updates())
        return 1;
    number = 1.0L;
    retry_pending = 1;
    if (post() != 8.0L || number != 9.0L || retry_pending)
        return 2;
    number = 1.0L;
    retry_pending = 1;
    if (add_once() != 10.0L || number != 10.0L || retry_pending)
        return 3;
    return invalid_order ? 4 : 0;
}
