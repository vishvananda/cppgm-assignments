static volatile int local = 19;
extern volatile int external;

int read_values(void)
{
    return local + external;
}
