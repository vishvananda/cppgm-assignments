extern int puts(const char *);
extern int atexit(void (*callback)(void));

static void final_low() __attribute__((destructor(201)));
static void final_low()
{
    puts("last");
}

__attribute__((__destructor__)) static void final_high(void)
{
    puts("first");
}

static void exit_callback(void)
{
    puts("callback");
}

int main(void)
{
    if (atexit(exit_callback) != 0)
        return 1;
    puts("main");
    return 0;
}
