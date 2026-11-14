typedef int Integer;
int value = _Generic(0, int: 1, Integer: 2);
