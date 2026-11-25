void convert(int (**address)[3])
{
    const int (*const *view)[3] = address;
    (void)view;
}
