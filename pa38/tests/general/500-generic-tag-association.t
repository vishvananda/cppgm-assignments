struct Item { int value; };
union Choice { int value; long other; };
enum Flag { yes = 1 };

static int outer(struct Item item)
{
    return _Generic(item, struct Item: item.value, default: 0);
}

int main(void)
{
    int original = outer((struct Item){ 4 });
    {
        struct Item { char c; } item = { 'a' };
        union Choice choice = { 3 };
        enum Flag flag = yes;
        int tag = _Generic(item, struct Item: item.c, default: 0);
        int un = _Generic(choice, union Choice: choice.value, default: 0);
        int en = _Generic(flag, enum Flag: flag, default: 0);
        return !(tag == 'a' && un == 3 && en == 1 && original == 4);
    }
}
