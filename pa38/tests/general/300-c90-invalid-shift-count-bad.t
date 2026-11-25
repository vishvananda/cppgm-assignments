enum { VALUE = 1 << (sizeof(int) * __CHAR_BIT__) };

int main(void)
{
    return VALUE;
}
