#define TERMS 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 \
            + 11 + 12 + 13 + 14 + 15 + 16 + 17 + 18 + 19 + 20
#define WRAP(x) (x)
#define TWICE(x) x, x
#define FIRST(x, y) x
#define SECOND(x, y) y
#define VALUE 41
#pragma push_macro("VALUE")
#undef VALUE

TWICE(WRAP(WRAP(WRAP(TERMS + VALUE + __COUNTER__))))
FIRST(WRAP(WRAP(WRAP(TERMS + VALUE))),
#define VALUE 23
      unused)
SECOND(WRAP(WRAP(WRAP(TERMS + __COUNTER__))),
       WRAP(WRAP(WRAP(TERMS + VALUE))))
#pragma pop_macro("VALUE")
TWICE(WRAP(WRAP(WRAP(TERMS + VALUE + __COUNTER__))))
__COUNTER__
