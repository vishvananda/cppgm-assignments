void* allocate(unsigned alignment) {
  return __builtin_alloca_with_align(32, alignment);
}
