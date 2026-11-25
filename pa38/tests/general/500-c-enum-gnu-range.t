enum Wide { below = -1, top = 4294967295U };

_Static_assert(_Generic(top, long: 1, long long: 1, default: 0), "wide constant type");
_Static_assert(_Generic(below, long: 1, long long: 1, default: 0), "signed wide constant type");

static enum Wide read(void) { return top; }

int main(void)
{
    enum Wide value = read();
    return value != 4294967295ULL || below != -1;
}
