extern void observe(int);
extern volatile int observed;

int with_array(int n)
{
    volatile char values[n];
    values[n - 1] = 19;
    observe(n);
    return values[n - 1];
}

int main(void)
{
    return with_array(3) != 19 || observed != 3;
}
