// expect exit 0
// N4140 [temp.variadic]
template<class T> T convert(T value) { return value; }
int add() { return 0; }
int add(int a, int b) { return a + b; }

template<class... Outer> auto wrap()
{
    return [](auto... inner) {
        using Result = decltype(add(convert<Outer>(inner)...));
        return static_cast<Result>(add(convert<Outer>(inner)...));
    };
}

int main() { return wrap<int, int>()(2, 3) != 5 || wrap<>()() != 0; }
