struct Base { int item; };
struct Derived : Base {
    using Base::item, Base::item;
};
