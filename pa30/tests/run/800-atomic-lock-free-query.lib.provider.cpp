#include <cstddef>
#include <cstdint>

#if defined(__APPLE__)
extern "C" bool atomic_query(std::size_t, const void *) __asm__("___atomic_is_lock_free");
#else
extern "C" bool atomic_query(std::size_t, const void *) __asm__("__atomic_is_lock_free");
#endif

extern "C" bool atomic_query(std::size_t size, const void *address)
{
    return size == 4 && reinterpret_cast<std::uintptr_t>(address) % 4 == 0;
}
