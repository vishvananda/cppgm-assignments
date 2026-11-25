struct Cell { int value; struct Cell *next; };
typedef struct Cell OuterCell;
union Variant { int payload; unsigned encoded; };
typedef union Variant OuterVariant;
enum State { busy = 7, idle = 3 };
typedef enum State OuterState;

static OuterState state = busy;
static volatile int choose;

static OuterCell echo(OuterCell cell) { return cell; }
static int read_variant(OuterVariant variant) { return variant.payload; }

int main(void)
{
    struct Cell { signed int value; struct Cell *next; } first = { 4, nullptr };
    struct Cell *local = &first;
    OuterCell *outer = local;
    struct Cell second = echo(*outer);
    second.next = local;
    first = choose ? echo(second) : second;

    union Variant { signed int payload; unsigned int encoded; } variant = { first.next->value };
    enum State { idle = 3, busy = 1 + 6 };
    enum State *current = &state;
    return read_variant(variant) != 4 || *current != busy;
}
