namespace input {
struct Awaitable {};
int operator co_await(Awaitable);

struct Allocated {
    static void* operator new(decltype(sizeof(0)));
};
}

template<class T>
concept IntResult = sizeof(T) == sizeof(int);

template<class T> requires requires(T value) { { operator co_await(value) } -> IntResult; }
struct Await {};

template<class U> requires requires(U operand) { { operator co_await(operand) } -> IntResult; }
struct Await;

template<class T> requires requires { T::operator new(sizeof(0)); }
struct Allocate {};

template<class U> requires requires { U::operator new(sizeof(0)); }
struct Allocate;

int main() {
    Await<input::Awaitable> awaitable;
    Allocate<input::Allocated> allocated;
}
