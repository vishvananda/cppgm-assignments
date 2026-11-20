#include <coroutine>

struct Task {
  struct promise_type {
    promise_type(int&&);
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
