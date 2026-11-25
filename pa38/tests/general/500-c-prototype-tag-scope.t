typedef int Callback(struct PrototypeTag *);

struct PrototypeTag { int value; };

_Static_assert(_Generic((Callback *)0,
                       int (*)(struct PrototypeTag *): 0,
                       default: 1),
               "the tag declared in a prototype has its own scope");

int definition(struct DefinitionTag { int value; } *first,
               struct DefinitionTag *second)
{
    struct DefinitionTag object = { 4 };
    return object.value + (first == second);
}

int main(void)
{
    return definition(0, 0) != 5;
}
