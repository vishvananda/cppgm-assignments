int supplied_value(int input);

int legacy_value(int input)
{
    return input + 19;
}

int host_call(int input)
{
    return supplied_value(input);
}
