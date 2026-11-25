int address(value)
    register int value;
{
    return *&value;
}
