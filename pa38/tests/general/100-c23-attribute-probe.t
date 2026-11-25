#define ATTRIBUTE(x) x
#define QUALIFIED(x) __gnu__::x

#ifndef __has_c_attribute
#error missing C attribute probe
#endif
#if !__has_c_attribute(ATTRIBUTE(__noreturn__))
#error noreturn is a supported standard attribute
#endif
#if __has_c_attribute(__noreturn__) != __has_c_attribute(noreturn)
#error alternate attribute spelling changed the answer
#endif
#if __has_c_attribute(_Noreturn) != __has_c_attribute(noreturn) || \
    __has_c_attribute(___Noreturn__) != __has_c_attribute(noreturn)
#error the _Noreturn spelling changed the answer
#endif
#if !__has_c_attribute(QUALIFIED(aligned))
#error missing supported GNU namespace attribute
#endif
#if __has_c_attribute(project_unknown) || __has_c_attribute(project::noreturn)
#error unrecognized attribute must return zero
#endif

#if 0
#elifdef __has_c_attribute
#define RESULT 42
#endif

#define noreturn _Noreturn
[[noreturn, __noreturn__, ___Noreturn__]] static void die(void)
{
    for (;;) { }
}

int main(void)
{
    if (RESULT != 42)
        die();
    return 0;
}
