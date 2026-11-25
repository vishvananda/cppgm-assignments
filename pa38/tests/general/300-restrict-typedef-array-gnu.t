typedef int *Pointers[2];

int main(void)
{
    int first = 4;
    int second = 9;
    restrict Pointers row = {&first, &second};
    int *restrict *p = row;
    return *p[0] + *p[1] != 13;
}
