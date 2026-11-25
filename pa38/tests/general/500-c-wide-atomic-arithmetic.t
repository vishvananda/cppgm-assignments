_Atomic long double number;
static unsigned address_visits;
static unsigned argument_visits;

static _Atomic long double *select_number(void)
{
    ++address_visits;
    return &number;
}

static long double increment(void)
{
    ++argument_visits;
    return 2.0L;
}

long double post(void)
{
    return number++;
}

long double add_once(void)
{
    address_visits = argument_visits = 0;
    long double result = (*select_number() += increment());
    return address_visits == 1 && argument_visits == 1 ? result : -1.0L;
}

static int complex_update(void)
{
    _Atomic(long double _Complex) value = __builtin_complex(1.0L, 2.0L);
    long double _Complex result = (value += __builtin_complex(2.0L, 3.0L));
    return __real__ result == 3.0L && __imag__ result == 5.0L &&
        value == result;
}

#ifdef __SIZEOF_INT128__
__extension__ typedef __int128 WideInt;

static int integer_update(void)
{
    WideInt base = (WideInt)1 << 80;
    _Atomic(WideInt) local = base;
    struct Holder { _Atomic(WideInt) member; } holder = { .member = base };
    if (local++ != base || ++holder.member != base + 1 ||
        (local += base) != 2 * base + 1 || local != 2 * base + 1)
        return 0;
    WideInt value;
    __atomic_store_n(&value, base, __ATOMIC_SEQ_CST);
    if (__c11_atomic_fetch_add(&local, 1, __ATOMIC_SEQ_CST) != 2 * base + 1 ||
        __atomic_fetch_add(&value, 7, __ATOMIC_SEQ_CST) != base)
        return 0;
    WideInt expected = base + 7;
    return __atomic_compare_exchange_n(&value, &expected, base, 0, __ATOMIC_SEQ_CST, __ATOMIC_ACQUIRE) &&
        __atomic_load_n(&value, __ATOMIC_SEQ_CST) == base && local == 2 * base + 2;
}
#endif

int run_updates(void)
{
    number = 3.0L;
    if (post() != 3.0L || --number != 3.0L || add_once() != 5.0L || number != 5.0L)
        return 1;
    if (!complex_update())
        return 2;
#ifdef __SIZEOF_INT128__
    if (!integer_update())
        return 3;
#endif
    return 0;
}
