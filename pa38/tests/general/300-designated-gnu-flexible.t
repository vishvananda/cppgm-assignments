struct Flex { int header; int contents[]; };
static struct Flex flex = { .header = 5, .contents[3] = 12 };

struct Pair { int x, y; };
struct Holder { struct Pair pair; };
static struct Holder holder = { .pair = (struct Pair){ 3, 7 }, .pair.y = 13 };
static void* addresses[] = { [1] = (void*)4096, [3] = 1 ? (void*)8192 : (void*)0,
    [4] = (unsigned char*)4096 + 3 };

int main(void)
{
    return !(flex.header == 5 && flex.contents[0] == 0 && flex.contents[3] == 12 &&
        holder.pair.x == 3 && holder.pair.y == 13 &&
        addresses[0] == 0 && addresses[1] == (void*)4096 && addresses[3] == (void*)8192 &&
        addresses[4] == (void*)4099);
}
