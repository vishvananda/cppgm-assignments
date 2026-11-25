int ordered(void (*first)(void), void (*second)(void))
{
    return first >= second;
}
