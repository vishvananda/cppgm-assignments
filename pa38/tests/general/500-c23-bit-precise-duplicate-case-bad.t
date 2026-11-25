int compare(unsigned _BitInt(65) x)
{
    switch (x) {
    case -1:
    case 0x1ffffffffffffffffuwb:
        return 1;
    }
    return 0;
}
