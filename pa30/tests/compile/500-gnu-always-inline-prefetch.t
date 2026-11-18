extern __inline__ void __attribute__((__gnu_inline__, __always_inline__))
prefetch_hint(const void *address, int selector)
{
  __builtin_prefetch(address, (selector & 4) >> 2, selector & 3);
}

void use_hint(const void *address)
{
  prefetch_hint(address, 3);
}
