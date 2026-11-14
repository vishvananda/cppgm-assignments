// expect exit 0
extern "C" {
int __dso_handle;
int capture_thread_callback(void (*callback)(void *), void *context);
int __cxa_thread_atexit(void (*callback)(void *), void *context, void *) {
  return capture_thread_callback(callback, context);
}
void _tlv_atexit(void (*callback)(void *), void *context) {
  capture_thread_callback(callback, context);
}
}
#include "../general/400-thread-exit-callback-boundary.t"
