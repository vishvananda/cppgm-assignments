int call(int use, int (*prototype)(int), int (*unprototyped)())
{
    return (use ? prototype : unprototyped)();
}
