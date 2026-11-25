#if !__has_c_attribute(gnu::aligned) || __has_c_attribute(project::noreturn)
#error incorrect qualified attribute query in C90
#endif
int main(void) { return 0; }
