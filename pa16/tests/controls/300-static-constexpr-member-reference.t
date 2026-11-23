// N3485 [class.static.data]/3 and [basic.def.odr].
// expect exit 0
struct ControlRegions {
    static constexpr unsigned none = 42;
};

constexpr unsigned ControlRegions::none;

const unsigned& bind(const unsigned& value) {
    return value;
}

int main() {
    const unsigned& none = bind(ControlRegions::none);
    return &none == &ControlRegions::none && none == 42 ? 0 : 1;
}
