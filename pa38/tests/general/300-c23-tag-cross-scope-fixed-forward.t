enum State : int;

struct Slot { enum State value; };
typedef struct Slot OuterSlot;
typedef enum State OuterState;

int main(void)
{
    enum State : int;
    struct Slot { enum State value; };
    static_assert(__builtin_types_compatible_p(enum State, OuterState));
    static_assert(__builtin_types_compatible_p(struct Slot, OuterSlot));

    enum State : int { first = 1 };
    static_assert(!__builtin_types_compatible_p(enum State, OuterState));
    static_assert(!__builtin_types_compatible_p(struct Slot, OuterSlot));
    return first != 1;
}
