#if defined(__linux__) && defined(__x86_64__) && defined(__GNUC__) && !defined(__clang__)
#ifndef __SIZEOF_FLOAT128__
#error GCC on x86-64 Linux provides __SIZEOF_FLOAT128__
#endif
#endif

#ifdef __SIZEOF_FLOAT128__
static_assert(sizeof(__float128) == __SIZEOF_FLOAT128__, "hosted binary128 size");
#endif

int main() { return 0; }
