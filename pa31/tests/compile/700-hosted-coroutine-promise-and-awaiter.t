
#include <coroutine>

struct Task {};
struct Owner { Task run(int) const &; };
struct Promise;
struct Token {};

template<> struct std::coroutine_traits<Task, const Owner&, int> {
  using promise_type = Promise;
};

struct Awaiter {
  bool await_ready() const noexcept;
  bool await_suspend(std::coroutine_handle<Promise>) const noexcept;
  short& await_resume() const noexcept;
};

Awaiter operator co_await(Token) noexcept;

struct Promise {
  Promise() = delete;
  Promise(const Owner&, int&);
  Task get_return_object();
  std::suspend_always initial_suspend() noexcept;
  std::suspend_always final_suspend() noexcept;
  std::suspend_never yield_value(short) noexcept;
  void return_value(int) noexcept;
  void unhandled_exception() noexcept;
  Token await_transform(int) noexcept;
};

inline Task Owner::run(int n) const & {
  auto ordinary = [] { return 5; };
  try {
    short& value = co_await n;
    co_yield value;
  } catch (...) {
    n = 0;
  }
  co_return n + ordinary();
}

struct MoveOnly;
struct Immovable;

struct FallbackTask {
  struct promise_type {
    static void* operator new(decltype(sizeof(0)), MoveOnly&, Immovable&) noexcept;
    static void operator delete(void*, decltype(sizeof(0))) noexcept;
    static FallbackTask get_return_object_on_allocation_failure() noexcept;
    promise_type();
    promise_type(int&&) = delete;
    FallbackTask get_return_object();
    std::suspend_always initial_suspend() noexcept;
    std::suspend_always final_suspend() noexcept;
    void return_void() noexcept;
    void unhandled_exception() noexcept;
  };
};

struct MoveOnly {
  MoveOnly(const MoveOnly&) = delete;
  MoveOnly(MoveOnly&&);
};

struct Immovable {
  Immovable(const Immovable&) = delete;
  Immovable(Immovable&&) = delete;
};

inline FallbackTask fallback(MoveOnly, Immovable&) {
  co_return;
}
