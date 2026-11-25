unsigned dispatch(unsigned operation, unsigned count)
{
    static const void* targets[] = {&&add, &&subtract, &&done};
    unsigned result = 19;
    if (operation > 2 || count == 0)
        return 0;
    goto *targets[operation];
add:
    result += 7;
    if (--count)
        goto *targets[1];
    return result;
subtract:
    result -= 3;
    if (--count)
        goto *targets[0];
done:
    return result;
}

int main()
{
    return dispatch(0, 3) != 30 || dispatch(1, 4) != 27 ||
        dispatch(2, 1) != 19 || dispatch(3, 1) != 0;
}
