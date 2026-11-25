#define push_macro ignored
#define pop_macro ignored
#define f(x) (x + 1)
#define g 2
#pragma push_macro("f")
#pragma push_macro("g")
#undef f
#define f 3
_Pragma("push_macro(\"f\")")
#undef f
#define f 4
#undef g
#define g 5
f g
#pragma pop_macro("g")
_Pragma("pop_macro(\"f\")")
f g
#pragma pop_macro("f")
f(7) g
#pragma pop_macro("g")
g
#pragma push_macro("absent")
#define absent 6
#pragma pop_macro("absent")
#ifdef absent
#error macro restored as defined
#endif
