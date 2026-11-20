#include <coroutine>

struct Value {};

struct Task {
  struct promise_type {
    Task get_return_object();
    std::suspend_always initial_suspend() noexcept;
    std::suspend_always final_suspend() noexcept;
    void unhandled_exception() noexcept;
    void return_value(Value&&) = delete;
    void return_value(Value&);
  };
};

Task run() {
  Value value;
  co_return value;
}
