/* The host object supplies the ABI entry points for this execution test. */
#define THUNK(R) __asm__(".globl __x86_indirect_thunk_" #R "\n" \
                        "__x86_indirect_thunk_" #R ": jmp *%" #R "\n");

THUNK(rax) THUNK(rcx) THUNK(rdx) THUNK(rbx) THUNK(rbp)
THUNK(rsi) THUNK(rdi) THUNK(r8) THUNK(r9) THUNK(r10)
THUNK(r11) THUNK(r12) THUNK(r13) THUNK(r14) THUNK(r15)

static int add(int n) { return n + 8; }

int (*callback)(int) = add;
