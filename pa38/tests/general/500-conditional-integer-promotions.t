static signed char a = 7, b = -3;
static _Bool first = 1, second = 0;
static struct { unsigned int left:3, right:3; } bits = { 2, 5 };

_Static_assert(_Generic(1 ? a : b, int: 1, default: 0), "signed char promotion");
_Static_assert(_Generic(1 ? first : second, int: 1, default: 0), "_Bool promotion");
_Static_assert(_Generic(1 ? bits.left : bits.right, int: 1, default: 0), "bit-field promotion");

int main(void)
{
    return !((1 ? a : b) == 7 && (0 ? first : second) == 0 &&
        (0 ? bits.left : bits.right) == 5);
}
