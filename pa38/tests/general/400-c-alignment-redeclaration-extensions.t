extern _Alignas(0) int neutral;
int neutral = 1;
extern _Alignas(int) int neutral;

extern _Alignas(32) char tentative;
char tentative;

extern _Alignas(16) char declaration_only;
extern _Alignas(32) char declaration_only;

struct Record;
extern _Alignas(16) struct Record completed;
struct Record { _Alignas(16) char member; };
struct Record completed = {5};

extern _Alignas(16) char gnu_before;
char gnu_before __attribute__((aligned(16))) = 2;

char gnu_after __attribute__((aligned(16))) = 3;
extern _Alignas(16) char gnu_after;

typedef int AlignedInt __attribute__((aligned(16)));
extern _Alignas(16) int alias;
AlignedInt alias = 4;

int main(void)
{
    return neutral + gnu_before + gnu_after + alias + completed.member != 15 ||
           (__UINTPTR_TYPE__)&tentative % 32 ||
           (__UINTPTR_TYPE__)&gnu_before % 16 ||
           (__UINTPTR_TYPE__)&gnu_after % 16 ||
           (__UINTPTR_TYPE__)&alias % 16 ||
           (__UINTPTR_TYPE__)&completed % 16;
}
