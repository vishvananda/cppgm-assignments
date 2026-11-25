struct Flags { unsigned field : 1; };
void f(struct Flags flags) { __auto_type value = flags.field; }
