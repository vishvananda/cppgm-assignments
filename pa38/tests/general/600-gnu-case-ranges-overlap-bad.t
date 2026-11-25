int classify(int n)
{
    switch (n) {
    case -4 ... 4:
        return 1;
    case 2:
        return 2;
    default:
        return 0;
    }
}
