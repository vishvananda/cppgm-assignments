typedef typeof(nullptr) Null;
static int nullptr_t;

static_assert(sizeof(Null) == sizeof(char *));
static_assert(alignof(Null) == alignof(char *));
static_assert(_Generic(nullptr, Null: 1, void *: 0, default: 0));
static_assert(_Generic(true ? nullptr : (void *)0, void *: 1, default: 0));
static_assert(_Generic(true ? (void *)0 : nullptr, void *: 1, default: 0));
static_assert(_Generic(true ? nullptr : nullptr, Null: 1, default: 0));

alignas(Null) static char aligned;
static Null default_null;
static Null initialized_null = (void *)0;
static int *static_pointer = nullptr;
static bool static_bool = nullptr;
static volatile int calls;

static Null produce(void)
{
    ++calls;
    return (void *)0;
}

static bool receive(Null value) { return value; }

int main(void)
{
    Null empty = {};
    Null integer_null = (Null)(42 - 42);
    const Null value = default_null;
    _Atomic Null atomic_value = nullptr;
    atomic_value = 0;
    int *p = produce();
    bool b = produce();
    void (*function)(void) = value;

    if (p || b || function || calls != 2 || static_bool || static_pointer)
        return 1;
    if (receive(false) || receive((void *)0) || receive(integer_null))
        return 2;
    if (value || atomic_value || (value != (20 - 20)) || empty != initialized_null)
        return 3;
    if (produce() != p || calls != 3 || !(value == nullptr) || (value || nullptr))
        return 4;
    return &aligned == nullptr || nullptr_t;
}
