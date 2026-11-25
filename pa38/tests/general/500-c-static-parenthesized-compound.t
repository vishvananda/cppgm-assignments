struct Pair { int left, right; };
struct Holder { struct Pair pair; int tail; };

static struct Pair pair = ((struct Pair){ 3, 5 });
static struct Holder holder = { (((struct Pair){ 7, 11 })), 13 };

int main(void)
{
    return !(pair.left == 3 && pair.right == 5 && holder.pair.left == 7 &&
        holder.pair.right == 11 && holder.tail == 13);
}
