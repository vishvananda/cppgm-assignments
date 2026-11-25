#if __wasi__ != 1 || __wasip1__ != 1
#error WASI Preview 1 target macros are required
#endif

#include <errno.h>
#include <wasi/api.h>

int main(void)
{
	errno = ERANGE;
	if (errno != ERANGE || &errno != __errno_location())
		return 1;
	const __wasi_errno_t status = __WASI_ERRNO_SUCCESS;
	return status;
}
