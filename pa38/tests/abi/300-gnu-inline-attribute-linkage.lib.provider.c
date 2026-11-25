extern int export_value(int);

int host_call(int n)
{
    return export_value(n);
}

int service(int n)
{
    return n + 12;
}
