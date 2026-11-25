struct Bytes {
    unsigned char data[3];
};

struct Guarded {
    struct Bytes value;
    unsigned char guard;
};

struct Holder {
    _Atomic(struct Bytes) value;
    unsigned char guard;
};

static struct Bytes read_value(const volatile _Atomic(struct Bytes) *source)
{
    return *source;
}

static unsigned first_byte(struct Bytes value)
{
    return value.data[0];
}

int main(void)
{
    struct Bytes first = {{1, 2, 3}};
    struct Bytes next = {{4, 5, 6}};
    _Atomic(struct Bytes) object = first;
    volatile _Atomic(struct Bytes) other = object;
    struct Holder initialized = { .value = first, .guard = 41 };
    struct Holder omitted = { .guard = 42 };
    struct Guarded result = {{{0}}, 43};
    struct Bytes initial = read_value(&other);
    result.value = (object = next);
    other = object;
    (void)other;
    if (initial.data[2] != 3 || result.value.data[2] != 6 || result.guard != 43 ||
        first_byte(other) != 4 || initialized.guard != 41 || omitted.guard != 42)
        return 1;

    struct Bytes zero = {{0}};
    if (!__c11_atomic_compare_exchange_strong(&initialized.value, &first, next, __ATOMIC_SEQ_CST, __ATOMIC_ACQUIRE))
        return 2;
    if (!__c11_atomic_compare_exchange_strong(&omitted.value, &zero, next, __ATOMIC_SEQ_CST, __ATOMIC_ACQUIRE))
        return 3;
    return 0;
}
