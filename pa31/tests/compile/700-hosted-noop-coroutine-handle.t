#include <coroutine>

void resume_noop()
{
    std::coroutine_handle<> handle = std::noop_coroutine();
    handle.resume();
    handle.destroy();
}
