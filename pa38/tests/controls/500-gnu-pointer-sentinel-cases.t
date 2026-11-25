// expect exit 0

static int classify(void *tag)
{
    switch ((unsigned long)tag) {
    case (unsigned long)(void *)0:
        return 4;
    case (unsigned long)(void *)1:
        return 9;
    default:
        return 0;
    }
}

int main(void)
{
    return classify(0) != 4 || classify((void *)1) != 9 || classify((void *)2) != 0;
}
