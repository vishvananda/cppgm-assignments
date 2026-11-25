#if !defined(__has_c_attribute)
#error attribute query extension is unavailable
#endif
#define NAME noreturn
#if !__has_c_attribute(NAME) || __has_c_attribute(project::noreturn)
#error incorrect attribute query result
#endif
int main(void) { return 0; }
