enum Deferred;
enum Deferred read(void);

int f(void)
{
    read();
    return 0;
}

enum Deferred { ready };
