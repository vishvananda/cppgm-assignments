enum Shape { corner = -2, edge, face = 3 };
static enum Shape identity(enum Shape);

enum Shape {
    face = 1 + 2,
    corner = -2,
    edge
};

enum Byte : unsigned char;
enum Byte : unsigned char { first = 7, second };
enum Byte : unsigned char {
    second = _Generic(first, enum Byte: 8),
    first = 7
};

static_assert(_Generic(corner, int: 1, default: 0));
static_assert(_Generic(second, enum Byte: 1, default: 0));

static enum Shape identity(enum Shape value) { return value; }
static volatile enum Shape shape = edge;
static volatile enum Byte byte = second;

int main(void)
{
    return identity(shape) != -1 || byte != 8;
}
