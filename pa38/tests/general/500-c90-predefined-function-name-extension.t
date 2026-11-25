int main(void)
{
    const char *name = __extension__ (__func__);
    return name[0] != 'm' || name[4] != '\0';
}
