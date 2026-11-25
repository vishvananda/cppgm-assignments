typedef int Pair[2];

int main(void)
{
    int calls = 0;
    if (sizeof (int){ ++calls } != sizeof(int))
        return 1;
    if (sizeof (Pair){ ++calls, 7 } != sizeof(Pair))
        return 2;
    if (sizeof (Pair){ 3, 4 }[1] != sizeof(int))
        return 3;
    return calls != 0;
}
