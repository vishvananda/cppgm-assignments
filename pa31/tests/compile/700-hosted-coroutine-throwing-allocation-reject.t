#include <coroutine>

struct Task {
  struct promise_type {
    static void* operator new(decltype(sizeof(0)));
    static Task get_return_object_on_allocation_failure() noexcept;
    Task get_return_object();
    std::suspend_always initial_suspend() noexcept;
    std::suspend_always final_suspend() noexcept;
    void return_void() noexcept;
    void unhandled_exception() noexcept;
  };
};

inline Task execute(int) {
  co_return;
}
