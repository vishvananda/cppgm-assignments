#if defined(__wasi__)
#include <errno.h>
#include <stdint.h>
#include <stdlib.h>

// The compiler's WASI host is single-threaded. Keep its logical break separate
// from reserved memory: WebKit can copy the entire heap on each memory.grow.
extern "C" void* sbrk(intptr_t increment)
{
	static uintptr_t position;
	const uintptr_t page = 65536;
	if (!position)
		position = __builtin_wasm_memory_size(0) * page;
	if (!increment)
		return reinterpret_cast<void*>(position);
	if (increment < 0 || static_cast<uintptr_t>(increment) % page)
		abort();
	const uintptr_t amount = static_cast<uintptr_t>(increment);
	if (amount > UINTPTR_MAX - position)
	{
		errno = ENOMEM;
		return reinterpret_cast<void*>(-1);
	}
	const uintptr_t needed = position + amount;
	const uintptr_t pages = __builtin_wasm_memory_size(0);
	const uint64_t available = static_cast<uint64_t>(pages) * page;
	if (needed > available)
	{
		const uintptr_t required = static_cast<uintptr_t>((needed - available + page - 1) / page);
		uintptr_t extra = pages / 4;
		if (extra < 1)
			extra = 1;
		if (extra > 256)
			extra = 256; // Reserve at most 16 MiB beyond the requested break.
		if (extra < required)
			extra = required;
		uintptr_t result = __builtin_wasm_memory_grow(0, extra);
		if (result == UINTPTR_MAX && extra != required)
			result = __builtin_wasm_memory_grow(0, required);
		if (result == UINTPTR_MAX)
		{
			errno = ENOMEM;
			return reinterpret_cast<void*>(-1);
		}
	}
	const uintptr_t before = position;
	position = needed;
	return reinterpret_cast<void*>(before);
}

// Initialize the logical break before a host saves its pre-start memory image.
// Restoring that image then reuses reserved pages instead of leaking capacity.
extern "C" uintptr_t __cppgm_wasi_heap_break()
{
	return reinterpret_cast<uintptr_t>(sbrk(0));
}
#endif
