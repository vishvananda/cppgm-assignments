_Static_assert(1, "condition");
_Alignas(8) static int aligned;
extern _Thread_local int tls;
_Noreturn void stop(void);
typedef _Atomic(int) atomic_int;
typedef _Atomic int qualified_int;
typedef int * _Atomic atomic_pointer;
enum { matches = _Generic(0, int: 1, default: 0), alignment = _Alignof(int) };
