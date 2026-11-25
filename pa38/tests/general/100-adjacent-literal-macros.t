#define MIDDLE "bc"
#define PLUS_ONE + 1

char joined[] = "a"MIDDLE"d";

int main(void)
{
    return sizeof joined != 5 || joined[1] != 'b' ||
           joined[3] != 'd' || ('a'PLUS_ONE) != 'b';
}
