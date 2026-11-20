namespace api
{
    inline namespace v1
    {
        typedef int Result;
        Result count(int);
    }
    double count(double);
}

int api::count(int)
{
    Result result = 1;
    return result;
}

double api::count(double)
{
    return 2.0;
}
