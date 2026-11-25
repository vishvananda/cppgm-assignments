int call(void);
static int answer = 1 ? 42 : call();
struct Location { int *address; };

int main(void)
{
    int local = answer;
    struct Location value = { &local };
    return *value.address != 42 || __func__[0] != 'm';
}
