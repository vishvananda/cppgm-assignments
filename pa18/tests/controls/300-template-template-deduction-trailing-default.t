template<class T, unsigned N = 1> struct Buffer {};

template<class T> int select(T) { return 0; }
template<class T, template<class> class W> int select(W<T>) { return 1; }

template<class T, template<class> class W> int order(W<T>) { return 1; }
template<class T, unsigned N> int order(const Buffer<T, N>&) { return 2; }

int main() {
  return select(Buffer<int>{}) == 1 && select(Buffer<int, 2>{}) == 0
    && order(Buffer<int>{}) == 2 && order(Buffer<int, 2>{}) == 2 ? 0 : 1;
}
