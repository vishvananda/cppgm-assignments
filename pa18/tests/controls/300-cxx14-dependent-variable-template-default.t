// expect exit 0
// N4140 [temp.arg], [temp.dep.temp], [temp.deduct]
template<bool, class T = void> struct Enable {};
template<class T> struct Enable<true, T> { using type = T; };
template<bool Condition> using Allowed = typename Enable<Condition>::type;

template<class Outer> struct Predicate {
    template<class A, class B> static constexpr bool accept = sizeof(Outer) == sizeof(A);
};

template<class T> struct Receiver {
    int selected;
    template<class A, class B, class = Allowed<Predicate<T>::template accept<A, B>>>
    Receiver(A, B) : selected(1) {}
    Receiver(...) : selected(2) {}
};

int main() { return Receiver<int>(1, 2).selected != 1 || Receiver<char>(1, 2).selected != 2; }
