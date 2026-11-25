// expect exit 0

typedef int (*callback)(void);

static int answer(void) { return 42; }

static int check(callback original, int offset)
{
    callback later = original + offset;
    callback earlier = later--;
    later -= offset - 1;
    return earlier - original == offset && later == original && later() == 42;
}

int main(void) { return !check(answer, 7); }
