// expect exit 0
template<class T> auto unwrap(T value) {
    auto copy = value;
    return copy;
}

template<class T, class U> struct Iterator;
template<class T> struct Iterator<T, T> {
    static auto rewrap(T value, decltype(unwrap(value)) original) {
        return value + original;
    }
};

int main() { return Iterator<int, int>::rewrap(17, 25) != 42; }
