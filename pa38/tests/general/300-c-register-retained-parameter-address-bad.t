int address(register int length, int values[static length])
{
    return *&length + values[0];
}
