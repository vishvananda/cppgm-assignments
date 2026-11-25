struct Street;
struct House { int number; struct Street *street; };
struct Street { struct House *house; int postal; };
typedef struct House OuterHouse;
typedef struct Street OuterStreet;

int main(void)
{
    {
        struct Street;
        struct House { int number; struct Street *street; };
        static_assert(!__builtin_types_compatible_p(struct House, OuterHouse));
        struct Street { struct House *house; int postal; };
        static_assert(__builtin_types_compatible_p(struct House, OuterHouse));
        static_assert(__builtin_types_compatible_p(struct Street, OuterStreet));
    }
    {
        struct Street;
        struct House { int number; struct Street *street; };
        struct Street { struct House *house; char postal; };
        static_assert(!__builtin_types_compatible_p(struct House, OuterHouse));
        static_assert(!__builtin_types_compatible_p(struct Street, OuterStreet));
    }
    typedef struct { int id; } Untagged;
    typedef Untagged OuterUntagged;
    {
        typedef struct { int id; } Untagged;
        static_assert(!__builtin_types_compatible_p(Untagged, OuterUntagged));
    }
    return 0;
}
