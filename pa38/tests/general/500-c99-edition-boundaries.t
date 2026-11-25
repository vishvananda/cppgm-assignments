enum Choice { VALUE = 40, };
struct Packet { int count; int values[]; };
typedef const int Pair[2];
const Pair pair = { 17, 25 };

static long long first(int values[*]);
static long long first(int values[static const 1])
{
    return values[0];
}

static int variable_size(int count)
{
    typedef int Row[count];
    return sizeof(Row) == count * sizeof(int);
}

int main(void)
{
    const const int *value = &(int){ VALUE + 2 };
    double _Complex z = 3.0;
    _Bool enough = (z == 3.0);
    struct Packet packet = { 0 };
    int values[1] = { *value };
    return !enough || packet.count || first(values) != pair[0] + pair[1] || !variable_size(2);
}
