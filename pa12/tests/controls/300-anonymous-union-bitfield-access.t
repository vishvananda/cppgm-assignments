// expect exit 0
static union
{
    signed int global_field : 4;
    int global_alternative;
};

int main()
{
    union
    {
        unsigned int local_field : 5;
        unsigned int local_alternative;
    };
    local_field = 17;
    global_field = -5;
    ++local_field;
    return local_field != 18 || global_field != -5;
}
