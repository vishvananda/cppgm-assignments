extern int value;
_Static_assert(1 ? 1 : value, "the skipped operand must have an eligible form");
