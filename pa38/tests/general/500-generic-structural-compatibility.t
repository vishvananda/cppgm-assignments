enum Fruit { apple = 1 };
enum Color { red = 1 };

int main(void)
{
    const int (*array)[3] = 0;
    int (*pointer)(enum Color) = 0;
    return !(_Generic(array,
        char: 0, short: 0, int: 0, long: 0, float: 0, double: 0,
        const int (*)[2]: 0, const int (*)[3]: 1, int (*)[]: 0) &&
        _Generic(pointer,
        int (*)(enum Fruit): 0, char: 0, short: 0, int: 0, long: 0,
        float: 0, double: 0, int (*)(void): 0, int (*)(enum Color): 1));
}
