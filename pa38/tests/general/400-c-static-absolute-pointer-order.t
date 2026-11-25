struct record { int value; };
static int signed_order = (struct record *)-1 < (struct record *)1;
static int increasing = (struct record *)1 < (struct record *)-1;
static int zero_first = (struct record *)0 < (struct record *)1;

int main(void)
{
    return signed_order || !increasing || !zero_first;
}
