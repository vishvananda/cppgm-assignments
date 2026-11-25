static int empty[] = {};

int main(void)
{
    int local[] = {};
    return sizeof(empty) != 0 || sizeof(local) != 0;
}
