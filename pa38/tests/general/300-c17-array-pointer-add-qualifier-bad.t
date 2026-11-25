void accept(int length, const int (*array)[length]);

void forward(int length, int (*array)[length])
{
    accept(length, array);
}
