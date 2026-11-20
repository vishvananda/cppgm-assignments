#include <coroutine>

struct Next {
  std::coroutine_handle<> continuation;
  bool await_ready() const noexcept { return false; }
  std::coroutine_handle<> await_suspend(std::coroutine_handle<>) const noexcept {
    return continuation;
  }
  void await_resume() const noexcept {}
};

struct TransferTask {
  struct promise_type {
    std::coroutine_handle<> continuation;
    explicit promise_type(std::coroutine_handle<>& next) noexcept : continuation(next) {}
    TransferTask get_return_object() noexcept;
    std::suspend_always initial_suspend() noexcept { return {}; }
    Next final_suspend() noexcept { return {continuation}; }
    void return_void() noexcept {}
    void unhandled_exception() noexcept {}
  };
};

inline TransferTask transfer(std::coroutine_handle<> next) {
  co_return;
}
