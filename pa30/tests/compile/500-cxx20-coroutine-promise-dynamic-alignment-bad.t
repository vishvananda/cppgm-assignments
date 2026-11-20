void* promise(void* handle, int alignment) {
  return __builtin_coro_promise(handle, alignment, false);
}
