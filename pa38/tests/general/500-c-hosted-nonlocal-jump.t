#include <setjmp.h>

typedef jmp_buf jump_buffer;

#ifdef __wasi__
static jump_buffer target;
static volatile int visited;

static void leave(void)
{
    visited = 1;
    longjmp(target, 0);
}

int main(void)
{
    switch (setjmp(target)) {
    case 0: leave(); return 1;
    case 1: return visited != 1;
    default: return 2;
    }
}
#endif
