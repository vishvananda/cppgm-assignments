/* Supply the generic atomic ABI for this single-threaded Wasm test. */
typedef __SIZE_TYPE__ size_t;

struct Padded {
    unsigned char data[12];
};

struct Wide {
    unsigned char data[17];
};

_Atomic(struct Padded) padded;
volatile _Atomic(struct Wide) wide;

extern struct Padded write_padded(struct Padded data);
extern struct Padded read_padded(void);
extern struct Wide read_wide(void);
extern struct Wide return_local(struct Wide data);

static int invalid;

static void transfer(size_t size, const void *source, void *result)
{
    const unsigned char *input = source;
    unsigned char *output = result;
    for (size_t i = 0; i < size; ++i)
        output[i] = input[i];
}

void load_value(size_t, const void *, void *, int) __asm__("__atomic_load");
void store_value(size_t, void *, const void *, int) __asm__("__atomic_store");

void load_value(size_t size, const void *source, void *result, int order)
{
    if ((size != sizeof(padded) && size != sizeof(wide)) || order != __ATOMIC_SEQ_CST)
        invalid = 1;
    else
        transfer(size, source, result);
}

void store_value(size_t size, void *result, const void *source, int order)
{
    load_value(size, source, result, order);
}

struct Wide pass(struct Wide value)
{
    return value;
}

int probe(void)
{
    struct Padded next = {{11, 22, 33}};
    next.data[11] = 99;
    if (write_padded(next).data[11] != 99 || read_padded().data[1] != 22)
        return 1;
    struct Wide value = {{17, 21}};
    value.data[16] = 42;
    wide = value;
    if (read_wide().data[16] != 42 || return_local(value).data[0] != 17)
        return 2;
    return invalid ? 3 : 0;
}
