struct Padded {
    unsigned char data[12];
};

extern _Atomic(struct Padded) padded;

struct Padded write_padded(struct Padded data)
{
    return (padded = data);
}

struct Padded read_padded(void)
{
    return padded;
}

struct Wide {
    unsigned char data[17];
};

extern volatile _Atomic(struct Wide) wide;
extern struct Wide pass(struct Wide);

struct Wide read_wide(void)
{
    (void)wide;
    return pass(wide);
}

struct Wide return_local(struct Wide data)
{
    _Atomic(struct Wide) local = data;
    return local;
}
