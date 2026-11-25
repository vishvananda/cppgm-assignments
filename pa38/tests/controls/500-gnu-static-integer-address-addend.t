// expect exit 0

static unsigned char bytes[8];
static unsigned long tail = (unsigned long)&bytes + sizeof(bytes) - 2;
static unsigned long prefix = 4 + (unsigned long)&bytes;
static unsigned long conditional = sizeof(bytes) == 0 ? 0 : (unsigned long)&bytes[1];

int main(void)
{
    return tail != (unsigned long)&bytes[6] || prefix != (unsigned long)&bytes[4] ||
           conditional != (unsigned long)&bytes[1];
}
