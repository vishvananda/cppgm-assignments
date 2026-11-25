__attribute__((overloadable)) int choose(int);
__attribute__((overloadable, unavailable)) int choose(...);

int use(double *p)
{
    return sizeof(choose(p));
}
