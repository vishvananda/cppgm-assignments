#define increment_\u00e9 4
#define increment_\u00E9 4

#define add(\u00e9,\u00f1) (é + ñ + increment_é)
#define add(\u00e9,\u00f1) (é + ñ + increment_é)

#define phrase "\u00e9,\u00\
f1!"
#define phrase "\u00e9,\u00f1!"

#define symbol head_\u00e9_\U000000f1_tail
#define symbol head_\u00e9_\U000000f1_tail
static int head_é_ñ_tail = 5;

int main(void)
{
    return !(add(symbol, 3) == 12 && sizeof phrase == sizeof "é,ñ!" &&
             phrase[2] == ',' && phrase[5] == '!');
}
