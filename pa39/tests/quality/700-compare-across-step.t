// A reversed iterator steps its pointers after the loop's comparison. The
// comparison still branches on its flags; the pointer steps run between
// them without a materialized truth value.
template<typename T>
struct Reversed {
    T* at;
    T& operator*() const { return at[-1]; }
    Reversed& operator++() { --at; return *this; }
    Reversed& operator--() { ++at; return *this; }
    Reversed operator++(int) { Reversed old = *this; --at; return old; }
    bool operator!=(Reversed other) const { return at != other.at; }
};

template<typename Iterator, typename T>
static void insertion_sort(Iterator begin, Iterator end) {
    Iterator p = begin;
    p++;
    while (p != end) {
        T tmp = *p;
        Iterator j = p;
        Iterator prev = j;
        for (; j != begin && tmp < *--prev; --j)
            *j = *prev;
        *j = tmp;
        p++;
    }
}

extern "C" void sort_descending(double* first, double* last) {
    insertion_sort<Reversed<double>, double>(Reversed<double>{last}, Reversed<double>{first});
}
