// expect exit 0
namespace outer {
template<bool, class T> struct Enable {};
template<class T> struct Enable<true, T> { using type = T; };
template<bool B, class T> using enable_t = typename Enable<B, T>::type;

namespace inner {
template<class T> constexpr bool permitted = true;
template<class T>
constexpr auto read(T value) -> enable_t<inner::permitted<T>, int> {
    return value.item;
}
}

class Value {
public:
    explicit Value(int v) : item(v) {}
private:
    int item;
    template<class T>
    friend constexpr auto inner::read(T value) -> enable_t<inner::permitted<T>, int>;
};
}

int main() { return outer::inner::read(outer::Value(42)) != 42; }
