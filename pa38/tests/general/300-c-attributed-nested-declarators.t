#define ATTR __attribute__((unused))

typedef int Callback(ATTR int);

static int add_one(int (ATTR value))
{
    return value + 1;
}

static int invoke(int (ATTR int), int);

static int invoke(Callback *callback, int value)
{
    return callback(value);
}

typedef int (__attribute__((vector_size(16))) *VectorPointer);
typedef int ((__attribute__((mode(QI))) *BytePointer));

_Static_assert(sizeof *(VectorPointer)0 == 16, "vector target");
_Static_assert(sizeof *(BytePointer)0 == 1, "mode target");

int main(void)
{
    int (*callback)(int) = add_one;
    return invoke(callback, 5) != 6 ||
        ((int (ATTR __attribute__(()) *)(int))callback)(6) != 7 ||
        ((int ((ATTR *))(int))callback)(7) != 8;
}
