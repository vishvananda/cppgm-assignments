static int state;

static int number(void) { return state += 2; }
static void action(void) { state += 5; }

static void run(int select)
{
    select ? number() : action();
    select ? action() : number();
    1 ? number() : ({ action(); });
}

int main(void)
{
    run(1);
    if (state != 9)
        return 1;
    run(0);
    return state != 18;
}
