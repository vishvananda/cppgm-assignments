struct Base {
    virtual constexpr int value() const { return 1; }
};

struct Derived : Base {
    constexpr int value() const override { return 7; }
};

int read(const Base& object) { return object.value(); }

int main() {
    Derived object;
    return read(object) != 7;
}
