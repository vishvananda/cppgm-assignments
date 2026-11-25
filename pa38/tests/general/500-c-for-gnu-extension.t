int main(void)
{
    for (static int index = 0; index != 3; ++index)
        if (index == 2)
            return 0;
    return 1;
}
