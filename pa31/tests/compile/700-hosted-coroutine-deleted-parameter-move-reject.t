#include <coroutine>

struct Task {
  struct promise_type {
    Task get_return_object();
    std::suspend_always initial_suspend() noexcept;
    std::suspend_always final_suspend() noexcept;
    void return_void() noexcept;
    void unhandled_exception() noexcept;
  };
};

struct Argument {
  Argument();
  Argument(const Argument&);
  Argument(Argument&&) = delete;
};

inline Task execute(Argument) {
  co_return;
}
