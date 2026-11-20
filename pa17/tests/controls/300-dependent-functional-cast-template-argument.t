// expect exit 0
template<bool Flag, class T> struct Select { using type = T; };
template<class T> struct Wrapped {};
template<class T> struct Traits
{
    enum { ready = true };
    using result = T;
};
template<class T> struct Traits<Wrapped<T>> : Traits<T>
{
    using Base = Traits<T>;
    using result = typename Select<bool(Base::ready), typename Base::result>::type;
};

int main()
{
    Traits<Wrapped<int>>::result n = 42;
    return n != 42;
}
