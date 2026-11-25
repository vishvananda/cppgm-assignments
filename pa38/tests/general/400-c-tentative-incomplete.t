int one[];
int one[];
int later[];
int later[3];
static int internal[2];
static int internal[];

struct Record pending;
struct Record { int first, last; };

int main(void)
{
    return one[0] || later[2] || internal[1] || pending.first || pending.last;
}
