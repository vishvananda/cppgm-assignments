static int thread_local = 7;

int main(void)
{
    auto long value = 3;
    return value != 3 || thread_local != 7;
}
