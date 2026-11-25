#if !true || false
#error incorrect preprocessing values for true and false
#endif

static_assert(_Generic(true, bool: 1, default: 0));
static_assert(_Generic(false, _Bool: 1, default: 0), "false has type bool");

int main(void)
{
    bool value = true;
    static_assert(true);
    return value != true || false;
}
