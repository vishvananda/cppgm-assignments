struct Ops {
    int (*read)(void);
};

int observe(const struct Ops *ops)
{
    return ops->read();
}
